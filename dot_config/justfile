# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/justfile
# Github: https://github.com/casey/just
# Docs: https://just.systems/man/en/
# Description: Justfile for automating system setup and package installations.
# -----------------------------------------------------------------------------

# -------------------------------------------------------- #
#                        OS Metadata                       #
# -------------------------------------------------------- #
OS_FAMILY := os_family()

# Options: "android", "bitrig", "dragonfly", "emscripten", "freebsd", "haiku",
# "ios", "linux", "macos", "netbsd", "openbsd", "solaris", "windows"
OS := os()

# 🎯 Human-readable OS name for display/logging
OS_NAME := if OS =~ '.*os$' {
    replace(OS, "os", "OS")
} else if OS =~ '.*bsd$' {
    replace(OS, "bsd", "BSD")
} else if OS == "dragonfly" {
    "DragonFly"
} else {
    capitalize(OS)
}


# -------------------------------------------------------- #
#                   Directory Definitions                  #
# -------------------------------------------------------- #

PACKAGES_DIR := "~/dotfiles/packages"
SCRIPTS_DIR := "~/dotfiles/scripts"
BREWFILE := PACKAGES_DIR / "brewfile"
BREWFILE_CASK := PACKAGES_DIR / "brewfile_cask"
BREWFILE_MAS := PACKAGES_DIR / "brewfile_mas"
CARGO_PACKAGES := PACKAGES_DIR / "cargo-packages.txt"
FLATPAK_MANIFEST := PACKAGES_DIR / "flatpak-manifest.json"

# -------------------------------------------------------- #
#                     📌 Core Interface                    #
# -------------------------------------------------------- #

# 📌 Default: Show available recipes
[group('Core')]
default:
    @just --list --unsorted

# -------------------------------------------------------- #
#                    🛠️ Helper Recipes                     #
# -------------------------------------------------------- #

# 🛠️ Print unavailable package manager message
[group('Helpers')]
print_unavailable reason os_name:
    @echo "❌ {{ reason }} is not available on {{ os_name }}."

# 🛠️ Log a task message with 🍺 prefix
[group("Helpers")]
log task:
    @echo "🔄 {{ task }}... 🍺"

# 🛠️ Banner for brew-specific updates
[group("Helpers")]
brew_install_banner message:
    @echo "📦 Installing Homebrew {{ message }}... 🍺"

# 🛠️ Banner for brew-specific updates
[group("Helpers")]
brew_update_banner message:
    @echo "🔄 Updating {{ message }}... 🍺"

# -------------------------------------------------------- #
#                  🖥️ System Dependencies                  #
# -------------------------------------------------------- #

# Install xcode tools as a prerequisite for Homebrew
[group("System")]
[macos]
xcode_tools_installation:
    #!/usr/bin/env bash
    @if xcode-select -p &>/dev/null; then \
        echo "✅ Xcode Command Line Tools already installed."; \
    else \
        echo "🔧 Installing Xcode Command Line Tools..."; \
        xcode-select --install; \
        echo "⏳ Waiting for installation to complete..."; \
        until xcode-select -p &>/dev/null; do \
            sleep 5; \
        done; \
        echo "✅ Installation complete."; \
    fi

# Install Linux System Dependencies
[group("System")]
[linux]
install-system-dependencies:
    @echo "📦 Installing system dependencies..."
    bash SCRIPTS_DIR / "install-system-dependencies.sh"

# -------------------------------------------------------- #
#                 🍺 Homebrew Installation                 #
# -------------------------------------------------------- #

# Show message if Homebrew is already installed
[group("Homebrew")]
brew-already-installed:
    @echo "✅ Homebrew is already installed."

# Install Homebrew
[group("Homebrew")]
brew-not-installed:
    @echo "🔹 Installing Homebrew..."
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sh
    @echo "✅ Homebrew installation complete!"

# Check if Homebrew is installed; if not, install it
[group("Homebrew")]
[unix]
install-homebrew:
    just xcode_tools_installation
    @echo "🍺 Checking if Homebrew is installed..."
    @command -v brew &>/dev/null && just brew-already-installed || just brew-not-installed

# Install Homebrew Core Packages
[group("Homebrew")]
[unix]
install-homebrew-packages:
    just brew_install_banner "Packages"
    brew bundle --file="{{ BREWFILE }}"

# Install Homebrew Cask Packages
[group("Homebrew")]
[macos]
install-homebrew-casks:
    just brew_install_banner "Casks on macOS"
    brew bundle --file={{ BREWFILE_CASK }}

