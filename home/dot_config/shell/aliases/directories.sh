#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/cmd/directory_shortcuts.sh
# Dependencies: None
# Description: Directory navigation shortcuts and project-specific aliases
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    set -euo pipefail
    IFS=$'\n\t'
fi

# ------------------------------------------------------------ #
#                      System Directories                     #
# ------------------------------------------------------------ #
alias conf-dir='cd ~/.config'
alias docs='cd ~/Documents'

# ------------------------------------------------------------ #
#                         Dotfiles                            #
# ------------------------------------------------------------ #
alias dot='cd ~/dotfiles'
alias dot-nix='cd ~/.config/nixos'

# ------------------------------------------------------------ #
#                      Obsidian Vault                         #
# ------------------------------------------------------------ #
alias obsidian='cd ~/obsidian_vault'

# Pull latest changes in obsidian vault
obsidian_gpl() {
    cd ~/obsidian_vault && git pull
}
alias obsidian-gpl='obsidian_gpl'

# ------------------------------------------------------------ #
#                       Keyboard Dev                          #
# ------------------------------------------------------------ #
alias kb-dev='cd ~/Documents/keyboard_dev'
alias kb-ergogen='cd ~/Documents/keyboard_dev/ergogen'
alias kb-zmk='cd ~/Documents/keyboard_dev/zmk-config'
alias kb-snak_dir='cd ~/Documents/keyboard_dev/kb_snak'

# ------------------------------------------------------------ #
#                           Work                              #
# ------------------------------------------------------------ #
alias dev-work='cd ~/Documents/_dev_work'
alias dev-hive='cd ~/Documents/_dev_work/hive_urban_github'
alias dev-geo-data='cd ~/Documents/_dev_work/hive_urban_github/geo-data'
