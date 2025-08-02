#!/usr/bin/env bash
# Filename: ~/.config/shell/functions/multiplexers.sh
# Description: Session manager functions for tmux and zellij using multiplexer utils
# Dependencies: tmux, zellij, multiplexer utils (__get_session_info)
# Docs: https://github.com/tmux/tmux, https://zellij.dev/

# ============================================================================ #
# Tmux Session Management
# ============================================================================ #

# Tmux configuration reload
alias tmx-src='tmux source-file "$HOME/.config/tmux/tmux.conf"'

# Main tmux function - session manager using multiplexer utils
tmx() {
    local session_info name dirpath
    
    # Get session name and directory from helper
    session_info="$(__get_session_info "${1:-~/}")"
    name="${session_info%|*}"
    dirpath="${session_info#*|}"
    
    # Start or attach to tmux session - inlined __tmux_session functionality
    # Change to target directory
    cd "$dirpath" || return 1
    
    # Attach to existing session or create new one
    if tmux list-sessions 2>/dev/null | grep -xq "$name"; then
        tmux attach-session -t "$name"
    else
        tmux new-session -s "$name"
    fi
}

# Interactive tmux session selection with fzf
f-tmx() {
    if [[ $# -eq 1 ]]; then
        # If session name provided, attach or create it
        tmux new-session -A -s "$1"
    else
        # Interactive session selection
        local session
        session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --prompt="Select tmux session: " --height=~50% --layout=reverse --border)
        
        if [[ -n "$session" ]]; then
            tmux attach-session -t "$session"
        else
            # If no sessions exist or none selected, create new session
            tmux new-session
        fi
    fi
}

# ============================================================================ #
# Zellij Session Management
# ============================================================================ #

# Main zellij function - session manager using multiplexer utils
zj() {
    local session_info name dirpath
    
    # Get session name and directory from helper
    session_info="$(__get_session_info "${1:-~/}")"
    name="${session_info%|*}"
    dirpath="${session_info#*|}"
    
    # Start or attach to zellij session - inlined __zellij_session functionality
    # Change to target directory
    cd "$dirpath" || return 1
    
    # Start zellij (it handles session management automatically)
    zellij attach "$name" 2>/dev/null || zellij --session "$name"
}

# Interactive zellij session selection with fzf
f-zj() {
    if [[ $# -eq 1 ]]; then
        # If session name provided, attach or create it
        zellij attach "$1" 2>/dev/null || zellij -s "$1"
    else
        # Interactive session selection using fzf
        local session
        session=$(zellij list-sessions --no-formatting 2>/dev/null | awk '{print $1}' | fzf --prompt="Select zellij session: " --height=~50% --layout=reverse --border)
        
        if [[ -n "$session" ]]; then
            zellij attach "$session"
        else
            # If no sessions exist or none selected, create new session
            zellij
        fi
    fi
}

# Dotfiles development session
zj_dot() {
    local session_info name dirpath
    session_info="$(__get_session_info "dot")"
    name="${session_info%|*}"
    dirpath="${session_info#*|}"
    
    # Start or attach to zellij session - inlined __zellij_session functionality
    # Change to target directory
    cd "$dirpath" || return 1
    
    # Start zellij (it handles session management automatically)
    zellij attach "$name" 2>/dev/null || zellij --session "$name"
}
alias zj-dot='zj_dot'

# Obsidian vault session  
zj_obsidian() {
    local session_info name dirpath
    session_info="$(__get_session_info "obsidian")"
    name="${session_info%|*}"
    dirpath="${session_info#*|}"
    
    # Start or attach to zellij session - inlined __zellij_session functionality
    # Change to target directory
    cd "$dirpath" || return 1
    
    # Start zellij (it handles session management automatically)
    zellij attach "$name" 2>/dev/null || zellij --session "$name"
}
alias zj-obsidian='zj_obsidian'

# Welcome layout session
alias zj-welcome='zellij -l welcome'
