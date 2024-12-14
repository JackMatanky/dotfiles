# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

# History settings
HISTFILESIZE=100000
HISTSIZE=10000

# Shell options
shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs

# --- Set $HOME if not already set ---
if [[ -z "$HOME" ]]; then
  export HOME="$(eval echo ~)"
fi

# --- Define variables for commonly used paths ---
export MY_HOME="$HOME"
export NIX_PROFILE="$MY_HOME/.nix-profile/bin"

# --- Import aliases from a separate file ---
source "$HOME/.dotfiles/cli/aliases.sh"

# --- Initialize tools ---
eval "$("$NIX_PROFILE/zoxide" init bash)"
export PYENV_ROOT="$MY_HOME/.local/share/pyenv"
eval "$("$NIX_PROFILE/pyenv" init -)"
source <("$NIX_PROFILE/carapace" _carapace bash)

# Starship prompt
eval "$(starship init bash)"

if [[ $TERM != "dumb" ]]; then
  eval "$("$NIX_PROFILE/starship" init bash --print-full-init)"
fi

# Bash Completion
if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/x2659ivhdgpgjymf1hcxxr7mz4h84rgi-bash-completion-2.13.0/etc/profile.d/bash_completion.sh"
fi

alias cg_empty='sudo nix-collect-garbage'
alias cg_empty_all='sudo nix-collect-garbage -d'
alias dot='cd ~/.dotfiles'
alias dot_nix='cd ~/.dotfiles/nixos'
alias flake_rebuild='sudo nixos-rebuild switch --flake .'
alias flake_rebuild_trace='sudo nixos-rebuild switch --flake . --show-trace'
alias flake_up='sudo nix flake update'
alias flake_up_trace='sudo nix flake update --show-trace'
alias gad='git add'
alias gad_d='git add .'
alias gad_p='git add -p'
alias gbr='git branch'
alias gbra='git branch -a'
alias gc='git commit -m'
alias gca='git commit -a -m'
alias gco='git checkout'
alias gcoall='git checkout -- .'
alias gdiff='git diff'
alias glog='git log --graph --topo-order --pretty='\''%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N'\'' --abbrev-commit'
alias gpl='git pull'
alias gpl_o='git pull origin'
alias gps='git push'
alias gps_o='git push origin'
alias grm='git remote'
alias grs='git reset'
alias gst='git status'
alias hm_switch='home-manager switch --flake .'
alias hm_switch_trace='home-manager switch --flake . --show-trace'
alias obsidian='cd ~/obsidian_vault'
alias obsidian_gpl='cd ~/obsidian_vault; git pull'
alias vimdiff='nvim -d'