# Install Homebrew Mac App Store Packages
[group("Homebrew")]
[macos]
install-homebrew-mas:
    just brew_install_banner "MacOS App Store Applications"
    brew bundle --file="{{ BREWFILE_MAS }}"

# 🏗️ Setup Homebrew for Linux
[group("Homebrew")]
[linux]
setup-homebrew-linux:
    @echo "🔹 Setting up Homebrew for Linux..."
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
    echo "✅ Homebrew environment setup complete!"

# 🏗️ Setup OpenJDK on macOS
[group("Homebrew")]
[macos]
setup-openjdk:
    @echo "🔹 Setting up OpenJDK on macOS..."
    @if [[ $(brew list openjdk &>/dev/null) ]]; then \
        sudo ln -sfn "$(brew --prefix)/opt/openjdk/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk.jdk; \
        echo "✅ OpenJDK symlinked!"; \
    fi

# -------------------------------------------------------- #
#      📦 Package Installation (Flatpak, Rust, Cargo)      #
# -------------------------------------------------------- #

# Install Flatpak applications
[group("Package Installation")]
[linux]
install-flatpak:
    @echo "📦 Installing Flatpak applications..."
    flatpak install -y --noninteractive < "{{ FLATPAK_MANIFEST }}"

# 🦀 Install Rust & Cargo
[group("Package Installation")]
install-rust:
    @echo "🦀 Installing Rust & Cargo..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    @echo "🔄 Restarting shell..."
    exec "$SHELL"

# 📦 Ensure `cargo-binstall` is installed 🦀
[group("Package Installation")]
ensure-cargo-binstall:
    @if ! command -v cargo-binstall &>/dev/null; then \
        echo "🚀 Installing cargo-binstall first..."; \
        cargo install cargo-binstall; \
    fi

# 📦 Install Cargo packages using `cargo-binstall` 🦀
[group("Package Installation")]
install-cargo-packages:
    just ensure-cargo-binstall
    @if [[ -f "{{ CARGO_PACKAGES }}" ]]; then \
        @echo "📜 Found cargo package list: {{ CARGO_PACKAGES }}"; \
        xargs -n1 cargo binstall -y < "{{ CARGO_PACKAGES }}"; \
        @echo "✅ Cargo packages installed!"; \
    else \
        @echo "⚠️ Cargo package list not found at {{ CARGO_PACKAGES }}. Skipping installation."; \
    fi

# 🚀 Install all packages: homebrew, system dependencies, homebrew packages, flatpak, rust, cargo packages
[group("Package Installation")]
install-all:
    @echo "🚀 Installing everything..."
    just install-homebrew
    just install-system-dependencies
    just install-homebrew-packages
    just install-flatpak
    just install-rust
    just install-cargo-packages
    @echo "✅ All installations complete!"

# -------------------------------------------------------- #
#                   🔄 Updating Packages                   #
# -------------------------------------------------------- #

# ----------------------- Homebrew ----------------------- #

# Upgrade all available Mac App Store applications
[group("Package Updates")]
[macos]
update-brew-mac:
    just brew_update_banner "Mac App Store Applications"
    @mas upgrade

# List outdated Homebrew formulae and casks
[group("Package Updates")]
[unix]
update-brew-outdated:
    just brew_update_banner "Homebrew Packages (Outdated)"
    @brew outdated || true

# Upgrade all outdated Homebrew packages
[group("Package Updates")]
[unix]
upgrade-brew:
    just brew_update_banner "Homebrew Packages"
    @brew upgrade

# Remove old Homebrew downloads and outdated versions
[group("Package Updates")]
[unix]
cleanup-brew:
    echo "Cleaning up Homebrew..."
    @brew cleanup

# Full Homebrew and App Store Update Routine (Interactive)
[group("Package Updates")]
[unix]
update-brew:
    # Update Homebrew itself
    just brew_update_banner "Homebrew"
    brew update

    # Optionally update Mac App Store apps (macOS only)
    @if [ "{{ OS }}" = "macos" ]; then just update-brew-mac; fi

    # Show outdated packages
    just update-brew-outdated

    # Prompt for upgrading packages
    @bash -c "read -p 'Upgrade all outdated Homebrew packages? [y/N]: ' yn; \
    if [ \"\$yn\" = \"y\" ]; then \
        just upgrade-brew; \
    else \
        echo 'Skipping Homebrew package upgrades.'; \
    fi"

    # Prompt for cleaning up
    @bash -c "read -p 'Run brew cleanup to free disk space? [y/N]: ' yn; \
    if [ \"\$yn\" = \"y\" ]; then \
        just cleanup-brew; \
    else \
        echo 'Skipping brew cleanup.'; \
    fi"

