# AGENTS.md

This file provides comprehensive guidance to WARP (warp.dev) when working with this dotfiles repository. It combines architectural knowledge with practical commands for effective development environment management.

## Development Environment Overview

### Primary Tools Stack

- **Shell**: Nushell (primary), ZSH (fallback), Bash (scripts)
- **IDE**: Zed (`zed/settings.json`, `zed/keymap.json`)
- **Editor**: Neovim with LazyVim (`nvim/init.lua`, `nvim/lua/`)
- **Terminal**: Warp (AI-powered), Ghostty (multiplexer replacement)
- **File Manager**: Yazi (`yazi/config.toml`)
- **Git UI**: LazyGit (`lazygit/config.yml`)
- **Prompt**: Starship (`starship/starship.toml`)

### Tool Integration Patterns

- **Session Management**: Native Warp workflows + Ghostty tabs/panes (no tmux/zellij)
- **Multi-Shell System**: `cli/` contains shared Bash/ZSH logic, Nushell configs parallel
- **Cross-Platform**: GNU Stow for symlink management, Just for task automation
- **Theme System**: Catppuccin Macchiato across all applications (`themes/colorschemes/`)

## Essential Commands

### Initial Setup & Installation

```bash
# Complete first-time system setup
chmod +x scripts/setup.sh && ./scripts/setup.sh

# Install all dependencies (Homebrew, Cargo, Flatpak)
just install-all

# Install only Homebrew and core packages
just install-homebrew

# Deploy all configuration symlinks
stow */
```

### Package Management

```bash
# Update all package managers
just update-all

# Interactive Homebrew update with prompts
just update-brew

# Install from specific package files
brew bundle --file=Brewfile
cargo binstall -y < packages/cargo-packages.txt
```

### Configuration Management (GNU Stow)

```bash
# Deploy specific configuration
stow nvim        # Symlinks nvim/ -> ~/.config/nvim/
stow zed         # Symlinks zed/ -> ~/.config/zed/
stow nushell     # Symlinks nushell/ -> ~/.config/nushell/

# Remove configuration symlinks
stow -D <directory>

# Restow (remove and re-create symlinks)
stow -R <directory>

# Simulate to check for conflicts
stow -n <directory>
```

### Development Workflow Commands

```bash
# Quick editor access
nv <file>        # Open in Neovim (LazyVim)
zd <file>        # Open in Zed

# File management
yazi             # Launch file manager
eza -la          # Modern ls replacement
fd <pattern>     # Modern find replacement
rg <pattern>     # Modern grep replacement

# Git workflows
lazygit          # Git TUI
gh pr create     # GitHub CLI
```

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

- `nvim/` - Neovim with LazyVim configuration
- `zed/` - Zed IDE configuration
- `git/config` - Git setup with Delta integration
- `starship/starship.toml` - Cross-shell prompt configuration

## Neovim & LazyVim Configuration

### LazyVim Distribution

