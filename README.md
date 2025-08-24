# Jack's Dotfiles

Personal configuration files managed with **[chezmoi](https://www.chezmoi.io/)** for **macOS** and **Linux**.

## Table of Contents

- [Jack's Dotfiles](#jacks-dotfiles)
  - [Table of Contents](#table-of-contents)
  - [Quick Start](#quick-start)
    - [Fresh Installation](#fresh-installation)
    - [Existing Installation](#existing-installation)
  - [Features](#features)
    - [Configuration Management](#configuration-management)
    - [Cross-Platform Support](#cross-platform-support)
    - [Template-Driven Configuration](#template-driven-configuration)
    - [Automated Setup Scripts](#automated-setup-scripts)
  - [Repository Structure](#repository-structure)
  - [Configuration](#configuration)
    - [Personal Information](#personal-information)
    - [Development Environment](#development-environment)
    - [System Preferences](#system-preferences)
    - [Package Management](#package-management)
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

---

## Repository Structure

```
~/.local/share/chezmoi/
├── home/                          # Files that go in $HOME
│   ├── .chezmoiscripts/          # Installation and setup scripts
│   │   ├── run_once_install-essentials.sh.tmpl
│   │   └── run_configure-shell.sh.tmpl
│   ├── cli/                      # Command-line interface configs
│   │   ├── justfile.tmpl        # Task runner configuration
│   │   └── scripts/             # Utility scripts
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

### CLI Utilities
- **[eza](https://eza.rocks/)** - Modern `ls` replacement with Git integration
- **[fzf](https://junegunn.github.io/fzf/)** - Fuzzy finder for files and command history
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** - Fast recursive search tool
- **[fd](https://github.com/sharkdp/fd)** - Simple alternative to `find`
- **[bat](https://github.com/sharkdp/bat)** - Syntax-highlighted `cat` replacement
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - Smarter `cd` with frecency
- **[yazi](https://github.com/sxyazi/yazi)** - Terminal file manager with preview

### Version Control
- **[Git](https://git-scm.com/)** - Distributed version control
- **[LazyGit](https://github.com/jesseduffield/lazygit)** - Terminal UI for Git
- **[Delta](https://github.com/dandavison/delta)** - Syntax-highlighted Git diffs
- **[GitLeaks](https://gitleaks.io/)** - Secret detection in Git repositories

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

### Language-Specific Tools

**Python:**
- [uv](https://github.com/astral-sh/uv) - Fast package installer
- [ruff](https://docs.astral.sh/ruff/) - Linter and formatter
- [IPython](https://ipython.org/) - Enhanced interactive shell

**Rust:**
- [Rust toolchain](https://www.rust-lang.org/) - Systems programming language

**JavaScript/TypeScript:**
- [Node.js](https://nodejs.org/) - JavaScript runtime
- [npm](https://www.npmjs.com/) - Package manager

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
