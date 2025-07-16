#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/cli/cmd/aliases.sh
# Dependencies: fd, fzf, eza, bat, pbcopy (macOS), tmux, zellij, zoxide
# Description: Aliases and functions for navigation, fuzzy finding, tmux/zellij
#              sessions, and various tooling integrations.
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    # Fail on errors, unset variables, and pipeline errors.
    set -euo pipefail

    # Set IFS to newline and tab to ensure safe word splitting.
    IFS=$'\n\t'
fi

# ------------------------------------------------------------ #
#                          Navigation                          #
# ------------------------------------------------------------ #

#######################################
# cx: Change to a directory by name or via fzf, then list contents with eza.
#
# If no argument is provided, fzf is used to select a directory, with
# a preview of the target directory's tree. If a target is chosen, the
# shell will change into it and list its contents with the eza command.
#
# Globals:
#   None
# Arguments:
#   $1 [DIR]: Optional. Directory path or tag; if omitted, select via fzf.
# Outputs:
#   Directory listing via eza to STDOUT.
# Returns:
#   0 if navigation succeeds, non-zero on failure.
#######################################
cx() {
    local target="${1:-}"
    if [ -z "$target" ]; then
        # select a directory with fzf and preview its tree
        target="$(__fzf_pick_dir)"
    fi

    if [ -n "$target" ]; then
        # if a target is chosen, cd into it and list contents
        __cd_and_run "$target" eza -la --group-directories-first --icons
    fi
}

#######################################
# f: Fuzzy-find a file, preview with bat (or cat), and copy its path to clipboard.
# The preview window displays the contents of the selected file with bat.
# If a file is selected, its path is copied to the system clipboard.
#
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Copies selected path to the system clipboard.
# Returns:
#   0 if successful, non-zero otherwise.
#######################################
f() {
    local file
    # find files and preview
    file="$(__fzf_pick_file)"
    if [ -n "$file" ]; then
        # copy selection if any
        printf '%s' "$file" | pbcopy
    fi
}

#######################################
# rgf: Hybrid fd + ripgrep fuzzy file finder with bat preview.
#
# This function combines the best of both worlds from fd and rg:
#   1. fd: fast file discovery with fuzzy matching
#   2. rg: ability to search file contents with ripgrep
# The preview window displays the contents of the selected file with bat.
#
# Globals:
#   None
# Arguments:
#   $@ [QUERY...] - Optional query string to pre-populate fzf.
# Outputs:
#   Displays search results with preview to STDOUT.
# Returns:
#   Exit code of fzf.
#######################################
rgf() (
    local reload_cmd
    # define reload on query change: ripgrep or no-op, split for readability
    reload_cmd=$'reload:rg --column --line-number \
                --no-heading --color=always \
                --smart-case {q} || :'
    # initial file list
    eval 'fd --type file --hidden --follow --exclude .git' |
        fzf --ansi --multi --preview 'bat --style=full --color=always {} || cat {}' \
            --bind "$reload_cmd" \
            --delimiter : \
            --preview-window 'right:60%' \
            --query "$*"
)

# ------------------------------------------------------------ #
#                        Shell Commands                        #
# ------------------------------------------------------------ #
alias c='clear'
alias l='ls -l'

