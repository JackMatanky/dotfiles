#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/shell/utils/multiplexers.sh
# Dependencies: tmux, zellij (optional)
# Description: Multiplexer session management utilities.
#              These are prefixed with `__` and are not meant for direct use.
# -----------------------------------------------------------------------------

# Get session name and directory path for predefined session keys.
#
# Supports common session shortcuts like 'dot', 'obsidian', etc.
#
# Globals:
#   HOME
# Arguments:
#   $1 - Session key (dot, dotvim, obsidian, kb, or custom path)
# Outputs:
#   Writes "session_name|directory_path" to stdout
# Returns:
#   0 always (uses defaults for unknown keys)
__get_session_info() {
    local key="${1:-~/}"
    local name dirpath
    
    case "$key" in
        dot)
            name="dotfiles"
            dirpath="$HOME/dotfiles"
            ;;
        dotvim)
            name="neovim_config"
            dirpath="$HOME/dotfiles/nvim"
            ;;
        obsidian)
            name="obsidian_vault"
            dirpath="$HOME/obsidian_vault"
            ;;
        kb)
            name="keyboard_dev"
            dirpath="$HOME/Documents/keyboard_dev"
            ;;
        *)
            # Use basename of path as session name, or 'general' for home
            if [[ "$key" == ~* ]] || [[ "$key" == "$HOME"* ]]; then
                name="general"
            else
                name="$(basename "$key")"
            fi
            dirpath="$key"
            ;;
    esac
    
    printf '%s|%s' "$name" "$dirpath"
}

# Start or attach to a tmux session using session info.
#
# Globals:
#   None
# Arguments:
#   $1 - Session name
#   $2 - Directory path
# Outputs:
#   Attaches to or creates tmux session
# Returns:
#   Exit status of tmux command
__tmux_session() {
    local name="$1"
    local dirpath="$2"
    
    # Change to target directory
    cd "$dirpath" || return 1
    
    # Attach to existing session or create new one
    if tmux list-sessions 2>/dev/null | grep -xq "$name"; then
        tmux attach-session -t "$name"
    else
        tmux new-session -s "$name"
    fi
}

# Start or attach to a zellij session using session info.
#
# Globals:
#   None
# Arguments:
#   $1 - Session name
#   $2 - Directory path
# Outputs:
#   Attaches to or creates zellij session
# Returns:
#   Exit status of zellij command
__zellij_session() {
    local name="$1"
    local dirpath="$2"
    
    # Change to target directory
    cd "$dirpath" || return 1
    
    # Start zellij (it handles session management automatically)
    zellij attach "$name" 2>/dev/null || zellij --session "$name"
}
