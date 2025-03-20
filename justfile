# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/justfile
# Github: https://github.com/casey/just
# Docs: https://just.systems/man/en/
# Description: Justfile for automating system setup and package installations.
# -----------------------------------------------------------------------------

# 📂 Define directories
PACKAGES_DIR := "~/dotfiles/packages"
SCRIPTS_DIR := "~/dotfiles/scripts"
BREWFILE := PACKAGES_DIR / "brewfile"
BREWFILE_CASK := PACKAGES_DIR / "brewfile_cask"
BREWFILE_MAS := PACKAGES_DIR / "brewfile_mas"
CARGO_PACKAGES := PACKAGES_DIR / "cargo-packages.txt"
FLATPAK_MANIFEST := PACKAGES_DIR / "flatpak-manifest.json"

# 🖥️ Detect OS
OS := shell("uname -s")

# 📌 Default: Show available recipes
default:
    @just --list --unsorted

# -----------------------------------------------------------------------------
# 🍺 Homebrew Installation
# -----------------------------------------------------------------------------
# Check if Homebrew is already installed
homebrew-already-installed:
    @echo "✅ Homebrew is already installed."

# Check if Homebrew is not already installed and install it
homebrew-not-already-installed:
    @echo "🔹 Installing Homebrew..."
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sh
    @echo "✅ Homebrew installation complete!"

# Check if Homebrew is installed and install it if not
install-homebrew:
    @echo "🍺 Checking if Homebrew is installed..."
    @if command -v brew &>/dev/null; then \
        just homebrew-already-installed; \
    else \
        just homebrew-not-already-installed; \
    fi

# Install Homebrew Core Packages
install-homebrew-packages:
    @echo "📦 Installing Homebrew packages..."
    brew bundle --file="{{BREWFILE}}"

# Install Homebrew Cask Packages
install-homebrew-casks:
    @echo "📦 Installing Homebrew Casks (macOS only)..."
    if [[ "{{OS}}" == "Darwin" ]]; then \
        brew bundle --file="{{BREWFILE_CASK}}"; \
    else \
        @echo "❌ Cask installations are not available on Linux."; \
    fi

# Install Homebrew Mac App Store Packages
install-homebrew-mas:
    @echo "📦 Installing Mac App Store applications..."
    if [[ "{{OS}}" == "Darwin" ]]; then \
        brew bundle --file="{{BREWFILE_MAS}}"; \
    else \
        @echo "❌ App Store applications are not available on Linux."; \
    fi

# 🏗️ Setup Homebrew for Linux
setup-homebrew-linux:
    @echo "🔹 Setting up Homebrew for Linux..."
    @if [[ "{{OS}}" == "Linux" ]]; then \
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc; \
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc; \
        echo "✅ Homebrew environment setup complete!"; \
    fi

# 🏗️ Setup OpenJDK on macOS
setup-openjdk:
    @echo "🔹 Setting up OpenJDK on macOS..."
    @if [[ "{{OS}}" == "Darwin" && $(brew list openjdk &>/dev/null) ]]; then \
        sudo ln -sfn "$(brew --prefix)/opt/openjdk/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk.jdk; \
        echo "✅ OpenJDK symlinked!"; \
    fi

# -----------------------------------------------------------------------------
# 🖥️ System Dependencies (Linux)
# -----------------------------------------------------------------------------
# Install Linux System Dependencies
install-system-dependencies:
    @echo "📦 Installing system dependencies..."
    @if [[ "{{OS}}" == "Linux" ]]; then \
        bash SCRIPTS_DIR / "install-system-dependencies.sh"; \
    fi

# -----------------------------------------------------------------------------
# 📦 Package Installation (Flatpak, Rust, Cargo)
# -----------------------------------------------------------------------------

install-flatpak:
    @echo "📦 Installing Flatpak applications..."
    flatpak install -y --noninteractive < "{{FLATPAK_MANIFEST}}"

# 🔄 Restart Shell (For Rust/Cargo)
restart-shell:
    @echo "🔄 Restarting shell..."
    exec "$SHELL"

# 🦀 Install Rust & Cargo
install-rust:
    @echo "🦀 Installing Rust & Cargo..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    just restart-shell

# 📦 Install Cargo packages using `cargo-binstall` 🦀
install-cargo-packages:
    @echo "📦 Installing Cargo packages using cargo-binstall..."
    @if not command -v cargo-binstall &>/dev/null; then \
        @echo "🚀 Installing cargo-binstall first..."
        cargo install cargo-binstall
    fi

    @if [[ -f "{{CARGO_PACKAGES}}" ]]; then \
        @echo "📜 Found cargo package list: {{CARGO_PACKAGES}}"; \
        xargs -n1 cargo binstall -y < "{{CARGO_PACKAGES}}"; \
        @echo "✅ Cargo packages installed!"; \
    else \
        @echo "⚠️ Cargo package list not found at {{CARGO_PACKAGES}}. Skipping installation."; \
    fi

# -----------------------------------------------------------------------------
# 🔄 Updating Packages
# -----------------------------------------------------------------------------
update-homebrew:
    @echo "🔄 Updating Homebrew packages... 🍺"
    @if [[ "{{OS}}" == "Darwin" || "{{OS}}" == "Linux" ]]; then \
        brew update && brew upgrade && brew cleanup; \
    else \
        @echo "❌ Homebrew not available on this OS. 🍺"; \
    fi

update-flatpak:
    @echo "🔄 Updating Flatpak applications..."
    @if [[ "{{OS}}" == "Linux" ]]; then \
        flatpak update -y; \
    else \
        @echo "❌ Flatpak is not available on this OS."; \
    fi

# 🔄 Update Rust and Cargo packages 🦀
update-rust:
    @echo "🔄 Updating Rust and Cargo... 🦀"
    rustup update

# 🔄 Update installed Cargo packages 🦀
update-cargo-packages:
    @echo "🔄 Updating Cargo packages... 🦀"
    if [[ -f "{{CARGO_PACKAGES}}" ]]; then \
        cargo binstall -y -r < "{{CARGO_PACKAGES}}"; \
        @echo "✅ Cargo packages updated!"; \
    else \
        @echo "⚠️ Cargo package list not found at {{CARGO_PACKAGES}}. Skipping update."; \
    fi

# 🔄 Update homebrew packages, flatpak, rust, cargo packages
update-all:
    @echo "🔄 Updating all package managers..."
    just update-homebrew
    just update-flatpak
    just update-rust
    just update-cargo-packages
    @echo "✅ All updates complete!"

# 🚀 Install all packages: homebrew, system dependencies, homebrew packages, flatpak, rust, cargo packages
install-all:
    @echo "🚀 Installing everything..."
    just install-homebrew
    just install-system-dependencies
    just install-homebrew-packages
    just install-flatpak
    just install-rust
    just install-cargo-packages
    @echo "✅ All installations complete!"
