# WARP.md

This file provides guidance to WARP (warp.dev) when working with this dotfiles repository.

## Essential Commands

### Initial Setup & Installation
- `chmod +x scripts/setup.sh && ./scripts/setup.sh` - Complete first-time system setup
- `just install-all` - Install all packages (Homebrew, Cargo, Flatpak)
- `just install-homebrew` - Install Homebrew and core packages only
- `stow */` - Create symlinks for all configuration directories

### Package Management
- `just update-all` - Update all package managers (Homebrew, Cargo, Flatpak)
- `just update-brew` - Interactive Homebrew update with prompts
- `brew bundle --file=Brewfile` - Install packages from Brewfile
- `cargo binstall -y < packages/cargo-packages.txt` - Install Rust tools

### Configuration Management
- `stow <directory>` - Symlink specific config (e.g., `stow zsh`, `stow helix`)
- `stow -D <directory>` - Remove symlinks for specific config
- `stow -R <directory>` - Restow (remove and re-create symlinks)

### System Maintenance
- `just tmux-up` - Start or attach to tmux session
- `just cleanup-brew` - Clean Homebrew cache and old versions

## Architecture Overview

This repository manages a comprehensive development environment using **GNU Stow** for symlink management and **Just** for task automation.

### Directory Structure Philosophy

Each top-level directory represents a **stow package** that gets symlinked to `~/.config/`:
- `nushell/` → `~/.config/nushell/`
- `helix/` → `~/.config/helix/`
- `git/` → `~/.config/git/`
- etc.

### Core Components

1. **Package Definitions**
   - `Brewfile` - Cross-platform packages (200+ formulas)
   - `packages/cargo-packages.txt` - Rust tools
   - `packages/flatpak-manifest.json` - Linux GUI apps

2. **Shell Environment** (Multi-shell approach)
   - **Nushell** (primary) - Modern structured shell
   - **ZSH** (fallback) - Traditional shell with plugins
   - **Bash** (compatibility) - For scripts and universal compatibility

3. **Modular CLI System** (`cli/` directory)
   - `lib/` - Core utilities (logging, file sourcing)
   - `profile/` - Environment variables (Homebrew, languages)
   - `cmd/` - Aliases and functions

4. **Development Stack**
   - **Editors**: Helix (primary), Neovim, VS Code
   - **Terminals**: Ghostty, Wezterm with tmux/zellij
   - **Git**: Enhanced with Delta pager and LazyGit TUI

## Package Management Strategy

### Homebrew (Primary)
- **Cross-platform packages**: Core development tools, languages, LSPs
- **macOS GUI apps**: Casks for applications
- **Mac App Store**: Automated via `mas` command

### Cargo (Rust Ecosystem)
- **Modern CLI tools**: Fast alternatives (eza, fd, ripgrep, bat)
- **Terminal applications**: zellij, starship, yazi
- **Development utilities**: cargo-edit, cargo-watch

### Platform-Specific
- **Flatpak** (Linux): GUI applications
- **System packages** (Linux): Build dependencies via distribution package managers

## Common Workflows

### Adding New Tools
1. Add to appropriate package file (`Brewfile`, `cargo-packages.txt`)
2. Run installation command (`just install-homebrew`, `just install-cargo-packages`)
3. Add configuration directory if needed
4. Update `.stowrc` ignore patterns if necessary

### Shell Configuration Updates
- **Environment variables**: Edit `cli/profile/*.sh`
- **Aliases/Functions**: Edit `cli/cmd/*.sh`
- **Shell-specific**: Edit `nushell/config.nu` or `zsh/.zshrc`

### Cross-Platform Development
- Use `justfile` OS detection: `OS := os()` and `[macos]`/`[linux]` attributes
- Test changes on both macOS and Linux when possible
- Keep Homebrew packages cross-platform in main `Brewfile`

## Key Files to Understand

### Configuration Management
- `.stowrc` - Stow behavior and ignore patterns
- `justfile` - Task automation and system management

### Shell Integration
- `cli/lib/load_core.sh` - Core shell utilities loader
- `nushell/env.nu` - Nushell environment setup
- `zsh/.zshrc` - ZSH configuration with plugin loading

### Development Environment
- `helix/config.toml` - Primary editor configuration
- `git/config` - Git setup with Delta integration
- `starship/starship.toml` - Cross-shell prompt configuration

## Maintenance Tasks

### Regular Updates
```bash
# Update all package managers
just update-all

# Update specific package managers
just update-brew
just update-rust
just update-cargo-packages
```

### Troubleshooting
- **Broken symlinks**: `stow -R <package>` to restow
- **Package conflicts**: Check Homebrew with `brew doctor`
- **Shell issues**: Source `~/.zshrc` or restart shell

### Adding New Machines
1. Clone repository: `git clone https://github.com/JackMatanky/dotfiles.git ~/dotfiles`
2. Run setup: `cd ~/dotfiles && ./scripts/setup.sh`
3. Configure shell: May need to manually set default shell to nushell

## Platform-Specific Notes

### macOS
- **AeroSpace**: i3-like tiling window manager configuration
- **System Dependencies**: Xcode Command Line Tools required

### Linux
- **Window Manager**: Basic configurations provided
- **Package Managers**: Supports apt, yum, pacman via setup script
- **Flatpak**: Primary source for GUI applications

## Theme & Appearance

- **Primary Theme**: Catppuccin Macchiato (consistent across all applications)
- **Fonts**: Nerd Fonts for icon support
- **Terminal Colors**: Coordinated color scheme throughout environment

## Important Notes

- **XDG Compliance**: Configurations follow XDG Base Directory specification
- **Git Work Config**: Uses conditional includes for work vs personal settings
- **Environment Variables**: Managed through `cli/profile/` for consistency
- **Cross-Shell**: Tools configured to work across nushell, zsh, and bash
