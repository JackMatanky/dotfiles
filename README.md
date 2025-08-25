# Chezmoi Dotfiles

Personal configuration files managed with **[chezmoi](https://www.chezmoi.io/)** for **macOS** and **Linux**.

## Table of Contents

- [Chezmoi Dotfiles](#chezmoi-dotfiles)
  - [Table of Contents](#table-of-contents)
  - [Quick Start](#quick-start)
    - [Fresh Installation](#fresh-installation)
    - [Existing Installation](#existing-installation)
  - [System Architecture](#system-architecture)
    - [Modular Design Philosophy](#modular-design-philosophy)
    - [Data-Driven Configuration](#data-driven-configuration)
    - [Template System](#template-system)
    - [Automated Package Management](#automated-package-management)
  - [Repository Structure](#repository-structure)
  - [Configuration](#configuration)
    - [Personal Information](#personal-information)
    - [Development Environment](#development-environment)
    - [System Preferences](#system-preferences)
    - [Package Management](#package-management)
  - [Static Configuration Data (.chezmoidata)](#static-configuration-data-chezmoidata)
    - [Data Files Overview](#data-files-overview)
    - [Package Definitions](#package-definitions)
    - [Application Configurations](#application-configurations)
    - [Path Management](#path-management)
  - [Automated Package Management System (.chezmoiscripts)](#automated-package-management-system-chezmoiscripts)
    - [Two-Phase Installation Pattern](#two-phase-installation-pattern)
    - [Script Categories](#script-categories)
    - [Hash-Based Detection](#hash-based-detection)
    - [Cross-Platform Support](#cross-platform-support)
    - [Package Categories](#package-categories)
      - [Platform-Specific](#platform-specific)
      - [Language Ecosystems](#language-ecosystems)
    - [Installation Scripts](#installation-scripts)
    - [Usage Examples](#usage-examples)
      - [Adding a New Package](#adding-a-new-package)
      - [Triggering Installation](#triggering-installation)
      - [Installing Everything on New Machine](#installing-everything-on-new-machine)
    - [Benefits](#benefits)
  - [Template Library (.chezmoitemplates)](#template-library-chezmoitemplates)
    - [Shared Templates](#shared-templates)
    - [Logging Functions](#logging-functions)
    - [Text Expansion Templates](#text-expansion-templates)
    - [Template Best Practices](#template-best-practices)
  - [Core System Tools](#core-system-tools)
    - [Shells](#shells)
    - [Terminal Emulators](#terminal-emulators)
    - [Shell Enhancements](#shell-enhancements)
    - [CLI Utilities](#cli-utilities)
    - [Version Control](#version-control)
  - [Development Environment](#development-environment-1)
    - [Editors](#editors)
    - [Language Server Protocols (LSPs)](#language-server-protocols-lsps)
    - [Language-Specific Tools](#language-specific-tools)
  - [Productivity Tools](#productivity-tools)
    - [Text Expansion](#text-expansion)
    - [Window Management](#window-management)
    - [Personal Knowledge Management](#personal-knowledge-management)
  - [Usage](#usage)
    - [Basic Commands](#basic-commands)
    - [Making Changes](#making-changes)
    - [Template Variables](#template-variables)
  - [Troubleshooting](#troubleshooting)

---

## System Architecture

### Modular Design Philosophy

This chezmoi dotfiles repository follows a **modular, data-driven architecture** that emphasizes:

- **Separation of Concerns**: Configuration data, installation scripts, and templates are cleanly separated
- **Cross-Platform Compatibility**: Platform-specific logic isolated from shared functionality
- **Template Reusability**: Shared templates reduce duplication across configurations
- **Hash-Based Efficiency**: Only run installations when package definitions change
- **Declarative Configuration**: Package management through centralized data files

### Data-Driven Configuration

**Static Configuration Data (`.chezmoidata/`)**
- Central repository for all configuration data that doesn't change based on system environment
- Package definitions, application settings, path mappings, and repository URLs
- Structured data in TOML/JSON format for easy template consumption
- Version-controlled alongside template changes

### Template System

**Shared Templates (`.chezmoitemplates/`)**
- Reusable template components for common functionality
- Consistent logging functions across all installation scripts
- Text expansion rules and configurations
- Template best practices and debugging utilities

### Automated Package Management

**Installation Scripts (`.chezmoiscripts/`)**
- Two-phase pattern: `run_once_*` for initial installation, `run_onchange_*` for updates
- Hash-based detection triggers scripts only when package configurations change
- Platform-specific scripts for macOS, Linux, and cross-platform package managers
- Shared logging and error handling across all scripts

---

## Quick Start

### Fresh Installation

For first-time setup on a new machine:

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Initialize with this repository
chezmoi init https://github.com/JackMatanky/dotfiles.git

# Review what will be changed
chezmoi diff

# Apply the configuration
chezmoi apply -v
```

### Existing Installation

If you already have chezmoi installed:

```bash
# Update from remote repository
chezmoi update

# Or manually pull and apply
chezmoi git pull
chezmoi apply
```

---

## Features

### Configuration Management

- **370+ managed files** across the entire system
- Centralized configuration in `~/.config/chezmoi/chezmoi.toml`
- Template-based configuration with dynamic content
- Cross-platform compatibility (macOS and Linux)

### Cross-Platform Support

- Conditional configurations based on OS detection
- Platform-specific package management (Homebrew, Flatpak)
- Adaptive shell and tool configurations

### Template-Driven Configuration

- **Go templates** for dynamic configuration generation
- User information and preferences templated across configs
- Environment-specific settings (development flags, paths)
- Repository URLs and personal data templated consistently

### Automated Setup Scripts

- **Essential software installation** script (`run_once_install-essentials.sh`)
- **Shell configuration** script (`run_configure-shell.sh`)
- Template-processed scripts for dynamic setup

### Declarative Package Management

- **280+ packages** managed across all platforms and package managers
- Centralized configuration in `.chezmoidata/packages.toml`
- Automatic installation with `run_onchange_` scripts when configuration changes
- Cross-platform (macOS, Linux) and multi-manager (Homebrew, APT, Cargo, NPM, etc.)
- Idempotent and safe to run multiple times

---

## Repository Structure

```
~/.local/share/chezmoi/
├── home/                          # Files that go in $HOME
│   ├── .chezmoiscripts/          # Installation and setup scripts
│   │   ├── run_once_install-essentials.sh.tmpl
│   │   ├── run_configure-shell.sh.tmpl
│   │   ├── run_onchange_darwin-install-packages.sh.tmpl
│   │   ├── run_onchange_linux-install-packages.sh.tmpl
│   │   ├── run_onchange_install-cargo-packages.sh.tmpl
│   │   ├── run_onchange_install-npm-packages.sh.tmpl
│   │   ├── run_onchange_install-python-packages.sh.tmpl
│   │   ├── run_onchange_install-go-packages.sh.tmpl
│   │   └── run_onchange_install-all-packages.sh.tmpl
│   ├── .chezmoidata/             # Data for templates
│   │   └── packages.toml         # Declarative package definitions
│   ├── cli/                      # Command-line interface configs
│   │   ├── justfile.tmpl        # Task runner configuration
│   │   ├── scripts/             # Utility scripts
│   │   ├── git/                 # Git utilities
│   │   └── themes/              # Terminal themes and colorschemes
│   ├── dot_config/              # ~/.config directory contents
│   │   ├── aerospace/           # Window manager
│   │   ├── atuin/              # Shell history
│   │   ├── espanso/            # Text expansion
│   │   ├── ghostty/            # Terminal emulator
│   │   ├── git/                # Version control
│   │   ├── starship.toml       # Shell prompt
│   │   ├── wezterm/            # Terminal emulator
│   │   └── zellij/             # Terminal multiplexer
│   ├── dot_bashrc.tmpl         # Bash configuration
│   ├── dot_zshrc.tmpl          # Zsh configuration
│   ├── dot_Brewfile.tmpl       # Homebrew packages
│   └── dot_Flatpakfile         # Flatpak packages
├── .chezmoi.toml.tmpl          # Chezmoi configuration template
├── .chezmoitemplates/          # Shared templates
└── README.md                   # This file
```

---

## Configuration

The main configuration is stored in `~/.config/chezmoi/chezmoi.toml`:

### Personal Information

```toml
[data]
name = "Jack Matanky"
email = "JackMatanky@gmail.com"
```

### Development Environment

```toml
[data.dev]
use_docker = true
use_kubernetes = true
use_python = true
use_node = true
use_rust = true
use_go = true
use_ai_tools = true
use_helix = false
```

### System Preferences

```toml
[data.preferences]
shell = "zsh"
editor = "nvim"
visual = "zed"
terminal = "ghostty"
```

### Package Management

```toml
[data.packages]
use_homebrew = true
use_cargo = true
use_npm = true
use_flatpak = true
```

---

## Static Configuration Data (.chezmoidata)

### Data Files Overview

The `.chezmoidata/` directory contains static configuration data that is merged into chezmoi's template data dictionary. These files provide centralized, version-controlled configuration that remains consistent across different system environments.

```
.chezmoidata/
├── applications.toml       # Static application configurations and paths
├── defaults.json          # Default tool settings and preferences
├── packages.toml          # Comprehensive package declarations
├── paths.toml             # Directory structures and path mappings
└── repositories.toml      # Repository URLs and external resources
```

### Package Definitions

**`packages.toml`** - The central package definition file based on Brewfile architecture:

```toml
[packages.darwin]
taps = ["homebrew/bundle", "homebrew/services"]
brews = ["git", "zsh", "ripgrep", "fd", "bat", "eza"]
casks = ["visual-studio-code", "ghostty", "zed"]
mas = [1429033973]  # RunCat (App Store ID)
vscode = ["ms-python.python", "rust-lang.rust-analyzer"]

[packages.linux]
flatpak = ["com.visualstudio.code", "org.zotero.Zotero"]
apt = ["git", "zsh", "ripgrep", "fd-find", "bat"]
snap = ["gh", "discord"]

[packages.cargo]
crates = ["cargo-update", "starship", "zoxide", "tokei"]

[packages.npm]
packages = ["typescript", "@typescript-eslint/eslint-plugin", "prettier"]

[packages.python]
packages = ["black", "ruff", "ipython", "jupyter"]

[packages.go]
binaries = ["github.com/junegunn/fzf@latest", "github.com/jesseduffield/lazygit@latest"]
```

**Benefits:**
- **Brewfile compatibility**: macOS packages mirror the established Brewfile format
- **Cross-platform mapping**: Linux equivalents automatically mapped from macOS packages
- **Template integration**: Direct access via `{{ .packages.darwin.brews }}` in templates
- **Hash-based triggering**: Changes automatically trigger relevant installation scripts

### Application Configurations

**`applications.toml`** - Static information about tools and their configurations:

```toml
[terminals.ghostty]
name = "Ghostty"
config_dir = "~/.config/ghostty"
config_file = "config"

[editors.nvim]
name = "Neovim"
config_dir = "~/.config/nvim"
config_files = ["init.lua", "lua/config/"]

[shells.zsh]
name = "Zsh"
config_files = [".zshrc", ".zprofile"]
plugin_dir = "~/.config/zsh/plugins"
```

**Template Usage:**
```bash
# Access terminal configuration
CONFIG_DIR="{{ .terminals.ghostty.config_dir }}"

# Get editor settings  
EDITOR_CONFIG="{{ .editors.nvim.config_dir }}"
```

### Path Management

**`paths.toml`** - Standardized directory structures and path mappings:

```toml
[xdg_dirs]
config_home = "~/.config"
data_home = "~/.local/share"
cache_home = "~/.cache"
state_home = "~/.local/state"

[common_config_dirs]
scripts = "~/.config/scripts"
themes = "~/.config/themes"
shell = "~/.config/shell"

[development_dirs]
projects = "~/Documents/Development"
repositories = "~/Documents/Repositories"
workspace = "~/Workspace"
```

**Template Usage:**
```bash
CONFIG_HOME="{{ .xdg_dirs.config_home }}"
SCRIPTS_DIR="{{ .common_config_dirs.scripts }}"
PROJECTS_DIR="{{ .development_dirs.projects }}"
```

**Key Features:**
- **XDG compliance**: Follows XDG Base Directory specification
- **Consistent paths**: Same directory structure across all configurations
- **Template simplification**: Eliminates hardcoded paths in templates
- **Cross-platform compatibility**: Adapts to different operating systems

---

## Automated Package Management System (.chezmoiscripts)

The `.chezmoiscripts/` directory contains a sophisticated package management system that automatically installs and maintains **280+ packages** across macOS, Linux, and cross-platform environments using a **two-phase, hash-based approach**.

### 🎯 Key Principle

**Package installation/upgrades only run during initial setup, never on subsequent `chezmoi apply` operations.**

### Two-Phase Installation Pattern

**Phase 1: Initial Installation (`run_once_*`)**
- Installs packages **once** on first `chezmoi apply`
- Essential dependencies, platform setup, initial package installation
- Only runs on fresh setups or when script state is cleared

**Phase 2: Manual Updates (No automatic `run_onchange_*`)**
- Package updates are **manual only** via `justfile` tasks or direct commands
- ❌ **No automatic package updates** on configuration changes
- ✅ **Explicit control** over when packages are updated
- Uses smart detection to skip upgrades on existing systems

**Benefits:**
- ✅ **Fast `chezmoi apply`**: No unwanted package operations
- ✅ **Predictable behavior**: Scripts only run when intended
- ✅ **Explicit control**: Package updates require manual action
- ✅ **Initial setup works**: New systems get everything installed
- ✅ **Existing systems protected**: No unexpected changes

### Script Categories

**Directory Structure:**
```
.chezmoiscripts/
├── common/                    # Cross-platform package managers
│   ├── run_once_after_70-install-cargo-packages.sh.tmpl
│   ├── run_onchange_after_71-upgrade-cargo-packages.sh.tmpl
│   ├── run_once_after_71-install-npm-packages.sh.tmpl
│   ├── run_onchange_after_72-upgrade-npm-packages.sh.tmpl
│   ├── run_once_after_72-install-go-packages.sh.tmpl
│   └── run_once_after_73-install-python-packages.sh.tmpl
├── darwin/                    # macOS-specific package managers
│   ├── run_once_before_10-homebrew-setup.sh.tmpl
│   ├── run_once_after_20-install-homebrew-taps.sh.tmpl
│   ├── run_onchange_after_21-upgrade-homebrew-packages.sh.tmpl
│   ├── run_once_after_30-install-homebrew-formulas.sh.tmpl
│   ├── run_once_after_40-install-homebrew-casks.sh.tmpl
│   ├── run_once_after_50-install-mas-apps.sh.tmpl
│   └── run_once_after_60-install-vscode-extensions.sh.tmpl
├── linux/                     # Linux-specific package managers
│   ├── run_once_after_20-install-flatpak-apps.sh.tmpl
│   ├── run_onchange_after_21-upgrade-linux-packages.sh.tmpl
│   ├── run_once_after_30-install-apt-packages.sh.tmpl
│   └── run_once_after_40-install-snap-packages.sh.tmpl
├── run_once_before_00-install-essentials.sh.tmpl    # Essential dependencies
└── run_after_configure-shell.sh.tmpl                # Post-installation setup
```

### Hash-Based Detection

Each script embeds a hash of its relevant package configuration:

```bash
#!/usr/bin/env bash
# Hash based on: {{ .packages.darwin.brews | join "," }}
# Hash: af3b2c1d8e...

{{ template "logging.sh" . }}
log_header "🍺 HOMEBREW PACKAGES"

# Installation logic...
{{- range .packages.darwin.brews }}
brew install "{{ . }}"
{{- end }}
```

**How it works:**
1. Package list changes in `packages.toml`
2. Template hash changes when rendered
3. Chezmoi detects hash change and runs the script
4. Only affected package managers are triggered

### Cross-Platform Support

**Platform Detection:**
```bash
{{- if eq .chezmoi.os "darwin" }}
# macOS-specific logic
if command -v brew &> /dev/null; then
    brew install {{ .package_name }}
fi
{{- else if eq .chezmoi.os "linux" }}
# Linux-specific logic
if command -v apt &> /dev/null; then
    sudo apt install {{ .package_name }}
fi
{{- end }}
```

**Shared Logging System:**
All scripts use consistent logging via `{{ template "logging.sh" . }}`:
```bash
log_info "Installing packages..."     # Blue [INFO]
log_success "✅ Installation complete!" # Green [SUCCESS]
log_warning "⚠️ Manual config needed"   # Yellow [WARNING]
log_error "❌ Failed to install"       # Red [ERROR]
log_header "🍺 HOMEBREW PACKAGES"      # Purple header
```

### Package Categories

#### Platform-Specific

- **macOS (180+ packages)**
  - 🍺 Homebrew formulas (88 packages)
  - 📱 Homebrew casks (40 GUI apps)
  - 🏪 Mac App Store (14 apps)
  - 🔧 VS Code extensions (100+ extensions)

- **Linux (30+ packages)**
  - 📦 APT packages (Ubuntu/Debian)
  - 📱 Flatpak applications (13 apps)
  - 📦 Snap packages

#### Language Ecosystems

- **🦀 Rust/Cargo**: 34 crates (ripgrep, bat, exa, starship, etc.)
- **📦 Node.js/NPM**: 33 global packages (TypeScript, webpack, prettier, etc.)
- **🐍 Python/Pip**: 31 packages (black, pytest, jupyter, flask, etc.)
- **🐹 Go**: 8 binaries (fzf, glow, lazygit, golangci-lint, etc.)

### Installation Scripts

| Script                                         | Purpose          | Triggered By            |
| ---------------------------------------------- | ---------------- | ----------------------- |
| `run_once_before_00-install-essentials`       | Essential tools  | First run only          |
| `run_once_before_10-homebrew-setup`           | Homebrew setup   | First run only (macOS)  |
| `run_once_after_20-install-homebrew-taps`     | Homebrew taps    | First run only          |
| `run_onchange_after_21-upgrade-homebrew`      | Homebrew upgrade | `packages.toml` changes |
| `run_once_after_30-install-homebrew-formulas` | CLI tools        | First run only          |
| `run_once_after_40-install-homebrew-casks`    | GUI apps         | First run only          |
| `run_once_after_70-install-cargo-packages`    | Rust packages    | First run only          |
| `run_onchange_after_71-upgrade-cargo`         | Cargo upgrade    | `packages.toml` changes |

### Usage Examples

#### Adding a New Package

```toml
# Edit ~/.local/share/chezmoi/home/.chezmoidata/packages.toml
[packages.darwin.brews]
brews = [
  # ... existing packages ...
  "new-package",  # Add this line
]
```

#### Triggering Installation

```bash
# Apply changes (automatically runs appropriate scripts)
chezmoi apply -v

# Or run specific script manually
chezmoi execute-template < ~/.local/share/chezmoi/home/.chezmoiscripts/common/run_onchange_after_71-upgrade-cargo-packages.sh.tmpl | bash
```

#### Installing Everything on New Machine

```bash
# Fresh installation - runs all `run_once_*` scripts
chezmoi apply -v

# Force reinstall by clearing script state
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply -v
```

### Benefits

- **🎯 Declarative**: Modify config file, run `chezmoi apply`, done!
- **🔄 Idempotent**: Safe to run multiple times, only installs missing packages
- **📊 Comprehensive**: Covers all major package managers and platforms
- **🎨 Rich Feedback**: Color-coded output with progress indicators
- **🔧 Maintainable**: Clean, well-documented scripts with shared templates
- **⚡ Efficient**: Hash-based detection avoids unnecessary operations
- **📈 Scalable**: Easy to add new packages or package managers
- **🛡️ Error Handling**: Graceful degradation when package managers are missing

---

## Template Library (.chezmoitemplates)

The `.chezmoitemplates/` directory contains reusable template components that provide common functionality across all configuration files and scripts. This shared template library ensures consistency, reduces code duplication, and simplifies maintenance.

### Shared Templates

**Directory Structure:**
```
.chezmoitemplates/
├── logging.sh              # Shared logging functions for scripts
└── espanso/               # Espanso text expansion templates
    ├── espanso_match_*.yml # Various text expansion rule categories
    └── ...                # Additional espanso configurations
```

**Key Benefits:**
- **Code Reuse**: DRY principle across all templates and scripts
- **Consistency**: Same behavior and formatting across configurations
- **Maintainability**: Update shared logic in one place
- **Modularity**: Include only needed functionality in each template

### Logging Functions

**`logging.sh`** - Comprehensive logging system for all installation scripts:

```bash
# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_header() {
    echo -e "\n${PURPLE}$1${NC}"
    echo -e "${PURPLE}$(printf '=%.0s' $(seq 1 ${#1}))${NC}\n"
}
```

**Usage in Scripts:**
```bash
#!/usr/bin/env bash
{{ template "logging.sh" . }}

log_header "🍺 HOMEBREW PACKAGES"
log_info "Installing packages..."
log_success "✅ Installation completed!"
log_warning "⚠️ Some packages may need manual configuration"
log_error "❌ Failed to install package"
```

**Features:**
- **Consistent formatting**: Same log format across all scripts
- **Color coding**: Different colors for different message types
- **Decorative headers**: Visual separation for script sections
- **Shell compatibility**: Works with Bash and Zsh

### Text Expansion Templates

**Espanso Configuration Templates** - Automated text expansion rules:

**Categories include:**
- **Autocorrect rules**: 1000+ common spelling corrections
- **Date/time expansions**: Quick date and time insertion
- **Address expansions**: Personal address information
- **Symbol expansions**: Mathematical symbols, Greek letters
- **Superscript/subscript**: Scientific notation helpers
- **Custom abbreviations**: Personal shortcuts and workflows

**Example expansions:**
```yaml
# Date and time
matches:
  - trigger: ":date"
    replace: "2025-01-25"
  - trigger: ":time"
    replace: "14:30:25"
  - trigger: ":datetime"
    replace: "2025-01-25 14:30:25"

# Personal information
  - trigger: ":email"
    replace: "{{ .email }}"
  - trigger: ":name"
    replace: "{{ .name }}"

# Mathematical symbols
  - trigger: ":alpha"
    replace: "α"
  - trigger: ":beta"
    replace: "β"
  - trigger: ":sum"
    replace: "∑"
  - trigger: ":integral"
    replace: "∫"

# Common corrections
  - trigger: "teh"
    replace: "the"
  - trigger: "recieve"
    replace: "receive"
  - trigger: "seperate"
    replace: "separate"
```

**Template Integration:**
Espanso templates are processed with personal data from chezmoi:

```yaml
# Using template variables in expansions
matches:
  - trigger: ":myemail"
    replace: "{{ .email }}"
  - trigger: ":myname"
    replace: "{{ .name }}"
  - trigger: ":github"
    replace: "{{ .repositories.github }}"
```

### Template Best Practices

**Including Templates:**
```bash
# Include at the top of any template file
{{ template "logging.sh" . }}

# Pass current context with the dot (.)
{{ template "utility-functions.sh" . }}
```

**Template Development Guidelines:**

1. **Make templates pure**: No side effects, return/output only
2. **Use parameters**: Accept data through template context
3. **Add error handling**: Check for required parameters
4. **Document usage**: Add comments explaining how to use
5. **Keep focused**: One template per logical function group

**Example Template Structure:**
```bash
{{/* 
Template: utility-functions.sh
Purpose: Common utility functions for shell scripts
Usage: {{ template "utility-functions.sh" . }}
Requires: None
*/}}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Get OS type
get_os() {
    echo "{{ .chezmoi.os }}"
}

# Get architecture
get_arch() {
    echo "{{ .chezmoi.arch }}"
}
```

**Template Debugging:**
```bash
# Test template rendering
chezmoi execute-template < .chezmoitemplates/logging.sh

# Test template with data context
chezmoi execute-template '{{ template "logging.sh" . }}'

# View all available template data
chezmoi data
```

**Adding New Templates:**

1. **Identify common patterns** across multiple files
2. **Create template file** in `.chezmoitemplates/`
3. **Use clear naming** that describes the template's purpose
4. **Document parameters** and usage in comments
5. **Test thoroughly** across different scenarios
6. **Update existing files** to use the new shared template

**Maintenance Workflow:**
```bash
# When updating shared templates:
1. Edit template in .chezmoitemplates/
2. Test with: chezmoi execute-template < .chezmoitemplates/template.sh
3. Test all affected files
4. Apply changes: chezmoi apply -v
5. Commit changes with descriptive message
```

**Template Categories:**
- **System utilities**: OS detection, command checking, path management
- **Installation helpers**: Package manager detection, dependency verification
- **Configuration generators**: Common config file patterns
- **Text processing**: String manipulation, format conversion
- **Error handling**: Consistent error reporting and recovery

---

## Core System Tools

### Shells

- **[Zsh](https://zsh.sourceforge.io/)** - Primary shell with extensive customization
- **[Bash](https://www.gnu.org/software/bash/)** - Fallback shell with compatibility
- **[Nushell](https://www.nushell.sh/)** - Modern structured shell for data processing

**Shell Enhancements:**

- [ZSH Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [ZSH Syntax Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [ZSH Autocomplete](https://github.com/marlonrichert/zsh-autocomplete)

### Terminal Emulators

- **[Ghostty](https://github.com/ghostty/ghostty)** - Primary GPU-accelerated terminal
- **[Wezterm](https://wezfurlong.org/wezterm/)** - Configurable GPU-accelerated alternative

### Shell Enhancements

- **[Starship](https://starship.rs/)** - Cross-shell customizable prompt
- **[Direnv](https://direnv.net/)** - Environment variable management per directory
- **[Atuin](https://github.com/atuinsh/atuin)** - Enhanced shell history with search
- **[Carapace](https://carapace.sh/)** - Shell completion engine
- **[Zellij](https://zellij.dev/)** - Terminal workspace and multiplexer

### CLI Utilities

- **[eza](https://eza.rocks/)** - Modern `ls` replacement with Git integration
- **[fzf](https://junegunn.github.io/fzf/)** - Fuzzy finder for files and command history
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** - Fast recursive search tool
- **[fd](https://github.com/sharkdp/fd)** - Simple alternative to `find`
- **[bat](https://github.com/sharkdp/bat)** - Syntax-highlighted `cat` replacement
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - Smarter `cd` with frecency
- **[yazi](https://github.com/sxyazi/yazi)** - Terminal file manager with preview
- **[just](https://github.com/casey/just)** - Command runner and task automation

### Version Control

- **[Git](https://git-scm.com/)** - Distributed version control
- **[LazyGit](https://github.com/jesseduffield/lazygit)** - Terminal UI for Git
- **[Delta](https://github.com/dandavison/delta)** - Syntax-highlighted Git diffs
- **[GitLeaks](https://gitleaks.io/)** - Secret detection in Git repositories
- **[GitHub CLI](https://cli.github.com/)** - GitHub from the command line

---

## Development Environment

### Editors

- **[Neovim](https://neovim.io/)** - Primary terminal-based editor
- **[Zed](https://zed.dev/)** - Modern collaborative code editor
- **[Helix](https://helix-editor.com/)** - Modal text editor (configurable)

### Language Server Protocols (LSPs)

- **[vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted)** - HTML, CSS, JSON, ESLint
- **[TypeScript Language Server](https://github.com/typescript-language-server/typescript-language-server)**
- **[BasedPyright](https://github.com/DetachHead/basedpyright)** - Python LSP and type checker
- **[Marksman](https://github.com/artempyanykh/marksman)** - Markdown language server
- **[TexLab](https://github.com/latex-lsp/texlab)** - LaTeX language server
- **[Solargraph](https://solargraph.org)** - Ruby language server
- **[Lua Language Server](https://github.com/sumneko/lua-language-server)** - Lua LSP
- **[YAML Language Server](https://github.com/redhat-developer/yaml-language-server)** - YAML LSP

### Language-Specific Tools

**Python:**

- [pyenv](https://github.com/pyenv/pyenv) - Python version management
- [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) - Environment management
- [uv](https://github.com/astral-sh/uv) - Fast package installer
- [ruff](https://docs.astral.sh/ruff/) - Linter and formatter
- [IPython](https://ipython.org/) - Enhanced interactive shell
- [JupyterLab](https://jupyterlab.readthedocs.io/) - Interactive computing environment

**JavaScript/TypeScript:**

- [Node.js](https://nodejs.org/) - JavaScript runtime
- [npm](https://www.npmjs.com/) - Package manager
- [TypeScript](https://www.typescriptlang.org/) - Typed JavaScript
- [ESLint](https://eslint.org/) - JavaScript linter
- [Prettier](https://prettier.io/) - Code formatter

**Rust:**

- [Rust toolchain](https://www.rust-lang.org/) - Systems programming language
- [Rust Analyzer](https://rust-analyzer.github.io/) - Rust IDE support

**Go:**

- [Go](https://golang.org/) - Programming language
- [golangci-lint](https://golangci-lint.run/) - Go linter

**Lua:**

- [LuaJIT](https://luajit.org/) - Just-In-Time Compiler for Lua
- [LuaRocks](https://luarocks.org/) - Package manager for Lua
- [stylua](https://github.com/JohnnyMorganz/StyLua) - Lua formatter

---

## Productivity Tools

### Text Expansion

- **[Espanso](https://espanso.org/)** - Cross-platform text expander
  - Autocorrect functionality with 1000+ common misspellings
  - Math and logic symbols
  - Markdown shortcuts
  - Application-specific expansions

### Window Management

- **[Aerospace](https://github.com/nikitabobko/AeroSpace)** - i3-like tiling window manager for macOS
- **[Borders](https://github.com/FelixKratz/JankyBorders)** - Window border highlighting

### Personal Knowledge Management

- **[Obsidian](https://obsidian.md/)** - Note-taking and knowledge management
- **[Anki](https://apps.ankiweb.net/)** - Spaced repetition flashcards
- **[Zotero](https://www.zotero.org/)** - Reference management

---

## Usage

### Basic Commands

```bash
# Check what files chezmoi will manage
chezmoi managed

# See what changes would be applied
chezmoi diff

# Apply all changes
chezmoi apply

# Apply changes verbosely
chezmoi apply -v

# Edit a file managed by chezmoi
chezmoi edit ~/.zshrc

# Add a new file to chezmoi
chezmoi add ~/.config/new-tool/config.toml

# Update from remote repository
chezmoi update

# Check chezmoi status
chezmoi status
```

### Making Changes

1. **Edit configuration files:**

   ```bash
   chezmoi edit ~/.zshrc
   # This opens the source file for editing
   ```

2. **Apply changes:**

   ```bash
   chezmoi apply
   ```

3. **Commit and push changes:**

   ```bash
   chezmoi git add .
   chezmoi git commit -m "Update configuration"
   chezmoi git push
   ```

### Template Variables

Templates use Go template syntax with variables from `chezmoi.toml`:

```bash
# User information
{{ .name }}          # "Jack Matanky"
{{ .email }}         # "JackMatanky@gmail.com"

# Preferences
{{ .preferences.shell }}     # "zsh"
{{ .preferences.editor }}    # "nvim"
{{ .preferences.visual }}    # "zed"

# Development flags
{{ .dev.use_python }}        # true
{{ .dev.use_docker }}        # true

# Paths
{{ .paths.brew_prefix }}     # "/opt/homebrew"

# Platform detection
{{- if eq .chezmoi.os "darwin" }}
# macOS specific configuration
{{- else if eq .chezmoi.os "linux" }}
# Linux specific configuration
{{- end }}
```

---

## Troubleshooting

**Common Issues:**

1. **Template errors:**

   ```bash
   chezmoi execute-template < ~/.local/share/chezmoi/home/dot_zshrc.tmpl
   ```

2. **Check what chezmoi would do without applying:**

   ```bash
   chezmoi diff
   ```

3. **Verify template data:**

   ```bash
   chezmoi data
   ```

4. **Reset a file from the source:**

   ```bash
   chezmoi apply --force ~/.zshrc
   ```

5. **Debug script execution:**

   ```bash
   chezmoi execute-template < ~/.local/share/chezmoi/.chezmoiscripts/run_configure-shell.sh.tmpl
   ```

**Getting Help:**

- [Chezmoi Documentation](https://www.chezmoi.io/)
- [Chezmoi Quick Start](https://www.chezmoi.io/quick-start/)
- [Go Template Documentation](https://pkg.go.dev/text/template)

---

---

## Chezmoi Script Management Guidelines

This section documents the current script management approach that ensures **package installer scripts never run automatically on changes**.

### 🎯 Core Principles

1. **Package installation/upgrades only run during initial setup**
2. **Configuration scripts run every time to keep settings current**
3. **Manual package updates via `justfile` tasks or direct commands**
4. **No `run_onchange_*` prefixes for package management**

### 📁 Current Script Categories

#### ✅ **Hook Scripts** (Run Automatically)
```bash
run_after_configure-shell.sh.tmpl     # Shell configuration (runs every time)
```

#### 🏗️ **Setup Scripts** (Run Once Only)
```bash
# Essential setup
run_once_before_00-install-essentials.sh.tmpl

# Platform-specific (Darwin)
run_once_before_10-homebrew-setup.sh.tmpl
run_once_after_20-install-homebrew-taps.sh.tmpl
run_once_after_21-install-homebrew-packages.sh.tmpl    # Initial update only
run_once_after_30-install-homebrew-formulas.sh.tmpl
run_once_after_40-install-homebrew-casks.sh.tmpl
run_once_after_50-install-mas-apps.sh.tmpl
run_once_after_60-install-vscode-extensions.sh.tmpl

# Platform-specific (Linux)
run_once_after_20-install-flatpak-apps.sh.tmpl
run_once_after_21-upgrade-linux-packages.sh.tmpl       # Initial update only
run_once_after_30-install-apt-packages.sh.tmpl
run_once_after_40-install-snap-packages.sh.tmpl

# Cross-platform packages
run_once_after_70-install-cargo-packages.sh.tmpl
run_once_after_71-upgrade-cargo-packages.sh.tmpl       # Initial toolchain update
run_once_after_71-install-npm-packages.sh.tmpl
run_once_after_72-upgrade-npm-packages.sh.tmpl         # Initial NPM update
run_once_after_72-install-go-packages.sh.tmpl
run_once_after_73-install-python-packages.sh.tmpl
run_once_after_73-upgrade-python-packages.sh.tmpl      # Initial Python update

# Setup completion
run_once_after_99-setup-complete.sh.tmpl               # Creates marker file
```

### ⚙️ Smart Script Behavior

**Initial Setup Detection**: Scripts check for `$HOME/.config/chezmoi-initial-setup-complete`:
- **File missing**: Initial setup → run installations and upgrades
- **File exists**: Existing system → skip automatic upgrades, show manual commands

**Example Smart Logic**:
```bash
if [[ ! -f "$HOME/.config/chezmoi-initial-setup-complete" ]]; then
    log_info "Initial setup detected - installing packages..."
    # Run package installations/upgrades
else
    log_info "Existing setup detected - skipping automatic upgrades"
    log_info "To upgrade packages manually, run: brew upgrade"
fi
```

### 📦 Manual Package Management

**Using justfile tasks** (recommended):
```bash
just update-packages           # Update all packages for current OS
just update-packages-macos     # macOS-specific updates
just update-packages-linux     # Linux-specific updates
just update-packages-common    # Cross-platform packages
```

**Direct commands**:
```bash
# macOS
brew update && brew upgrade && brew cleanup
mas upgrade

# Linux
sudo apt update && apt upgrade
flatpak update
sudo snap refresh

# Cross-platform
cargo install-update --all    # Rust packages
npm update -g                  # NPM packages
pip3 install --user --upgrade <package>  # Python packages
```

### 🔧 Adding New Scripts

#### For Configuration Changes (Always Run)
```bash
# Use run_after_ prefix - runs every chezmoi apply
run_after_new-config.sh.tmpl
```

#### For Package Installation (Run Once)
```bash
# Use run_once_ prefix with smart upgrade logic
run_once_after_XX-install-new-package.sh.tmpl
```

#### ❌ Never Use These Patterns
```bash
# These would run on every package list change:
run_onchange_*-upgrade-*.sh.tmpl    # ❌ BAD
run_onchange_*-install-*.sh.tmpl    # ❌ BAD
```

### 🧪 Testing & Verification

```bash
# Verify no scripts run on existing systems
chezmoi apply --dry-run    # Should show no script execution

# Test all scripts manually
just re-run-scripts

# Reset for fresh testing
just clean-apply
```

### 🎉 Benefits of This Approach

- ✅ **Fast `chezmoi apply`** - No unwanted package operations
- ✅ **Predictable behavior** - Scripts only run when intended
- ✅ **Explicit control** - Package updates require manual action
- ✅ **Initial setup works** - New systems get everything installed
- ✅ **Existing systems protected** - No unexpected changes

### 🚨 Migration Notes

**Previous Issues Fixed**:
- Removed all `run_onchange_*` prefixes from package scripts
- Added smart upgrade detection logic
- Enhanced script headers with clear purpose documentation
- Added manual package update tasks to `justfile`

**Current State**: All package installer scripts now use `run_once_*` prefixes and will only run during initial setup or when explicitly re-executed.

---

*This dotfiles repository is personalized for Jack Matanky's development environment. Feel free to fork and adapt for your own use!*
