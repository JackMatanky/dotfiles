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

# Package Directory
PACKAGES="$DOTFILES_DIR/packages"
BREWFILE="$PACKAGES/brewfile"           # Shared Brewfile (Mac & Linux)
BREWFILE_CASK="$PACKAGES/brewfile_cask" # Brewfile Cask (Mac)
BREWFILE_MAS="$PACKAGES/brewfile_mas"   # Mac App Store only
CARGO_PACKAGES="$PACKAGES/cargo-packages.txt"
FLATPAK_MANIFEST="$PACKAGES/flatpak-manifest.json"

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

# --------------------------------------------
# Homebrew
# --------------------------------------------
# Install System Dependencies for Homebrew
# Xcode for macOS, packages per linux distribution
install_system_dependencies() {
    if [[ "$OS" == "Darwin" ]]; then
        # Ensure Xcode Command Line Tools are installed
        if ! xcode-select -p &>/dev/null; then
            echo "Installing Xcode Command Line Tools..."
            xcode-select --install
            until xcode-select -p &>/dev/null; do
                sleep 5
            done
        else
            echo "✅ Xcode Command Line Tools already installed."
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

        # Install necessary build dependencies
        case "$DISTRO" in
            ubuntu|debian)
                sudo apt-get update && sudo apt-get install -y build-essential procps curl file git flatpak
                ;;
            fedora|centos|rhel)
                sudo yum groupinstall -y 'Development Tools'
                sudo yum install -y procps-ng curl file git flatpak
                ;;
            arch)
                sudo pacman -S --noconfirm base-devel procps-ng curl file git flatpak
                ;;
            *)
                echo "❌ Unsupported Linux distribution: $DISTRO. Install dependencies manually."
                exit 1
                ;;
        esac
    fi
}

# Install Homebrew
install_homebrew() {
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$($BREW_PATH shellenv)"  # Ensure Brew is available in this session
    else
        echo "Homebrew is already installed."
    fi
}

# Install packages using Brewfiles
install_homebrew_packages() {
    eval "$($BREW_PATH shellenv)"  # Ensure Brew is loaded

    if [[ -f "$BREWFILE" ]]; then
        echo "📦 Installing Homebrew packages..."
        brew bundle --file="$BREWFILE"
    else
        echo "⚠️ Brewfile not found! Skipping package installation."
    fi

    if [[ "$OS" == "Darwin" ]]; then
        if [[ -f "$BREWFILE_CASK" ]]; then
            echo "📦 Installing macOS Cask packages..."
            brew bundle --file="$BREWFILE_CASK"
        fi

        if [[ -f "$BREWFILE_MAC" ]]; then
            if mas account &>/dev/null; then
                echo "📦 Installing Mac App Store apps..."
                brew bundle --file="$BREWFILE_MAC"
            else
                echo "⚠️  Skipping Mac App Store installs: not signed into Apple ID."
                echo "    Tip: Open the App Store and sign in before rerunning this script."
            fi
        fi
    fi

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

# --------------------------------------------
# Flatpak Applications (Linux Only)
# --------------------------------------------
install_flatpak() {
    if [[ "$OS" == "Linux" && -f "$FLATPAK_MANIFEST" ]]; then
        echo "📦 Installing Flatpak applications..."
        flatpak install -y --noninteractive --from "$FLATPAK_MANIFEST"
    else
        echo "⚠️ Flatpak manifest not found or not applicable."
    fi
}

# --------------------------------------------
# Rust & Cargo
# --------------------------------------------
install_rust() {
    if ! command -v cargo &>/dev/null; then
        echo "🦀 Installing Rust & Cargo..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    else
        echo "✅ Rust & Cargo already installed. 🦀"
    fi
}

install_cargo_packages() {
    if [[ -f "$CARGO_PACKAGES" ]]; then
        echo "📦 Installing Cargo binaries... 🦀"

        # Ensure cargo-binstall is installed first
        if ! command -v cargo-binstall &>/dev/null; then
            echo "🚀 Installing cargo-binstall..."
            cargo install cargo-binstall
        fi

        while read -r package; do
            cargo binstall "$package" -y
        done < "$CARGO_PACKAGES"

        echo "✅ Cargo packages installed!"
    else
        echo "⚠️ Cargo package list not found!"
    fi
}

# --------------------------------------------
# Just (Task Runner)
# --------------------------------------------
install_just() {
    if ! command -v just &>/dev/null; then
        echo "⚡ Installing Just (Task Runner)..."
        curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin
    else
        echo "✅ Just is already installed."
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

# --------------------------------------------
# Set Nushell as Default Shell
# --------------------------------------------
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
install_system_dependencies
install_homebrew
install_rust
install_just
clone_repo "$DOTFILES_REPO" "$DOTFILES_DIR"  # Clone dotfiles
install_homebrew_packages
install_cargo_packages
install_flatpak
setup_symlinks
set_default_shell

echo "🎉 Dotfiles setup complete!"
