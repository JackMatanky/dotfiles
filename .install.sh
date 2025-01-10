#!/bin/zsh

# Install xCode cli tools
echo "Installing commandline tools..."
xcode-select --install

# Homebrew
## Install
echo "Installing Brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

## Taps
echo "Tapping Brew..."
brew tap FelixKratz/formulae

## Formulae
echo "Installing Brew Formulae..."
brew install wget
brew install sketchybar
brew install borders

brew install keychain

### Terminal
brew install neovim
brew install nushell
brew install zellij
brew install zsh-autosuggestions
brew install zsh-fast-syntax-highlighting
brew install zoxide
brew install starship
brew install yazi
brew install carapace
brew install eza
brew install fzf
brew install ripgrep
brew install fd

### Development
brew install neovim
brew install helix

#### Python
brew install python
brew install uv
brew install ipython
brew install ruff

#### LSP
brew install python-lsp-server
brew install basedpyright
brew install pylyzer
brew install vscode-langservers-extracted
brew install typescript-language-server
brew install marksman
brew install markdownlint-cli
brew install texlab
brew install yaml-language-server


### Nice to have
brew install lazygit
brew install prettier

### Anki Media Converter
brew install webp
brew install avif

## Casks
echo "Installing Brew Casks..."
### Terminals & Browsers
brew install --cask wezterm

### IDE
brew install --cask zed

### Office
brew install --cask inkscape
brew install --cask libreoffice
brew install --cask libreoffice-language-pack
brew install --cask zoom
brew install --cask meetingbar
brew install --cask skim
brew install --cask vlc

### Fonts
brew install --cask sf-symbols
brew install --cask font-sf-mono
brew install --cask font-sf-pro
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono
brew install --cask font-fira-code

### PKM
brew install --cask obsidian
brew install --cask anki
