# ~/.bashrc
# Bash Configuration Aligned with Home Manager and Nushell

# Enable command-line completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Load shell aliases from Home Manager
if [ -f ~/.config/aliases.sh ]; then
    source ~/.config/aliases.sh
fi

# Set terminal emulator
# export TERMINAL="/path/to/alacritty"

# Configure history
export HISTSIZE=10000                 # Maximum number of commands to remember
export HISTFILESIZE=100000            # Maximum number of commands stored in history file
export HISTCONTROL=ignoredups:erasedups # Avoid duplicates
shopt -s histappend                   # Append to history file, don't overwrite it

# Prompt customization
PS1='\[\e[0;32m\]\u@\h \[\e[0;34m\]\w\[\e[0m\] $ '

# Enable vi-style keybindings (optional)
set -o vi

# Add custom paths (aligning with Nushell PATH setup)
export PATH="$HOME/.local/bin:$PATH"
export PATH="/nix/var/nix/profiles/default/bin:$PATH"
export PATH="/run/current-system/sw/bin:$PATH"

# Zoxide initialization (if installed)
eval "$(zoxide init bash)"

# Starship prompt initialization
eval "$(starship init bash)"
