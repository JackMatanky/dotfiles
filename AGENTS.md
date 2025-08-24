# Chezmoi Dotfiles Repository AI Instructions

## Architecture Overview
- You MUST recognize this as a chezmoi-managed dotfiles repository supporting macOS and Linux with a modular shell configuration system
- You MUST understand that all files in the `home/` directory are managed by chezmoi and deployed to the user's home directory via `chezmoi apply`
- You SHOULD use chezmoi's advanced features including templates, data files, scripts, and conditional logic for cross-platform compatibility

### Core Components
- You MUST recognize Nushell as the primary shell, Zed as the primary IDE, Neovim as the editor, and Ghostty as the terminal/multiplexer
- You MUST understand that `home/dot_config/cli/` contains shared shell logic for Bash and Zsh, with Nushell configs maintained in parallel
- You SHOULD use declarative dependency management via Brewfiles, Cargo packages, and Flatpak manifests
- You MUST use centralized color schemes in `home/dot_config/themes/colorschemes/` with semantic naming
- You SHOULD use `home/justfile` for cross-platform task automation and `home/dot_config/scripts/` for setup automation
- You MUST use chezmoi templates for dynamic configuration, data-driven customization, and run scripts for automated setup

## Key Architectural Patterns

### Multi-Shell Configuration System
- You MUST maintain feature parity across three shell environments: Nushell, Zsh, and Bash
- You MUST use Nushell for daily interactive use with advanced features and robust error handling
- You MUST provide Zsh/Bash for essential POSIX-compliant tasks and universal compatibility
- You MUST place shared logic in the `home/dot_config/cli/` directory for common utilities between Bash and Zsh
- You MUST source files lexicographically with numbered prefixes to enable predictable dependency loading
- You MUST write Bash/Zsh configurations to be shell-agnostic, ensuring compatibility with minimal systems
- You SHOULD use Bash for foundational scripting even when called from Nushell

### Primary Tool Configuration
- You MUST configure Zed as the primary IDE using `home/dot_config/zed/private_settings.json` and `home/dot_config/zed/private_keymap.json`
- You MUST configure Neovim as the editor with LazyVim using `home/dot_config/nvim/init.lua` and `home/dot_config/nvim/lua/`
- You MUST configure Ghostty as the terminal and multiplexer replacement using `home/dot_config/ghostty/config`

### Cross-Platform Package Management
- You MUST use `home/dot_config/dot_Brewfile` for core CLI tools on both macOS and Linux
- You MUST manage Rust packages in `home/dot_config/packages/cargo-packages.txt` with one package per line
- You MUST manage Linux GUI applications in `home/dot_config/packages/flatpak-manifest.json`
- You MUST use chezmoi templates and conditionals for OS-specific configurations

### Chezmoi File Structure
- You MUST follow chezmoi naming conventions where `dot_config/` maps to `~/.config/`
- You MUST use `dot_` prefix for dotfiles and directories (e.g., `dot_bashrc` maps to `~/.bashrc`)
- You MUST use `private_` prefix for files not tracked in git (e.g., `private_tool-name/`)
- You MUST use `executable_` prefix for executable scripts
- You MUST understand that `.tmpl` files support Go templating with data variables
- You MUST organize configuration files using this structure:
  ```
  home/
  ├── dot_config/                          # Maps to ~/.config/
  │   ├── tool-name/                       # Tool-specific configuration
  │   │   ├── config.toml                  # Maps to ~/.config/tool-name/config.toml
  │   │   └── config.toml.tmpl            # Template version with variables
  │   └── private_tool-name/               # Private files (not tracked in git)
  ├── dot_tool-namerc                      # Maps to ~/.tool-namerc
  ├── dot_tool-namerc.tmpl                 # Template version
  └── executable_script-name               # Executable scripts
  ```

### Chezmoi Template System
- You MUST use files ending in `.tmpl` for Go templating with data variables
- You MUST use `{{ if eq .chezmoi.os "darwin" }}` for OS-specific content in templates
- You MUST use `{{ if eq .chezmoi.arch "arm64" }}` for architecture-specific content
- You MUST define data variables in `.chezmoi.toml` or `.chezmoi.yaml` for customization across templates
- You MUST use run once scripts with `.chezmoiscripts/run_once_*` naming for one-time setup tasks
- You MUST use always run scripts with `.chezmoiscripts/run_*` naming for tasks that run on every apply
- You SHOULD use conditional templating for cross-platform compatibility:
  ```go
  {{- if eq .chezmoi.os "darwin" }}
  # macOS-specific configuration
  {{- else if eq .chezmoi.os "linux" }}
  # Linux-specific configuration
  {{- end }}
  ```
