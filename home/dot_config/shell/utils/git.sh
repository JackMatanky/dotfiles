#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/shell/utils/git.sh
# Dependencies: git, fzf
# Description: Private git helper functions (prefixed with __)
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    set -euo pipefail
    IFS=$'\n\t'
fi

# ------------------------------------------------------------ #
#                      Git Helper Functions                   #
# ------------------------------------------------------------ #

#######################################
# __git_current_branch: Return the name of the current Git branch.
#
# Usage:
#   __git_current_branch
# Output:
#   e.g. "main"
#######################################
__git_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

#######################################
# __git_main_branch: Return the default branch of the 'origin' remote.
#
# Usage:
#   __git_main_branch
# Output:
#   e.g. "main" or "master"
#######################################
__git_main_branch() {
    git remote show origin |
        grep -E 'HEAD.*: ' |
        sed -E 's/.*HEAD.*: (.*)/\1/'
}

#######################################
# __git_list_branches: List all local and remote branches (short names), deduplicated.
#
# Usage:
#   __git_list_branches
# Output:
#   Newline-separated branch names.
#######################################
__git_list_branches() {
    git branch --all --format="%(refname:short)" |
        sed 's#^remotes/##' |
        sort -u
}

#######################################
# __git_select_branch: Prompt to select or enter a branch name using fzf.
#
# Usage:
#   __git_select_branch
# Output:
#   Selected or entered branch name.
#######################################
__git_select_branch() {
    local branches selection
    branches=$(__git_list_branches)
    selection=$(
        printf '%s
        ' "$branches" |
            fzf --prompt="Branch> " --print-query
    )
    printf '%s' "$selection" | tail -n1
}

#######################################
# __git_switch_or_create_branch: Switch to an existing branch or create it if it does not exist.
#
# Usage:
#   __git_switch_or_create_branch <branch>
#
# Args:
#   branch: Name of the branch to switch to or create.
#######################################
__git_switch_or_create_branch() {
    local branch="$1"
    if git show-ref --verify --quiet "refs/heads/$branch"; then
        git switch "$branch"
    else
        git switch -c "$branch"
    fi
}
