#!/bin/bash

set -e  # Exit on error

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"

# Dotfiles Repository
DOTFILES_REPO="https://github.com/JackMatanky/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# Obsidian Repository
OBSIDIAN_REPO="https://gitlab.com/JackMatanky/obsidian_vault.git"
OBSIDIAN_DIR="$HOME/obsidian_vault"

# Homebrew Brewfile Paths
BREWFILE="$DOTFILES_DIR/brew/Brewfile"      # Shared Brewfile (Mac & Linux)
BREWFILE_MAC="$DOTFILES_DIR/brew/Brewfile_mac" # Mac App Store only

# Set Homebrew Path
if [[ "$OS" == "Darwin" ]]; then
    if [[ "$ARCH" == "arm64" ]]; then
        BREW_PATH="/opt/homebrew/bin/brew"
    else
        BREW_PATH="/usr/local/bin/brew"
    fi
else
    BREW_PATH="/home/linuxbrew/.linuxbrew/bin/brew"
fi

# Request sudo upfront
if ! sudo -v; then
    echo "Failed to obtain sudo privileges. Please run the script again with the correct password."
    exit 1
fi

# Function to install Homebrew dependencies
# Xcode for macOS, packages per linux distribution
install_homebrew_dependencies() {
    if [[ "$OS" == "Darwin" ]]; then
        # macOS: Ensure Xcode Command Line Tools are installed
        if ! xcode-select -p &>/dev/null; then
            echo "Installing Xcode Command Line Tools..."
            xcode-select --install
            until xcode-select -p &>/dev/null; do
                sleep 5
            done
        else
            echo "Xcode Command Line Tools already installed."
        fi
    elif [[ "$OS" == "Linux" ]]; then
        # Detect Linux distribution
        if [[ -f /etc/os-release ]]; then
            source /etc/os-release
            DISTRO=$ID
        else
            DISTRO="unknown"
        fi

        echo "Detected Linux distribution: $DISTRO"

        case "$DISTRO" in
            ubuntu|debian)
                echo "Installing dependencies for Ubuntu/Debian..."
                sudo apt-get update && sudo apt-get install -y build-essential procps curl file git
                ;;
            fedora|centos|rhel)
                echo "Installing dependencies for Fedora/CentOS/Red Hat..."
                sudo yum groupinstall -y 'Development Tools'
                sudo yum install -y procps-ng curl file git
                ;;
            arch)
                echo "Installing dependencies for Arch Linux..."
                sudo pacman -S --noconfirm base-devel procps-ng curl file git
                ;;
            *)
                echo "Unsupported Linux distribution: $DISTRO. Manual installation may be required."
                ;;
        esac
    fi
}

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

    if [[ -f "$BREWFILE" ]]; then
        echo "Installing shared packages from Brewfile..."
        brew bundle --file="$BREWFILE"
    else
        echo "Brewfile not found! Skipping package installation."
    fi

    # if [[ "$OS" == "Darwin" && -f "$BREWFILE_MAC" ]]; then
    #     echo "Installing Mac App Store apps from Brewfile_mac..."
    #     brew bundle --file="$BREWFILE_MAC"
    # fi

    if [[ "$OS" == "Linux" ]]; then
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
    fi

    # OpenJDK Symlink Setup (macOS)
    if [[ "$OS" == "Darwin" ]]; then
        if brew list openjdk &>/dev/null; then
            echo "Setting up OpenJDK symlink on macOS..."
            sudo ln -sfn "$($BREW_PATH --prefix)/opt/openjdk/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk.jdk
        else
            echo "OpenJDK is not installed via Homebrew. Skipping symlink."
        fi
    fi
}

# General function to clone or update a Git repository
clone_repo() {
    local REPO_URL="$1"
    local DEST_DIR="$2"

    if [[ -z "$REPO_URL" || -z "$DEST_DIR" ]]; then
        echo "Usage: clone_repo <repo_url> <destination_directory>"
        return 1
    fi

    if [[ -d "$DEST_DIR" ]]; then
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

# Function to set Nushell as the default shell
set_default_shell() {
    NU_PATH="$(command -v nu)"
    if [[ -z "$NU_PATH" ]]; then
        echo "Nushell is not installed. Skipping shell change."
        return
    fi

    # if [[ "$SHELL" != "$(which nu)" ]]; then
    #     echo "Setting Nushell as default shell..."
    #     chsh -s "$(which nu)"
    if [[ -n "$NU_PATH" && "$SHELL" != "$NU_PATH" ]]; then
        echo "Setting Nushell as default shell..."
        chsh -s "$NU_PATH"
    else
        echo "Nushell is already the default shell."
    fi
}

# Run setup
install_homebrew_dependencies
install_homebrew
clone_repo "$DOTFILES_REPO" "$DOTFILES_DIR"  # Clone dotfiles
install_brewfile
setup_symlinks
set_default_shell

echo "Dotfiles setup complete!"
