#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/cli/cmd/git_aliases.sh
# Dependencies: git, lazygit
# Description: Aliases and functions for common git operations
# -----------------------------------------------------------------------------

# Fail on errors, unset variables, and pipeline errors.
set -euo pipefail

# Set IFS to newline and tab to ensure safe word splitting.
IFS=$'\n\t'

# ------------------------------------------------------------ #
#                            Lazygit                           #
# ------------------------------------------------------------ #
# Launch lazygit TUI for Git operations.
alias lg='lazygit'

# ------------------------------------------------------------ #
#                              Git                             #
# ------------------------------------------------------------ #

# ---------------------- Branch Helpers ---------------------- #

# Return the name of the current Git branch.
#
# Usage:
#   git_current_branch
# Output:
#   e.g. "main"
git_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

# Return the default branch of the 'origin' remote.
#
# Usage:
#   git_main_branch
# Output:
#   e.g. "main" or "master"
git_main_branch() {
    git remote show origin |
        grep -E 'HEAD.*: ' |
        sed -E 's/.*HEAD.*: (.*)/\1/'
}

# List all local and remote branches (short names), deduplicated.
#
# Usage:
#   git_list_branches
# Output:
#   Newline-separated branch names.
git_list_branches() {
    git branch --all --format="%(refname:short)" |
        sed 's#^remotes/##' |
        sort -u
}

# Prompt to select or enter a branch name using fzf.
#
# Usage:
#   git_select_branch
# Output:
#   Selected or entered branch name.
git_select_branch() {
    local branches selection
    branches=$(git_list_branches)
    selection=$(
        printf '%s
        ' "$branches" |
            fzf --prompt="Branch> " --print-query
    )
    printf '%s' "$selection" | tail -n1
}

# Switch to an existing branch or create it if it does not exist.
#
# Usage:
#   git_switch_or_create_branch <branch>
#
# Args:
#   branch: Name of the branch to switch to or create.
git_switch_or_create_branch() {
    local branch="$1"
    if git show-ref --verify --quiet "refs/heads/$branch"; then
        git switch "$branch"
    else
        git switch -c "$branch"
    fi
}

# ---------------------------- Add --------------------------- #
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'

# -------------------------- Commit -------------------------- #
alias gc='git commit --message'

# Commit with a message.
#
# Usage:
#   gcm "Your commit message"
gcm() {
    local msg="${1:-}"
    # Ensure a commit message was provided
    if [ -z "$msg" ]; then
        echo "Usage: gcm <message>" >&2
        return 1
    fi
    git commit --message "$msg"
}

# Commit all staged and unstaged changes with a message.
#
# Usage:
#   gcam "Your commit message"
gcam() {
    local msg="${1:-}"
    # Ensure a commit message was provided
    if [ -z "$msg" ]; then
        echo "Usage: gcam <message>" >&2
        return 1
    fi
    git commit --all --message "$msg"
}

# --------------------------- Push --------------------------- #
alias gps='git push'
alias gpso='git push origin'
alias gpsod='git push origin --delete'

# Delete remote branch for current branch.
#
# Usage:
#   gpsodc
gpsodc() {
    git push origin --delete "$(git_current_branch)"
}

# Push current branch and set upstream to origin.
#
# Usage:
#   gpsup
gpsup() {
    git push --set-upstream origin "$(git_current_branch)"
}

# --------------------------- Pull --------------------------- #
alias gpl='git pull'
alias gplo='git pull origin'

# Pull from upstream remote default branch.
#
# Usage:
#   gplup
gplup() {
    git pull upstream "$(git_main_branch)"
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
alias gcom='git checkout $(git_main_branch)'
alias gcob='git checkout -b'
alias gcoa='git checkout -- .'

# -------------------------- Switch -------------------------- #
alias gsw='git switch'
alias gswc='git switch --create'

# ------------- Interactive Branch Switch/Create ------------- #

# Prompt the user to select or enter a branch name using fzf, then switch
# to the selected branch or create it if it does not exist.
#
# Usage:
#   gbs
#
# Output:
#   Switches to the selected branch or creates it if it doesn't exist.
#   Displays an error message if no branch is selected or entered.
gbs() {
    local branch
    branch=$(git_select_branch)
    if [ -z "$branch" ]; then
        echo "No branch selected or entered." >&2
        return 1
    fi
    git_switch_or_create_branch "$branch"
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

# Remove cached .DS_Store files and commit the removal.
#
# Usage:
#   grmds
grmds() {
    git rm --cached '*.DS_Store'
    git commit --all --message 'Remove .DS_Store files'
}
