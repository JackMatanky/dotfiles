#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/shell/aliases/git.sh
# Dependencies: git, lazygit, fd, fzf
# Description: Git aliases and functions for common git operations
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    # Fail on errors, unset variables, and pipeline errors.
    set -euo pipefail

    # Set IFS to newline and tab to ensure safe word splitting.
    IFS=$'\n\t'
fi

# ------------------------------------------------------------ #
#                            Lazygit                           #
# ------------------------------------------------------------ #
# Launch lazygit TUI for Git operations.
alias lg='lazygit'

# ------------------------------------------------------------ #
#                              Git                             #
# ------------------------------------------------------------ #

# ---------------------------- Add --------------------------- #
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'

# -------------------------- Commit -------------------------- #
# Allow direct use as: gc "message"
alias gc='git commit --message'

#######################################
# Commit with a message (quoted).
# Arguments:
#   $1: Commit message (quoted).
# Returns:
#   0 on success; non-zero on error.
#######################################
gcm() {
    local msg
    msg="$(__git_require_message gcm "$1")" || return 1
    git commit --message "$msg"
}

#######################################
# Commit all staged and unstaged changes with a message (quoted).
# Arguments:
#   $1: Commit message (quoted).
# Returns:
#   0 on success; non-zero on error.
#######################################
gcam() {
    local msg
    msg="$(__git_require_message gcam "$1")" || return 1
    git commit --all --message "$msg"
}

# --------------------------- Push --------------------------- #
alias gps='git push'
alias gpso='git push origin'
alias gpsod='git push origin --delete'

#######################################
# Delete remote branch corresponding to the current local branch.
# Arguments:
#   None
# Returns:
#   0 on success; non-zero on error.
#######################################
gpsodc() {
    git push origin --delete "$(__git_current_branch)"
}

#######################################
# Push current branch and set upstream to origin.
# Arguments:
#   None
# Returns:
#   0 on success; non-zero on error.
#######################################
gpsup() {
    git push --set-upstream origin "$(__git_current_branch)"
}

# --------------------------- Pull --------------------------- #
alias gpl='git pull'
alias gplo='git pull origin'

#######################################
# Pull from 'upstream' remote's default branch.
# Arguments:
#   None
# Returns:
#   0 on success; non-zero on error.
#######################################
gplup() {
    git pull upstream "$(__git_main_branch)"
}

# --------------------------- Fetch -------------------------- #
alias gf='git fetch'
alias gfo='git fetch origin'

# -------------------------- Branch -------------------------- #
alias gb='git branch'
alias gbra='git branch --all'
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'

# ------------------------- Checkout ------------------------- #
alias gco='git checkout'
alias gcom='git checkout $(__git_main_branch)'
alias gcob='git checkout -b'
alias gcoa='git checkout -- .'

# -------------------------- Switch -------------------------- #
alias gsw='git switch'
alias gswc='git switch --create'

# ------------- Interactive Branch Switch/Create ------------- #

#######################################
# Select or enter a branch using fzf, then switch to the selected branch or
# create it if it does not exist.
# Arguments:
#   None
# Output:
#   Switches to the selected branch or creates it if it doesn't exist.
#   Displays an error message if no branch is selected or entered.
# Returns:
#   0 on success; non-zero if no selection or on Git errors.
#######################################
gbs() {
    local branch
    branch=$(__git_select_branch)
    if [ -z "$branch" ]; then
        echo "No branch selected or entered." >&2
        return 1
    fi
    __git_switch_or_create_branch "$branch"
}

# -------------------------- Remote -------------------------- #
alias gr='git remote'
alias gra='git remote add'
alias grset='git remote set-url'

# --------------------------- Reset -------------------------- #
alias grs='git reset'
alias grsh='git reset --hard'

# --------------------------- Diff --------------------------- #
alias gdiff='git diff'

# -------------------------- Status -------------------------- #
alias gst='git status'

# ---------------------------- Log --------------------------- #
alias gl='git log'
alias glog='git log --graph --topo-order \
    --pretty="%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n\
%C(bold)%C(white)%s %N" \
    --abbrev-commit'

# -------------------------- Config -------------------------- #
alias gconf='git config --list'

# --------------------- Remove .DS_Store --------------------- #

#######################################
# Remove cached .DS_Store files and commit the removal.
# Arguments:
#   None
# Returns:
#   0 on success; non-zero on error.
#######################################
grmds() {
    git rm --cached '*.DS_Store'
    git commit --all --message 'Remove .DS_Store files'
}
