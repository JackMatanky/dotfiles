#!/usr/bin/env bash
# Filename: ~/.config/shell/aliases/system.sh
# Description: System-specific aliases for package management and system tools
# Docs: https://github.com/NixOS/nix

# ============================================================================ #
# System and Package Management
# ============================================================================ #

# NixOS system management
alias flake_rebuild='sudo nixos-rebuild switch --flake .'
alias flake_rebuild_trace='sudo nixos-rebuild switch --flake . --show-trace'
alias flake_up='sudo nix flake update'
alias flake_up_trace='sudo nix flake update --show-trace'

# Home Manager
alias hm_switch='home-manager switch --flake .'
alias hm_switch_trace='home-manager switch --flake . --show-trace'

# Nix garbage collection
alias cg_empty='sudo nix-collect-garbage'
alias cg_empty_all='sudo nix-collect-garbage -d'

# macOS system tools
alias bar_load='sketchybar --reload'
