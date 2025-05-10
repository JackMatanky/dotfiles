# shellcheck shell=bash
# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/profile/10-brew.sh
# Description: Sets up Homebrew environment for macOS and Linux. Defines
#              installation path, library paths, build flags, and prepends
#              platform-specific binaries to $PATH.
# -----------------------------------------------------------------------------

# ------------------------------------------------------------ #
#                Homebrew Installation Directory               #
# ------------------------------------------------------------ #
# Darwin = "/opt/homebrew"
# Linux = "/home/linuxbrew/.linuxbrew"
# Default fallback to empty string if OS is unknown
if [[ "$OS" == "Darwin" ]]; then
  HOMEBREW="/opt/homebrew"
elif [[ "$OS" == "Linux" ]]; then
  HOMEBREW="$(brew --prefix 2>/dev/null || echo "/home/linuxbrew/.linuxbrew")"
else
  HOMEBREW=""
fi
export HOMEBREW

# -------------------- Homebrew Base Paths ------------------- #
export BREW_OPT_DIR="${HOMEBREW:+$HOMEBREW/opt}"
export BREW_BIN_DIR="${HOMEBREW:+$HOMEBREW/bin}"
export BREW_SBIN_DIR="${HOMEBREW:+$HOMEBREW/sbin}"
export BREW_LIB_DIR="${HOMEBREW:+$HOMEBREW/lib}"
export BREW_INCLUDE_DIR="${HOMEBREW:+$HOMEBREW/include}"

# ----------- Build Flags For Brew-Linked Libraries ---------- #
# Help C extension modules (e.g., pygraphviz) locate
# Brew-installed headers and libraries
export CFLAGS="-I${BREW_INCLUDE_DIR}"
export LDFLAGS="-L${BREW_LIB_DIR}"

# ------------- Path Configuration (OS-Specific) ------------- #
# Homebrew (Linuxbrew), Neovim, OpenJDK
if [[ "$OS" == "Darwin" ]]; then
  # macOS-specific paths
  export PATH="$BREW_BIN_DIR:$PATH"
  export PATH="$BREW_BIN_DIR/nvim:$PATH"
  export PATH="$HOMEBREW/opt/openjdk/bin:$PATH"
elif [[ "$OS" == "Linux" ]]; then
  # Linux-specific paths
  export PATH="$BREW_BIN_DIR:$PATH"
  export PATH="/usr/bin/nvim:$PATH"
  export PATH="/usr/lib/jvm/java-17-openjdk-amd64/bin:$PATH"
fi
