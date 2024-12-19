#!/bin/zsh

# Install xCode cli tools
echo "Installing commandline tools..."
xcode-select --install

# Homebrew
## Install
echo "Installing Brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

### Terminal
brew install neovim
brew install nushell
brew install zsh-autosuggestions
brew install zsh-fast-syntax-highlighting
brew install zoxide
brew install starship
brew install carapace

## Casks
echo "Installing Brew Casks..."
### Terminals & Browsers
brew install --cask wezterm

### IDE
brew install --cask zed

### Office
brew install --cask inkscape
brew install --cask libreoffice
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
