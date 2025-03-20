#!/bin/bash

set -e  # Exit on error

# Dotfiles Github Repository
DOTFILES_REPO="https://github.com/JackMatanky/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# Obsidian
OBSIDIAN_REPO="https://gitlab.com/JackMatanky/obsidian_vault.git"
OBSIDIAN_DIR="$HOME/obsidian_vault"

# Homebrew
BREWFILE="$DOTFILES_DIR/brew/Brewfile"
BREWFILE_MAC="$DOTFILES_DIR/brew/Brewfile_mac"

# Detect macOS architecture
ARCH=$(uname -m)
if [ "$ARCH" == "arm64" ]; then
    BREW_PATH="/opt/homebrew/bin/brew"
else
    BREW_PATH="/usr/local/bin/brew"
fi

# Function to install Homebrew
install_homebrew() {
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$($BREW_PATH shellenv)"  # Ensure Brew is available in this session
    else
        echo "Homebrew is already installed."
    fi
}

# Function to install packages using Brewfile
install_brewfile() {
    eval "$($BREW_PATH shellenv)"  # Ensure Brew is loaded
    if [ -f "$BREWFILE" ]; then
        echo "Installing packages from Brewfile..."
        brew bundle --file="$BREWFILE"
    else
        echo "Brewfile not found! Skipping package installation."
    fi
}

# General function to clone or update a Git repository
clone_repo() {
    local REPO_URL="$1"
    local DEST_DIR="$2"

    if [ -z "$REPO_URL" ] || [ -z "$DEST_DIR" ]; then
        echo "Usage: clone_repo <repo_url> <destination_directory>"
        return 1
    fi

    if [ -d "$DEST_DIR" ]; then
        echo "Repository $DEST_DIR already exists. Pulling latest changes..."
        git -C "$DEST_DIR" pull
    else
        echo "Cloning $REPO_URL into $DEST_DIR..."
        git clone "$REPO_URL" "$DEST_DIR"
    fi
}

# Function to set up symlinks with Stow
setup_symlinks() {
    cd "$DOTFILES_DIR" || exit
    echo "Stowing dotfiles using .stowrc..."
    for dir in */; do
        stow "${dir%/}"
    done
}

# Set Zsh as default shell if not already
set_default_shell() {
    if [[ "$SHELL" != "/bin/zsh" ]]; then
        echo "Setting Zsh as default shell..."
        chsh -s "$(which zsh)"
    else
        echo "Zsh is already the default shell."
    fi
}

# Run setup
install_homebrew
clone_repo "$DOTFILES_REPO" "$DOTFILES_DIR"  # Clone dotfiles
install_brewfile
setup_symlinks
set_default_shell

echo "Dotfiles setup complete!"