# -----------------------------
#  Interactive mv Helper (mvf)
# -----------------------------
#
#######################################
# mvf: Interactive helper to move one or more files to a selected directory
# using fd and fzf. Supports optional source directory filtering, bat previews,
# dry-run simulation, and confirmation prompts.
#
# Usage:
#   mvf [--dir <source_dir>] [--current-dir] [--dry-run] [--confirm]
#
# Example:
#   mvf --dir ~/Downloads --dry-run
#
# Arguments:
#   --dir <source_dir>     Filter files from this directory.
#   --current-dir          Shortcut for '--dir .'
#   --dry-run              Show the command without executing.
#   --confirm              Prompt before execution.
# Outputs:
#   Progress and dry-run information to STDOUT.
# Returns:
#   0 if files are moved; non-zero on error or cancellation.
#######################################
mvf() {
    local dir="."
    local dry_run=false
    local confirm=false
    local arg

    # Parse flags
    while [[ $# -gt 0 ]]; do
        arg="$1"
        case "$arg" in
            --current-dir)
                dir="."
                shift
                ;;
            --dir)
                dir="$2"
                shift 2
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            --confirm)
                confirm=true
                shift
                ;;
            *)
                echo "Unknown option: $arg" >&2
                return 1
                ;;
        esac
    done

    # Select files to move
    local files
    files=$(fd --type f . "$dir" | fzf --multi \
        --prompt="Select file(s) to move: " \
        --preview="bat --style=plain --color=always --line-range :40 {}")

    if [[ -z "$files" ]]; then
        echo "No files selected."
        return 1
    fi

    # Choose destination directory
    local dest
    dest="$(__fzf_pick_dir)"

    if [[ -z "$dest" ]]; then
        echo "No destination selected."
        return 1
    fi

    # Confirm action if requested
    if $confirm; then
        echo -e "\nSelected files:\n$files"
        echo "Destination: $dest"
        read -rp "Proceed with move? [y/N]: " choice
        if [[ ! "$choice" =~ ^[Yy]$ ]]; then
            echo "Operation cancelled."
            return 1
        fi
    fi

    # Move or simulate move
    local file
    while IFS= read -r file; do
        if $dry_run; then
            echo "[Dry Run] mv \"$file\" \"$dest/\""
        else
            mv "$file" "$dest" && echo "Moved '$file' -> '$dest/'"
        fi
    done <<< "$files"
}


# ------------------------- Justfile ------------------------- #
alias j='just'

# ---------------------------- EZA --------------------------- #
# Docs: https://github.com/eza-community/eza
# Detailed File List
alias ll='eza --long --icons --git --all --group-directories-first'
# Tree Views
alias lt='eza --tree --level=2 --icons --git'    # 2 levels
alias ltree='eza --tree --level=3 --icons --git' # 3 levels

# -------------------------- Zoxide -------------------------- #
# Docs: https://github.com/ajeetdsouza/zoxide
alias za='zoxide add'
alias zq='zoxide query'

# ------------------------------------------------------------ #
#                          Directories                         #
# ------------------------------------------------------------ #
alias conf-dir='cd ~/.config'
alias docs='cd ~/Documents'

# ------------------------- Dotfiles ------------------------- #
alias dot='cd ~/dotfiles'
alias dot-nix='cd ~/dotfiles/nixos'

# ---------------------- Obsidian Vault ---------------------- #
alias obsidian='cd ~/obsidian_vault'

# Pull latest in Obsidian vault
#
# Usage:
#   obsidian_gpl
obsidian_gpl() {
    cd ~/obsidian_vault && git pull
}
alias obsidian-gpl='obsidian_gpl'

# ----------------------- Keyboard Dev ----------------------- #
alias kb-dev='cd ~/Documents/keyboard_dev'
alias kb-ergogen='cd ~/Documents/keyboard_dev/ergogen'
alias kb-zmk='cd ~/Documents/keyboard_dev/zmk-config'
alias kb-snak_dir='cd ~/Documents/keyboard_dev/kb_snak'

# --------------------------- Work --------------------------- #
alias dev-work='cd ~/Documents/_dev_work'
alias dev-hive='cd ~/Documents/_dev_work/hive_urban_github'
alias dev-geo-data='cd ~/Documents/_dev_work/hive_urban_github/geo-data'

# ------------------------------------------------------------ #
#                             NixOS                            #
# ------------------------------------------------------------ #
alias flake_rebuild='sudo nixos-rebuild switch --flake .'
alias flake_rebuild_trace='sudo nixos-rebuild switch --flake . --show-trace'
alias flake_up='sudo nix flake update'
alias flake_up_trace='sudo nix flake update --show-trace'
alias hm_switch='home-manager switch --flake .'
alias hm_switch_trace='home-manager switch --flake . --show-trace'
alias cg_empty='sudo nix-collect-garbage'
alias cg_empty_all='sudo nix-collect-garbage -d'