- You MUST access chezmoi data variables using dot notation: `{{ .chezmoi.hostname }}`, `{{ .chezmoi.username }}`
- You SHOULD define custom data in `.chezmoi.toml` data section:
  ```toml
  [data]
      email = "user@example.com"
      name = "User Name"
  ```
- You MUST reference custom data variables in templates: `{{ .email }}`, `{{ .name }}`

## Development Workflows

### Chezmoi Operations
- You MUST use `chezmoi apply` to apply all configurations
- You SHOULD use `chezmoi apply -v` for verbose output when debugging
- You MUST use `chezmoi diff` to preview changes before applying
- You MUST use `chezmoi add ~/.config/new-tool/config` to add new files to chezmoi
- You MUST use `chezmoi edit ~/.config/tool/config` to edit files managed by chezmoi
- You SHOULD use `chezmoi update` to update from source repository

### Package Management
- You MUST use `just install-all` to install all dependencies
- You SHOULD use `just brew-update`, `just cargo-install`, and `just flatpak-install` for specific package manager updates

### Template Development
- You MUST use `chezmoi execute-template < file.tmpl` to execute templates and see output
- You MUST use `chezmoi data` to validate template syntax
- You SHOULD use `chezmoi state delete-bucket --bucket=scriptState` to re-run scripts

### Theme Management
- You MUST centralize color schemes in `home/dot_config/themes/colorschemes/` with consistent variable naming
- You MUST use semantic color names (`$primary`, `$secondary`) over hex values
- You MUST source color files using `source ~/.config/themes/colorschemes/catppuccin_latte.sh`
- You MAY reference theme data in templates using `{{ .theme.primary_color }}`

## Project-Specific Conventions

### File Organization
- You MUST use `_notes/` for development documentation and setup guides
- You SHOULD use `_examples/` for reference configurations of complex tools (private/sandbox)
- You SHOULD use `_devtools/` for language-specific development utilities and scripts (private/sandbox)

### Shell Script Standards
- You MUST use `#!/usr/bin/env bash` or `#!/bin/bash` for all shell scripts
- You MUST follow Google Shell Style Guide conventions
- You MUST include comprehensive headers with `# Filename: full/path`, description, and docs links
- You MUST include shellcheck directives: `# shellcheck shell=bash`
- You MUST use numbered prefixes for load order: `00-`, `10-`, `20-`

### Configuration Patterns
- You MUST use XDG Base Directory specification with `${XDG_CONFIG_HOME:-$HOME/.config}` for config paths
- You MUST check `$OS` variable and use appropriate Homebrew paths for cross-platform compatibility
- You MUST guard shell-specific features with shell detection for conditional loading

### Package Naming
- You MUST group packages logically in Brewfiles with descriptive comments
- You MUST use consistent naming: `brew 'tool-name'` not `brew "tool-name"`
- You MUST document platform-specific packages clearly

## Critical Integration Points

### Shell Integration Chain
- You MUST understand the integration chain: Login shell → Interactive shell → `home/dot_config/cli/lib/load_core.sh` → `source_sh_files` function → Profile and command modules

### Homebrew Path Detection
- You MUST use ARM64 path `/opt/homebrew/bin/brew` for Apple Silicon Macs
- You MUST use Intel path `/usr/local/bin/brew` for Intel Macs
- You MUST use chezmoi templates with architecture conditionals for cross-platform compatibility

### Justfile Variable System
- You MUST use OS detection with `OS := os()` for cross-platform compatibility
- You MUST construct paths using justfile variables for consistent package management

## Common Operations
- You MUST create directories in `home/dot_config/` when adding new tools and update appropriate Brewfile/package lists
- You MUST edit files in `home/dot_config/cli/profile/` or `home/dot_config/cli/cmd/` with numbered prefixes to modify shell behavior
- You MUST use chezmoi templates with OS conditionals `{{ if eq .chezmoi.os "darwin" }}` for platform-specific features
- You MUST modify colorscheme files in `home/dot_config/themes/` and re-source affected configs for theme changes
- You SHOULD use `just update-all` or specific package manager commands for dependency updates
- You MUST define template variables in `.chezmoi.toml` data section for reuse across configurations

## System Priorities
- You MUST prioritize modularity, cross-platform compatibility, and declarative dependency management
- You MUST use chezmoi's powerful templating and data features
- You SHOULD test changes on both macOS and Linux when possible
