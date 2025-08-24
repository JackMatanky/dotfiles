#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/shell/utils/git.sh
# Dependencies: git, fzf
# Description: Private git helper functions (prefixed with __)
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    # Fail on errors, unset variables, and pipeline errors.
    set -euo pipefail
    # Set IFS to newline and tab to ensure safe word splitting.
    IFS=$'\n\t'
fi

#######################################
# Return the name of the current Git branch.
# Arguments:
#   None
# Outputs:
#   Writes the branch name (e.g., "main") to stdout.
# Returns:
#   0 on success; non-zero if not in a Git repo.
#######################################
__git_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

#######################################
# Return the default branch of the 'origin' remote.
# Arguments:
#   None
# Outputs:
#   Writes the default branch (e.g., "main" or "master") to stdout.
# Returns:
#   0 on success; non-zero on error (e.g., missing 'origin').
#######################################
__git_main_branch() {
    git remote show origin |
        grep -E 'HEAD.*: ' |
        sed -E 's/.*HEAD.*: (.*)/\1/'
}

#######################################
# List all local and remote branches (short names), deduplicated.
# Arguments:
#   None
# Outputs:
#   Newline-separated branch names to stdout.
# Returns:
#   0 on success; non-zero on error.
#######################################
__git_list_branches() {
    git branch --all --format="%(refname:short)" |
        sed 's#^remotes/##' |
        sort -u
}

#######################################
# Prompt to select or enter a branch name using fzf. Falls back to printing
# the list if fzf is unavailable.
# Arguments:
#   None
# Outputs:
#   Writes the selected or entered branch name to stdout.
# Returns:
#   0 on success; non-zero on error.
#######################################
__git_select_branch() {
    local branches selection
    branches=$(__git_list_branches)

    if command -v fzf >/dev/null 2>&1; then
        selection="$(
            printf '%s\n' "$branches" |
                fzf --prompt='Branch> ' --print-query)"
        printf '%s' "$selection" | tail -n1
    else
        # No fzf; just print the list (caller may read/pipe as needed).
        printf '%s\n' "$branches"
    fi
}

#######################################
# Switch to an existing branch or create it if it does not exist.
# Arguments:
#   $1: Branch name.
# Returns:
#   0 on success; non-zero on error or if name is missing.
#######################################
__git_switch_or_create_branch() {
    local branch="${1:-}"
    if [ -z "$branch" ]; then
        echo "git_switch_or_create_branch: missing branch name" >&2
        return 1
    fi
    if git show-ref --verify --quiet "refs/heads/$branch"; then
        git switch "$branch"
    else
        git switch -c "$branch"
    fi
}

#######################################
# Ensure a commit message is provided (quotes required).
# Arguments:
#   $1: Command name for usage output (e.g., "gcm", "gcam").
#   $2: Commit message (must be quoted).
# Outputs:
#   Writes the commit message to stdout on success.
#   Writes usage to stderr on failure.
# Returns:
#   0 if a message is provided; 1 otherwise.
#######################################
__git_require_message() {
    local cmd="${1:-cmd}"
    local msg="${2:-}"
    [ -z "$msg" ] && { printf 'Usage: %s "<message>"\n' "$cmd" >&2; return 1; }
    printf '%s\n' "$msg"
}
