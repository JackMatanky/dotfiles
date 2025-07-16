#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/cli/lib/nav_helpers.sh
# Dependencies: fd, fzf, bat, eza
# Description: Helper functions for fuzzy file/directory selection and navigation.
#              These are prefixed with `__` and are not meant for direct use.
# -----------------------------------------------------------------------------

# Select one or more files using fd + fzf + bat preview.
#
# Globals:
#   None
# Arguments:
#   Any fd-compatible paths or filters.
# Outputs:
#   Writes selected file paths to stdout.
# Returns:
#   0 if one or more files selected, non-zero otherwise.
__fzf_pick_file() {
  fd --type f --hidden --follow --exclude .git "$@" |
    fzf --multi --prompt="Select file(s): " \
        --preview 'bat --style=full --color=always {} || cat {}'
}

# Select a directory using fd + fzf + eza tree preview.
#
# Globals:
#   None
# Arguments:
#   Any fd-compatible paths or filters.
# Outputs:
#   Writes selected directory path to stdout.
# Returns:
#   0 if a directory is selected, non-zero otherwise.
__fzf_pick_dir() {
  fd --type d --hidden --exclude .git "$@" |
    fzf --prompt="Select directory: " \
        --preview 'eza --tree --level=2 --color=always {} || ls {}'
}

# Change directory and run a specified command.
#
# Globals:
#   None
# Arguments:
#   $1 - Target directory
#   $@ - Command and its arguments (shifted)
# Outputs:
#   Executes command in the target directory.
# Returns:
#   Exit status of the executed command, or 1 on cd failure.
__cd_and_run() {
  local target_dir="$1"
  shift || true
  cd "${target_dir}" || return 1
  "$@"
}
