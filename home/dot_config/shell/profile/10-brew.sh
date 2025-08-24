# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/shell/profile/10-brew.sh
# Description: Sets up Homebrew environment for macOS and Linux. Defines
#              installation path, library paths, build flags, and prepends
#              platform-specific binaries to $PATH.
#              NOTE: Sourced by shells; do not enable set -e/-u here.
# -----------------------------------------------------------------------------

# ------------------------------------------------------------ #
#                Homebrew Installation Directory               #
# ------------------------------------------------------------ #
# Resolve Homebrew prefix (prefer brew; else platform fallback).
# Default fallback to empty string if OS is unknown
if command -v brew >/dev/null 2>&1; then
    HOMEBREW="$(brew --prefix 2>/dev/null || true)"
elif [[ "${OS}" == "Darwin" && -d /opt/homebrew ]]; then
    HOMEBREW="/opt/homebrew"
elif [[ "${OS}" == "Linux" && -d /home/linuxbrew/.linuxbrew ]]; then
    HOMEBREW="/home/linuxbrew/.linuxbrew"
else
    HOMEBREW=""
fi
export HOMEBREW

# -------------------- Homebrew Base Paths ------------------- #
[[ -n "${HOMEBREW}" ]] && export BREW_OPT_DIR="${HOMEBREW}/opt"
[[ -n "${HOMEBREW}" ]] && export BREW_BIN_DIR="${HOMEBREW}/bin"
[[ -n "${HOMEBREW}" ]] && export BREW_SBIN_DIR="${HOMEBREW}/sbin"
[[ -n "${HOMEBREW}" ]] && export BREW_LIB_DIR="${HOMEBREW}/lib"
[[ -n "${HOMEBREW}" ]] && export BREW_INCLUDE_DIR="${HOMEBREW}/include"

# ----------- Build Flags For Brew-Linked Libraries ---------- #
# Help C extension modules (e.g., pygraphviz) locate
# Brew-installed headers and libraries
[[ -n "${BREW_INCLUDE_DIR:-}" ]] && export CFLAGS="-I${BREW_INCLUDE_DIR} ${CFLAGS:-}"
[[ -n "${BREW_LIB_DIR:-}" ]] && export LDFLAGS="-L${BREW_LIB_DIR} ${LDFLAGS:-}"

# ------------- Path Configuration (OS-Specific) ------------- #
[[ -n "${BREW_BIN_DIR:-}" && -d "${BREW_BIN_DIR}" ]] && path_prepend "${BREW_BIN_DIR}"
[[ -n "${BREW_SBIN_DIR:-}" && -d "${BREW_SBIN_DIR}" ]] && path_prepend "${BREW_SBIN_DIR}"

# Prefer Homebrew Bash ahead of system paths for `/usr/bin/env bash`
# to resolve to Bash 5.x
BREW_BASH_EXEC="${BREW_BIN_DIR:-}/bash"
[[ -d "${BREW_BASH_DIR}" ]] && path_prepend "${BREW_BASH_EXEC}"

# Homebrew (Linuxbrew), Neovim, OpenJDK
if [[ "$OS" == "Darwin" ]]; then
    # macOS-specific paths
    [[ -n "${HOMEBREW:-}" ]] && OPENJDK_DIR="${HOMEBREW}/opt/openjdk/bin"
    [[ -x "${OPENJDK_DIR}/java" ]] && path_prepend "${OPENJDK_DIR}"
elif [[ "$OS" == "Linux" ]]; then
    # Linux-specific paths
    LINUX_NVIM="/usr/bin/nvim"
    [[ -x "${LINUX_NVIM}" ]] && path_prepend "${LINUX_NVIM%/*}"

    LINUX_JAVA_DIR="/usr/lib/jvm/java-17-openjdk-amd64/bin"
    [[ -d "${LINUX_JAVA_DIR}" ]] && path_prepend "${LINUX_JAVA_DIR}"
fi

# ---------------------------- Cleanup ---------------------------------- #
unset BREW_BASH_EXEC