# ------------------------------------------------------------ #
#                     Terminal Multiplexer                     #
# ------------------------------------------------------------ #

# --------------------------- Tmux --------------------------- #
# Docs: https://github.com/tmux/tmux
# Reload tmux configuration from your dotfiles.
#
# Usage:
#   tmx_src
alias tmx-src='tmux source-file "$HOME/.config/tmux/tmux.conf"'

# Open or attach to a tmux session for a given directory key.
#
# Usage:
#   tmx [dir]
#
# Args:
#   dir: Optional. One of dot, dotvim, obsidian, kb, or a path. Defaults to ~/.
tmx() {
    local dir="${1:-~/}"
    local name dirpath

    case "$dir" in
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
        name="general"
        dirpath="$dir"
        ;;
    esac

    cd "$dirpath" || return

    if tmux list-sessions | grep -xq "$name"; then
        tmux attach-session -t "$name"
    else
        tmux new-session -s "$name"
    fi
}

# -------------------------- Zellij -------------------------- #
# Docs: https://zellij.dev/documentation/

# Launch zellij in ~/dotfiles
#
# Usage:
#   zj_dot
zj_dot() {
    cd "$HOME/dotfiles" && zellij
}
alias zj-dot='zj_dot'

# Launch zellij in ~/obsidian_vault
#
# Usage:
#   zj_obsidian
zj_obsidian() {
    cd "$HOME/obsidian_vault" && zellij
}
alias zj-obsidian='zj_obsidian'

# Open or attach to a zellij session for a given directory key.
#
# Usage:
#   zj [DIR]
#
# Args:
#   DIR: Optional. One of dot, dotvim, obsidian, kb, or a path; defaults to '~/'
zj() {
    local session="${1:-~/}"
    local name dirpath

    case "$session" in
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
        name="general"
        dirpath="$session"
        ;;
    esac

    cd "$dirpath" || return

    if zellij list-sessions | grep -xq "$name"; then
        zellij attach "$name"
    else
        zellij --session "$name"
    fi
}

# Open zellij with the welcome screen.
#
# Usage: zj-welcome
# No arguments.
alias zj-welcome='zellij -l welcome'

# ------------------------------------------------------------ #
#                    Tooling & Integrations                    #
# ------------------------------------------------------------ #

# --------------------------- Yazi --------------------------- #
# Launch Yazi, then cd into its last working directory
#
# Usage:
#   yz [ARGS...]
yz() {
    # create temp file for cwd tracking
    local tmp
    tmp="$(mktemp -t yazi-cwd.XXXXXX)"

    # launch Yazi with cwd-file
    yazi --cwd-file "$tmp" "$@"

    # if cwd changed, cd into it
    if [[ -s "$tmp" ]]; then
        local cwd
        cwd="$(<"$tmp")"
        if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
            cd "$cwd"
        fi
    fi

    rm -f "$tmp"
}

# ------------------------- Aerospace ------------------------ #
# Wrapper for aerospace commands: load, debug, monitor, app, window
#
# Usage:
#   as <command>
#
# Available commands:
#   load, debug, monitor, app, window
as() {
    case "$1" in
    load)
        aerospace reload-config
        ;;
    debug)
        aerospace debug-windows
        ;;
    monitor)
        aerospace list-monitors
        ;;
    app)
        aerospace list-apps
        ;;
    window)
        # fuzzy-select window to focus
        aerospace list-windows --all |
            fzf --bind 'enter:execute(aerospace focus --window-id {1})+abort' |
            xargs -r aerospace focus --window-id
        ;;
    *)
        cat <<-EOF
Usage: as <command>
Available commands: load, debug, monitor, app, window
EOF
        ;;
    esac
}

# ------------------------ Sketchybar ------------------------ #
alias bar_load='sketchybar --reload'
