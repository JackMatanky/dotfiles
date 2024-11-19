# -----------------------------------------------
# Custom Aliases for Shell and Git Configurations
# -----------------------------------------------

# Navigation Aliases
alias dot="cd .dotfiles"
alias obsidian="cd /run/media/jack/sdxc_512/obsidian_vault"

# NixOS and Home Manager Aliases
alias flake_rebuild="sudo nixos-rebuild switch --flake ."   # Rebuild the NixOS system using the current flake.
alias flake_up="sudo nix flake update"                      # Update all inputs in the Nix flake.
alias hm_switch="home-manager switch --flake ."             # Apply the Home Manager configuration changes.

# File System Commands
alias l="ls --all"              # List all files, including hidden ones.
alias ll="ls -l"                # List files in a long format with detailed information.
alias clear="clearscreen"       # Clear the terminal screen (Nushell-specific).

# Editor and Development Commands
alias code="code ."             # Open the current directory in Visual Studio Code.
alias z="zed"                   # Open the Zed Editor.

# ---------------------------------------
# Git Aliases for Improved Productivity
# ---------------------------------------

# Git Commit Aliases
alias gcm="git commit -m"           # Commit with a message directly.
alias gcam="git commit -a -m"       # Stage all changes and commit with a message.

# Git Push and Pull Aliases
alias gps="git push"                # Push changes from the current branch to the default remote.
alias gpso="git push origin HEAD"   # Push changes from the current branch to the `origin` remote.
alias gpl="git pull"                # Pull changes from the default remote.
alias gplo="git pull origin"        # Pull changes explicitly from the `origin` remote.

# Git Status and Diff Aliases
alias gst="git status"              # Show the current status of the Git repository.
alias gdiff="git diff"              # Show differences between working directory and index.

# Git Branch and Checkout Aliases
alias gco="git checkout"            # Switch to another branch or restore files.
alias gb="git branch"               # List all branches in the current repository.