# -------------------- Rust and Cargo -------------------- #

# 🔄 Update Rust and Cargo packages 🦀
[group("Package Updates")]
update-rust:
    @echo "🔄 Updating Rust and Cargo... 🦀"
    rustup update

# 🔄 Update installed Cargo packages 🦀
[group("Package Updates")]
update-cargo-packages:
    @echo "🔄 Updating Cargo packages... 🦀"
    if [[ -f "{{ CARGO_PACKAGES }}" ]]; then \
        cargo binstall -y -r < "{{ CARGO_PACKAGES }}"; \
        @echo "✅ Cargo packages updated!"; \
    else \
        @echo "⚠️ Cargo package list not found at {{ CARGO_PACKAGES }}. Skipping update."; \
    fi

# Update Flatpak packages
[group("Package Updates")]
[linux]
update-flatpak:
    @echo "🔄 Updating Flatpak applications..."
    flatpak update -y

# 🔄 Update homebrew packages, flatpak, rust, cargo packages
[group("Package Updates")]
update-all:
    @echo "🔄 Updating all package managers..."
    just update-brew
    @if [ "{{ OS }}" == "linux" ]; then just update-flatpak; fi
    just update-rust
    just update-cargo-packages
    @echo "✅ All updates complete!"

# -------------------------------------------------------- #
#                       Tmux Utilities                     #
# -------------------------------------------------------- #

# Path to tmux config
TMUX_CONF := "~/.config/tmux/tmux.conf"
SESSION_NAME_DEFAULT := "bootstrap"

# Reload tmux configuration file
# Reload the tmux configuration file and display a message
[group("TMUX")]
tmux-reload:
    @tmux source-file {{TMUX_CONF}}
    @tmux display-message "Reloaded tmux config!"

# Start a detached tmux session and preload the config
# Bootstrap a detached tmux session and copy attach command
[group("TMUX")]
tmux-bootstrap SESSION_NAME=SESSION_NAME_DEFAULT:
    @tmux new-session -d -s {{SESSION_NAME}} 'sleep 1'
    @just tmux-reload
    @echo "Started tmux. Attach with: tmux attach -t {{SESSION_NAME}}"
    @echo "tmux attach -t {{SESSION_NAME}}" | pbcopy

# Returns 1 if true; otherwise, fails silently
# Check if a tmux session exists.
[group("TMUX")]
tmux-has-session SESSION_NAME:
    @tmux has-session -t {{SESSION_NAME}} 2>/dev/null

# Attach to a existing, named tmux session
[group("TMUX")]
tmux-attach SESSION_NAME:
    @tmux attach -t {{SESSION_NAME}}

# Try to attach if the session exists
# Attach only if the session already exists
[group("TMUX")]
tmux-attach-if-exists SESSION_NAME:
    @just tmux-has-session {{SESSION_NAME}} && just tmux-attach {{SESSION_NAME}}

# Bootstrap a new session then attach
# Create and attach to a new tmux session
[group("TMUX")]
tmux-bootstrap-attach SESSION_NAME:
    @just tmux-bootstrap {{SESSION_NAME}}
    @just tmux-attach {{SESSION_NAME}}

# Main entrypoint: attach or bootstrap as needed
# Attach to session if exists, else bootstrap and attach
[group("TMUX")]
tmux-up SESSION_NAME=SESSION_NAME_DEFAULT:
    @just tmux-attach-if-exists {{SESSION_NAME}} || just tmux-bootstrap-attach {{SESSION_NAME}}

# -------------------------------------------------------- #
#                  📝 Document Processing                  #
# -------------------------------------------------------- #
# Use OCRmyPDF to convert PDFs to searchable PDFs. Usage: just ocr input.pdf output.pdf
# ocr input:
#     output = "{{input}}" | replace('.pdf', '_ocr.pdf')
#     if [ -f "{{output}}" ]; then \
#         echo "Output already exists: {{output}}"; \
#     else \
#         ocrmypdf --rotate-pages --deskew --output-type pdf {{input}} {{output}}; \
#     fi
