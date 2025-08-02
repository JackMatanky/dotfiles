#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/cmd/sessions.sh
# Dependencies: tmux, zellij, session helpers
# Description: Session management for tmux and zellij with unified interface
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    set -euo pipefail
    IFS=$'\n\t'
fi

# ------------------------------------------------------------ #
#                            Tmux                             #
# ------------------------------------------------------------ #

# Reload tmux configuration from your dotfiles.
alias tmx-src='tmux source-file "$HOME/.config/tmux/tmux.conf"'

#######################################
# tmx: Open or attach to a tmux session for a given directory key.
#
# Uses the session helper to map common shortcuts to full paths,
# then starts or attaches to the appropriate tmux session.
#
# Globals:
#   None (uses __get_session_info and __tmux_session helpers)
# Arguments:
#   $1 [KEY]: Optional session key (dot, obsidian, kb, etc.) or path
# Outputs:
#   Attaches to or creates tmux session
# Returns:
#   Exit status of tmux command
#######################################
tmx() {
    local session_info name dirpath
    
    # Get session name and directory from helper
    session_info="$(__get_session_info "${1:-~/}")"
    name="${session_info%|*}"
    dirpath="${session_info#*|}"
    
    # Start or attach to session
    __tmux_session "$name" "$dirpath"
}

# ------------------------------------------------------------ #
#                           Zellij                            #
# ------------------------------------------------------------ #

#######################################
# zj_dot: Launch zellij in ~/dotfiles
#######################################
zj_dot() {
    local session_info name dirpath
    session_info="$(__get_session_info "dot")"
    name="${session_info%|*}"
    dirpath="${session_info#*|}"
    __zellij_session "$name" "$dirpath"
}
alias zj-dot='zj_dot'

#######################################
# zj_obsidian: Launch zellij in ~/obsidian_vault
#######################################
zj_obsidian() {
    local session_info name dirpath
    session_info="$(__get_session_info "obsidian")"
    name="${session_info%|*}"
    dirpath="${session_info#*|}"
    __zellij_session "$name" "$dirpath"
}
alias zj-obsidian='zj_obsidian'

#######################################
# zj: Open or attach to a zellij session for a given directory key.
#
# Uses the session helper to map common shortcuts to full paths,
# then starts or attaches to the appropriate zellij session.
#
# Globals:
#   None (uses __get_session_info and __zellij_session helpers)
# Arguments:
#   $1 [KEY]: Optional session key (dot, obsidian, kb, etc.) or path
# Outputs:
#   Attaches to or creates zellij session
# Returns:
#   Exit status of zellij command
#######################################
zj() {
    local session_info name dirpath
    
    # Get session name and directory from helper
    session_info="$(__get_session_info "${1:-~/}")"
    name="${session_info%|*}"
    dirpath="${session_info#*|}"
    
    # Start or attach to session
    __zellij_session "$name" "$dirpath"
}
