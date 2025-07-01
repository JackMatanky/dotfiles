# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/cli/cmd/stow_aliases.sh
# Description: Aliases for common GNU Stow commands
# -----------------------------------------------------------------------------

stow-all() {
    cd ~/dotfiles/ && stow .
}

unstow-all() {
    cd ~/dotfiles/ && stow -D .
}

restow-all() {
    cd ~/dotfiles/ && stow -R .
}

alias unstow='stow -D'
alias restow='stow -R'
