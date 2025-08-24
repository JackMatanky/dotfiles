# Chezmoi Dotfiles

Personal configuration files managed with **[chezmoi](https://www.chezmoi.io/)** for **macOS** and **Linux**.

## Table of Contents

- [Chezmoi Dotfiles](#chezmoi-dotfiles)
  - [Table of Contents](#table-of-contents)
  - [Quick Start](#quick-start)
    - [Fresh Installation](#fresh-installation)
    - [Existing Installation](#existing-installation)
  - [Features](#features)
    - [Configuration Management](#configuration-management)
    - [Cross-Platform Support](#cross-platform-support)
    - [Template-Driven Configuration](#template-driven-configuration)
    - [Automated Setup Scripts](#automated-setup-scripts)
    - [Declarative Package Management](#declarative-package-management)
  - [Repository Structure](#repository-structure)
  - [Configuration](#configuration)
    - [Personal Information](#personal-information)
    - [Development Environment](#development-environment)
    - [System Preferences](#system-preferences)
    - [Package Management](#package-management)
  - [Package Management System](#package-management-system)
    - [Package Categories](#package-categories)
      - [Platform-Specific](#platform-specific)
      - [Language Ecosystems](#language-ecosystems)
    - [Installation Scripts](#installation-scripts)
    - [Usage Examples](#usage-examples)
      - [Adding a New Package](#adding-a-new-package)
      - [Triggering Installation](#triggering-installation)
      - [Installing Everything on New Machine](#installing-everything-on-new-machine)
    - [Benefits](#benefits)
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

## Package Management System

This dotfiles repository includes a comprehensive declarative package management system using a centralized `~/.local/share/chezmoi/home/.chezmoidata/packages.toml` configuration file to manage **280+ packages** across all platforms and package managers.

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
| `run_onchange_darwin-install-packages.sh.tmpl` | macOS packages   | `packages.toml` changes |
| `run_onchange_linux-install-packages.sh.tmpl`  | Linux packages   | `packages.toml` changes |
| `run_onchange_install-cargo-packages.sh.tmpl`  | Rust packages    | `packages.toml` changes |
| `run_onchange_install-npm-packages.sh.tmpl`    | Node.js packages | `packages.toml` changes |
| `run_onchange_install-python-packages.sh.tmpl` | Python packages  | `packages.toml` changes |
| `run_onchange_install-go-packages.sh.tmpl`     | Go packages      | `packages.toml` changes |
| `run_onchange_install-all-packages.sh.tmpl`    | **All packages** | `packages.toml` changes |

### Usage Examples

#### Adding a New Package

```toml
# Add to ~/.local/share/chezmoi/home/.chezmoidata/packages.toml
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
chezmoi execute-template < ~/.local/share/chezmoi/home/.chezmoiscripts/run_onchange_install-cargo-packages.sh.tmpl | bash
```

#### Installing Everything on New Machine

```bash
# Run master installation script
chezmoi apply  # Will run all scripts for changed packages.toml
```

### Benefits

- **🎯 Declarative**: Modify config file, run `chezmoi apply`, done!
- **🔄 Idempotent**: Safe to run multiple times, only installs missing packages
- **📊 Comprehensive**: Covers all major package managers and platforms
- **🎨 Rich Feedback**: Color-coded output with progress indicators
- **🔧 Maintainable**: Clean, well-documented scripts
- **⚡ Efficient**: Smart detection avoids duplicate installations
- **📈 Scalable**: Easy to add new packages or package managers

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

*This dotfiles repository is personalized for Jack Matanky's development environment. Feel free to fork and adapt for your own use!*