- **Distribution**: [LazyVim](https://www.lazyvim.org/) - A pre-configured Neovim IDE setup
- **Plugin Manager**: lazy.nvim for fast, lazy-loaded plugin management
- **Configuration**: `~/dotfiles/nvim/` with modular Lua structure
- **AI Integration**: Codeium for intelligent code completion
- **Entry Point**: `nvim/init.lua` loads LazyVim core + custom overrides

### Key LazyVim Features Enabled

```lua
-- From lazyvim.json - Active extras:
"lazyvim.plugins.extras.ai.codeium"          -- AI code completion
"lazyvim.plugins.extras.coding.luasnip"       -- Snippet engine
"lazyvim.plugins.extras.dap.core"             -- Debugging support
"lazyvim.plugins.extras.editor.fzf"           -- Fuzzy finder
"lazyvim.plugins.extras.lang.python"          -- Python language support
"lazyvim.plugins.extras.lang.nushell"         -- Nushell support
"lazyvim.plugins.extras.lang.typescript"      -- TypeScript/JS support
"lazyvim.plugins.extras.formatting.prettier"  -- Code formatting
"lazyvim.plugins.extras.test.core"            -- Testing framework
```

### Custom Plugin Overrides

- `nvim/lua/plugins/` - Custom plugin configurations
- `colorscheme.lua` - Catppuccin theme integration
- `lualine.lua` - Enhanced status line
- `iron_nvim.lua` - REPL integration
- `ghostty.lua` - Terminal integration
- `luasnip.lua` - Custom snippets

### Common LazyVim Workflows

```bash
# Editor access aliases
nv <file>        # Open file in Neovim
ffv              # Fuzzy-find and open file in Neovim (Nushell)
fdv              # Fuzzy-find directory and open in Neovim (Nushell)
vdiff <file1> <file2>  # Open files in diff mode

# LazyVim management
:Lazy            # Plugin management interface
:LazyHealth      # Check LazyVim installation
:LazyExtras      # Browse and enable extras
:Mason           # LSP/formatter/linter management
```

### Key Bindings & Integration

- **Leader Key**: `<Space>` (LazyVim default)
- **File Explorer**: `<leader>e` (Neo-tree)
- **Fuzzy Find**: `<leader>ff` (files), `<leader>fg` (live grep)
- **Git Integration**: `<leader>gg` (LazyGit), `<leader>gh` (GitHub)
- **Terminal**: `<leader>ft` (floating terminal)
- **AI Completion**: Codeium provides intelligent suggestions

## Shell Alias System

### Dual Alias Architecture

The dotfiles maintain two parallel alias systems for maximum shell compatibility:

#### 1. Nushell Aliases (`nushell/aliases/`)

- **Structured Commands**: Leverage Nushell's type system and error handling
- **File Organization**: Modular approach with topic-based files

```
nushell/aliases/
├── aliases.nu       # Core navigation and utility aliases
├── git_aliases.nu   # Git workflow shortcuts
└── ocr_aliases.nu   # Document processing utilities
```

**Key Nushell Functions**:

```nushell
# Smart directory navigation with listing
def --env cx [path?: string] {     # cd + ls with fzf fallback
    let target = (if ($path == null) {
        fd --type directory --hidden --exclude .git | fzf
    } else { $path })
    if ($target != "") { cd $target; ls -l }
}

# Fuzzy file finder with preview
def ffb [] {                       # Find file with bat preview
    let file = (fd --type file --hidden --exclude .git
                | fzf --preview 'bat --style=numbers --color=always {}')
    if ($file != "") { bat $file }
}
```

#### 2. POSIX Shell Aliases (`cli/cmd/`)

- **Universal Compatibility**: Work across Bash and ZSH
- **Numbered Prefixes**: Load order control (00-, 10-, 20-)

```
cli/cmd/
├── aliases.sh       # Core navigation and fuzzy finding
├── git_aliases.sh   # Git workflow shortcuts
├── nvim_aliases.sh  # Neovim integration
├── stow_aliases.sh  # Dotfile management
└── ocr_aliases.sh   # Document processing
```

**Key POSIX Functions**:

```bash
# Interactive file mover with preview
mvf() {                           # Move files via fzf selection
    local files=$(fd --type f . "$dir" | fzf --multi \
        --preview="bat --style=plain --color=always {}")
    local dest="$(__fzf_pick_dir)"
    # ... move logic with confirmation
}

# Hybrid fd + ripgrep finder
rgf() {                           # Search files and contents
    fd --type file --hidden | fzf --ansi --multi \
        --preview 'bat --style=full --color=always {}' \
        --bind "reload:rg --color=always --smart-case {q} || :"
}
```

### Common Alias Categories

#### Navigation & File Management

```bash
# Directory shortcuts
alias dot="cd ~/dotfiles"           # Jump to dotfiles
alias docs="cd ~/Documents"          # Documents directory
alias dev-work="cd ~/Documents/_dev_work"  # Work projects

# Modern CLI tools
alias ll="eza --long --icons --git --all --group-directories-first"
alias lt="eza --tree --level=2 --icons --git"  # Tree view
alias c="clear"                     # Clear terminal
```

#### Development Tools

```bash
# Editor access
alias v="nvim"                      # Quick Neovim access
alias zd="zed"                      # Zed editor

# Git workflows (via git_aliases.sh/nu)
alias gs="git status"               # Git status
alias gpl="git pull"                # Git pull
alias gcm="git commit -m"           # Commit with message

# Package management
alias j="just"                      # Just task runner
alias brewup="just update-brew"     # Update Homebrew
```

### Loading Strategy

**Nushell**: Direct sourcing in `config.nu`

```nushell
source ~/dotfiles/nushell/aliases/aliases.nu
source ~/dotfiles/nushell/aliases/git_aliases.nu
```

**Bash/ZSH**: Via `source_sh_files` function

```bash
# From cli/lib/load_core.sh
source_sh_files "$CLI_DIR/cmd"      # Loads all *.sh files in order
```

This dual system ensures feature parity while leveraging each shell's strengths - Nushell's structured data handling and POSIX shells' universal compatibility.

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
