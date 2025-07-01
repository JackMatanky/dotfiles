# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/cli/aliases.sh
# Description: Aliases for common commands
# -----------------------------------------------------------------------------

# ------------------------------------------------------------ #
#                          Navigation                          #
# ------------------------------------------------------------ #
# cx: cd into a dir (arg or fzf with eza preview) and list with eza
cx() {
  local target="$1"
  if [ -z "$target" ]; then
    target="$(fd --type directory --hidden --exclude .git | fzf --preview 'eza --tree --level=2 --color=always {}')"
  fi
  [ -n "$target" ] && cd "$target" && eza -la --group-directories-first --icons
}

# f: Fuzzy search for a file with bat preview enabled and copy its path to clipboard
f() {
  local file
  file="$(fd --type file --hidden --exclude .git | fzf --preview 'bat --style=full --color=always {} || cat {}')"
  [ -n "$file" ] && printf %s "$file" | pbcopy
}

# rgf: Hybrid fd and ripgrep fuzzy file search
rgf() (
  RELOAD_RG='reload:rg --column --line-number --no-heading --color=always --smart-case {q} || :'
  INITIAL_FD='fd --type f --hidden --follow --exclude .git'

  eval "$INITIAL_FD" | fzf --ansi --multi --preview 'bat --style=full --color=always {} || cat {}' \
    --bind "change:$RELOAD_RG" \
    --delimiter : \
    --preview-window 'right:60%' \
    --query "$*"
)

# ------------------------------------------------------------ #
#                        Shell Commands                        #
# ------------------------------------------------------------ #
alias c='clear'
alias l='ls -l'

# ------------------------- Justfile ------------------------- #
alias j='just'

# ---------------------------- Eza --------------------------- #
# Detailed File List
alias ll='eza --long --icons --git --all --group-directories-first'
# Tree Views
alias lt='eza --tree --level=2 --icons --git' # 2 levels
alias ltree='eza --tree --level=2 --icons --git' # 3 levels

# -------------------------- Zoxide -------------------------- #
# Docs: https://github.com/ajeetdsouza/zoxide
alias za='zoxide add'
alias zq='zoxide query'


# ------------------------------------------------------------ #
#                          Directories                         #
# ------------------------------------------------------------ #
alias conf-dir='cd ~/.config'
alias docs='cd ~/Documents'

# ------------------------- Dotfiles ------------------------- #
alias dot='cd ~/dotfiles'
alias dot-nix='cd ~/dotfiles/nixos'

# ---------------------- Obsidian Vault ---------------------- #
alias obsidian='cd ~/obsidian_vault'
obsidian-gpl() {
  cd ~/obsidian_vault && git pull
}

# ----------------------- Keyboard Dev ----------------------- #
alias kb-dev='cd ~/Documents/keyboard_dev'
alias kb-ergogen='cd ~/Documents/keyboard_dev/ergogen'
alias kb-zmk='cd ~/Documents/keyboard_dev/zmk-config'
alias kb-snak_dir='cd ~/Documents/keyboard_dev/kb_snak'

# --------------------------- Work --------------------------- #
alias dev-work='cd ~/Documents/_dev_work'
alias dev-hive='cd ~/Documents/_dev_work/hive_urban_github'
alias dev-geo-data='cd ~/Documents/_dev_work/hive_urban_github/geo-data'


# ------------------------------------------------------------ #
#                             NixOS                            #
# ------------------------------------------------------------ #
alias flake_rebuild='sudo nixos-rebuild switch --flake .'
alias flake_rebuild_trace='sudo nixos-rebuild switch --flake . --show-trace'
alias flake_up='sudo nix flake update'
alias flake_up_trace='sudo nix flake update --show-trace'
alias hm_switch='home-manager switch --flake .'
alias hm_switch_trace='home-manager switch --flake . --show-trace'
alias cg_empty='sudo nix-collect-garbage'
alias cg_empty_all='sudo nix-collect-garbage -d'


# ------------------------------------------------------------ #
#                            NeoVim                            #
# ------------------------------------------------------------ #
alias v='nvim'
alias vdiff='nvim -d'

# ffv: Fuzzy search for a file with bat preview enabled and open it in Neovim
ffv() {
  local file
  file="$(fd --type file --hidden --exclude .git | fzf --preview 'bat --style=full --color=always {} || cat {}')"
  [ -n "$file" ] && nvim "$file"
}

# fdv: Fuzzy search for a directory with eza preview and open it in Neovim
fdv() {
  local dir
  dir="$(fd --type directory --hidden --exclude .git | fzf --preview 'eza --tree --level=2 --color=always {}')"
  [ -n "$dir" ] && nvim "$dir"
}

# ------------------------------------------------------------ #
#                     Terminal Multiplexer                     #
# ------------------------------------------------------------ #

# --------------------------- Tmux --------------------------- #
alias tmx_src='tmux source ~/.tmux.conf'

# -------------------------- Zellij -------------------------- #
# Docs: https://zellij.dev/documentation/
# Run Zellij in a particular directory
zj_dot() {
  cd ~/dotfiles && zellij
}

zj_obsidian() {
  cd ~/obsidian_vault && zellij
}

zj() {
  local session="$1"
  local name=""
  local dir=""

  case "$session" in
    dot)      name="dotfiles"; dir=~/dotfiles ;;
    dotvim)   name="neovim_config"; dir=~/dotfiles/nvim ;;
    obsidian) name="obsidian_vault"; dir=~/obsidian_vault ;;
    kb)       name="keyboard_dev"; dir=~/Documents/keyboard_dev ;;
    *)        name="general"; dir="${session:-~}" ;;
  esac

  cd "$dir"
  if zellij list-sessions | grep -q "$name"; then
    zellij attach "$name"
  else
    zellij --session "$name"
  fi
}

alias zj_welcome='zellij -l welcome'

# ------------------------------------------------------------ #
#                    Tooling & Integrations                    #
# ------------------------------------------------------------ #

# --------------------------- Yazi --------------------------- #
# yz: Launch Yazi and cd into its last path
yz() {
  local tmp
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"

  yazi --cwd-file "$tmp" "$@"

  if [[ -s "$tmp" ]]; then
    local cwd
    cwd="$(<"$tmp")"
    if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
      cd "$cwd"
    fi
  fi

  rm -f "$tmp"
}


# ------------------------- Aerospace ------------------------ #
as() {
  case "$1" in
    load) aerospace reload-config ;;
    debug) aerospace debug-windows ;;
    monitor) aerospace list-monitors ;;
    app) aerospace list-apps ;;
    window)
      aerospace list-windows --all \
        | fzf --bind 'enter:execute(aerospace focus --window-id {1})+abort' \
        | xargs -r aerospace focus --window-id
      ;;
    *)
      echo "Usage: as <command>"
      echo "Available: load, debug, monitor, app, window"
      ;;
  esac
}


# ------------------------ Sketchybar ------------------------ #
alias bar_load='sketchybar --reload'
