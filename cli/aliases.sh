# Directory Navigation
alias dot='cd .dotfiles'
alias dot_nix='cd ~/.dotfiles/nixos'
alias obsidian='cd /run/media/jack/sdxc_512/obsidian_vault'

# Nix - Flakes
alias flk_rebuild='sudo nixos-rebuild switch --flake .'
alias flk_rebuild_trace='sudo nixos-rebuild switch --flake . --show-trace'
alias flk_up='sudo nix flake update'
alias flk_up_trace='sudo nix flake update --show-trace'

# Nix - Home Manager
alias hm_switch='home-manager switch --flake .'
alias hm_switch_trace='home-manager switch --flake . --show-trace'

# Nix - Garbage Collector
alias cg_empty='sudo nix-collect-garbage -d'

# Git
alias gad='git add'
alias gad_d='git add .'
alias gad_p='git add -p'
alias gc='git commit -m'
alias gca='git commit -a -m'
alias gpl='git pull'
alias gpl_o='git pull origin'
alias gps='git push'
alias gps_o='git push origin'
alias gbr='git branch'
alias gbra='git branch -a'
alias gco='git checkout'
alias gcoall='git checkout -- .'
alias grm='git remote'
alias grs='git reset'
alias gst='git status'
alias gdiff='git diff'
alias glog='git log --graph --topo-order --pretty='\''%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N'\'' --abbrev-commit'
