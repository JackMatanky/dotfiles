# shellcheck shell=bash
# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/profile/00-core.sh
# Description: Core shell environment setup. Detects OS, defines XDG base
#              directories, establishes user-level tool paths, default editors,
#              and other foundational configuration shared across shells.
# -----------------------------------------------------------------------------

# ----------------------- OS Detection ----------------------- #
# shellcheck disable=SC2034
OS="$(uname -s)"

# ------------------- XDG Base Directories ------------------- #
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# --------------------- Git Configuration -------------------- #
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/config"

# ---------------- Cargo: Rust Package Manager --------------- #
export PATH="$HOME/.cargo/bin:$PATH"

# ------------------------------------------------------------ #
#                   Tool Configuration Paths                   #
# ------------------------------------------------------------ #
# Centralized locations for user-specific config directories

# -------------------------- Nushell ------------------------- #
# Docs: https://www.nushell.sh
export NU_CONFIG_DIR="$XDG_CONFIG_HOME/nushell"

# ----------------- TPM: Tmux Plugin Manager ----------------- #
# Docs: https://github.com/tmux-plugins/tpm
# Used by TPM to avoid polluting tracked dotfiles
export TMUX_PLUGIN_MANAGER_PATH="$XDG_CONFIG_HOME/tmux/plugins"

# --------------- Zellij: Terminal Multiplexer --------------- #
# Docs: https://zellij.dev/documentation/
export ZELLIJ_CONFIG_DIR="$XDG_CONFIG_HOME/zellij"
export ZELLIJ_LAYOUT_DIR="$ZELLIJ_CONFIG_DIR/layouts"
export ZELLIJ_THEME_DIR="$ZELLIJ_CONFIG_DIR/themes"

# ------------------------------------------------------------ #
#                       User Environment                       #
# ------------------------------------------------------------ #
# Default editors, file picker, terminal, locale, and config paths

# -------------- Default Editors And Interfaces -------------- #
export EDITOR="nvim"        # NeoVim, or 'hx' for Helix
export VISUAL="zed"         # Zed editor
export TERMINAL="ghostty"   # Ghostty terminal
export FILE_PICKER="yazi"   # Yazi file picker

# --------------------- SSH Configuration -------------------- #
export SSH_CONFIG_DIR="$XDG_CONFIG_HOME/ssh"
export SSH_CONFIG_FILE="$SSH_CONFIG_DIR/ssh-config"

# -------------------- Language And Locale ------------------- #
export LANG="en_US.UTF-8"
