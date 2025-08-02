#!/bin/bash
# Run once script to install essential dependencies
# This script runs only once when chezmoi is first applied
# shellcheck disable=SC1073,SC1009,SC1056,SC1072,SC1020

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're on macOS or Linux
OS="{{ .chezmoi.os }}"
ARCH="{{ .chezmoi.arch }}"

log_info "Setting up essential dependencies for $OS ($ARCH)..."

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    {{- if eq .chezmoi.os "darwin" }}
    if [[ "$ARCH" == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    {{- else if eq .chezmoi.os "linux" }}
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    {{- end }}
    
    log_success "Homebrew installed successfully"
else
    log_success "Homebrew already installed"
fi

# Install essential tools that other configs depend on
log_info "Installing essential CLI tools..."

ESSENTIAL_TOOLS=(
    "git"
    "zsh"
    "starship"
    "direnv"
    {{- if .dev.use_rust }}
    "rustup"
    {{- end }}
    {{- if .dev.use_python }}
    "python@3.11"
    {{- end }}
    {{- if .dev.use_node }}
    "node"
    {{- end }}
)

for tool in "${ESSENTIAL_TOOLS[@]}"; do
    if brew list "$tool" &>/dev/null; then
        log_success "$tool already installed"
    else
        log_info "Installing $tool..."
        brew install "$tool"
        log_success "$tool installed"
    fi
done

# Install just if not present (for task automation)
if ! command -v just &> /dev/null; then
    log_info "Installing just (task runner)..."
    brew install just
    log_success "Just installed"
else
    log_success "Just already installed"
fi

{{- if eq .chezmoi.os "linux" }}
# Linux-specific setup
log_info "Setting up Linux-specific dependencies..."

# Install flatpak if not present
if ! command -v flatpak &> /dev/null; then
    log_info "Installing Flatpak..."
    case "{{ .platform.package_manager | default "apt" }}" in
        "apt")
            sudo apt update && sudo apt install -y flatpak
            ;;
        "pacman")
            sudo pacman -S --noconfirm flatpak
            ;;
        "dnf")
            sudo dnf install -y flatpak
            ;;
        *)
            log_warn "Unknown package manager, please install flatpak manually"
            ;;
    esac
    
    # Add Flathub repository
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    log_success "Flatpak installed and configured"
else
    log_success "Flatpak already installed"
fi
{{- end }}

log_success "Essential dependencies setup complete!"
log_info "You may need to restart your shell or run 'exec \$SHELL' to use new tools"
