# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/shell/profile/00-core.sh
# Description: Core shell environment shared across shells.
#          - Detect OS once (exported for reuse)
#          - Define XDG base directories
#          - Establish user/default editors, locale, tool/config paths
#          - Load PATH helpers and add user-level tool paths safely
#          - NOTE: Sourced by interactive shells; avoid set -e/-u here.
# -----------------------------------------------------------------------------

# Require HOME; hard-fail if unset/empty
: "${HOME:?HOME must be set}"

# ----------------------- OS Detection ----------------------- #
# Export once; other scripts should reuse $OS instead of recomputing.
export OS="${OS:-$(uname -s)}"

# ------------------- XDG Base Directories ------------------- #
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# ---------------- Internal Path Constants ------------------- #
# Readability helpers (not exported).
readonly SHELL_DIR="${XDG_CONFIG_HOME}/shell"
readonly UTILS_DIR="${SHELL_DIR}/utils"
readonly PATH_UTILS="${UTILS_DIR}/path.sh"

# ------------------- PATH Helpers Script -------------------- #
# Load PATH helpers (prepend/append without duplicates)
# shellcheck source=/dev/null
[[ -r "$PATH_UTILS" ]] && source "$PATH_UTILS"

# --------------------- Git Configuration -------------------- #
export GIT_CONFIG_GLOBAL="${XDG_CONFIG_HOME}/git/config"

# ---------------- Cargo: Rust Package Manager --------------- #
# Add Cargo bin to PATH safely (single directory argument).
# Docs: https://doc.rust-lang.org/cargo/
[[ -d "${HOME}/.cargo/bin" ]] && __path_prepend "${HOME}/.cargo/bin"

# ------------------------------------------------------------ #
#                   Tool Configuration Paths                   #
# ------------------------------------------------------------ #
# Centralized locations for user-specific config directories

# -------------------------- Nushell ------------------------- #
# Docs: https://www.nushell.sh
export NU_CONFIG_DIR="${XDG_CONFIG_HOME}/nushell"

# ----------------- TPM: Tmux Plugin Manager ----------------- #
# Docs: https://github.com/tmux-plugins/tpm
# Used by TPM to avoid polluting tracked dotfiles
export TMUX_PLUGIN_MANAGER_PATH="${XDG_CONFIG_HOME}/tmux/plugins"

# --------------- Zellij: Terminal Multiplexer --------------- #
# Docs: https://zellij.dev/documentation/
export ZELLIJ_CONFIG_DIR="${XDG_CONFIG_HOME}/zellij"
export ZELLIJ_LAYOUT_DIR="${ZELLIJ_CONFIG_DIR}/layouts"
export ZELLIJ_THEME_DIR="${ZELLIJ_CONFIG_DIR}/themes"

# --------------------- SSH Configuration -------------------- #
export SSH_CONFIG_DIR="${XDG_CONFIG_HOME}/ssh"
export SSH_CONFIG_FILE="${SSH_CONFIG_DIR}/ssh-config"

# ------------------------------------------------------------ #
#                       User Environment                       #
# ------------------------------------------------------------ #
# Default editors, file picker, terminal, locale, and config paths

# --------------- Default Editors & Interfaces --------------- #
export EDITOR="${EDITOR:-nvim}"        # NeoVim, or 'hx'
export VISUAL="${VISUAL:-zed}"         # Zed editor
export TERMINAL="${TERMINAL:-ghostty}"   # Ghostty terminal
export FILE_PICKER="${FILE_PICKER:-yazi}"   # Yazi file picker

# --------------------- Language & Locale -------------------- #
# Keep locale consistent; LC_ALL defaults to LANG if unset.
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-$LANG}"
