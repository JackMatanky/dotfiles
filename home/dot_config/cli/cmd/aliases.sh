# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/cli/aliases.sh
# Ported from: ~/dotfiles/nushell/aliases.nu
# -----------------------------------------------------------------------------

# >>> Navigation <<<
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

# >>> Shell Commands <<<
alias c='clear'
alias ll='ls -l'

# >>> eza <<<
alias l='eza --long --icons --git --all --group-directories-first'
alias lt='eza --tree --level=2 --long --icons --git'
alias ltree='eza --tree --level=2 --icons --git'

# >>> zoxide <<<
alias za='zoxide add'
alias zq='zoxide query'

# >>> Directories <<<
alias conf_dir='cd ~/.config'
alias docs='cd ~/Documents'

# --- Dotfiles ---
alias dot='cd ~/dotfiles'
alias dot_nix='cd ~/dotfiles/nixos'

# --- Obsidian Vault ---
alias obsidian='cd ~/obsidian_vault'
obsidian_gpl() {
  cd ~/obsidian_vault && git pull
}

# --- Keyboard Dev ---
alias kb_dev='cd ~/Documents/keyboard_dev'
alias kb_ergogen='cd ~/Documents/keyboard_dev/ergogen'
alias kb_zmk='cd ~/Documents/keyboard_dev/zmk-config'
alias kb_snak_dir='cd ~/Documents/keyboard_dev/kb_snak'

# --- Work ---
alias dev_work='cd ~/Documents/_dev_work'
alias dev_hive='cd ~/Documents/_dev_work/hive_urban_github'

# --- Git ---
# Note: git_current_branch helper
git_current_branch() {
  git rev-parse --abbrev-ref HEAD
}

git_main_branch() {
  git remote show origin \
    | grep -E 'HEAD.*: ' \
    | sed -E 's/.*HEAD.*: (.*)/\1/'
}

# Add
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'

# Commit
alias gc='git commit --message'
gcmsg() { git commit --message "$1"; }
gcam() { git commit --all --message "$1"; }

# Push
alias gps='git push'
alias gpso='git push origin'
alias gpsod='git push origin --delete'
gpsodc() { git push origin --delete "$(git_current_branch)"; }
gpsup() { git push --set-upstream origin "$(git_current_branch)"; }

# Pull
alias gpl='git pull'
alias gplo='git pull origin'
gplup() { git pull upstream "$(git_main_branch)"; }

# Fetch
alias gf='git fetch'
alias gfo='git fetch origin'

# Branch
alias gb='git branch'
alias gbra='git branch --all'
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'

# Checkout
alias gco='git checkout'
alias gcom='git checkout $(git_main_branch)'
alias gcob='git checkout -b'
alias gcoa='git checkout -- .'

# Remote
alias gr='git remote'
alias gra='git remote add'
alias grset='git remote set-url'

# Reset
alias grs='git reset'
alias grsh='git reset --hard'

# Diff
alias gdiff='git diff'

# Status
alias gst='git status'

# Log
alias gl='git log'
alias glog='git log --graph --topo-order --pretty="%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N" --abbrev-commit'

# Config
alias gconf='git config --list'

# Remove DS_Store
grmds() {
  git rm --cached '*.DS_Store'
  git commit --all --message 'Remove .DS_Store files'
}

# --- GNU Stow ---
stow_all() {
  cd ~/dotfiles/ && stow .
}

unstow_all() {
  cd ~/dotfiles/ && stow -D .
}

restow_all() {
  cd ~/dotfiles/ && stow -R .
}

alias unstow='stow -D'
alias restow='stow -R'

# --- Nix ---
alias flake_rebuild='sudo nixos-rebuild switch --flake .'
alias flake_rebuild_trace='sudo nixos-rebuild switch --flake . --show-trace'
alias flake_up='sudo nix flake update'
alias flake_up_trace='sudo nix flake update --show-trace'
alias hm_switch='home-manager switch --flake .'
alias hm_switch_trace='home-manager switch --flake . --show-trace'
alias cg_empty='sudo nix-collect-garbage'
alias cg_empty_all='sudo nix-collect-garbage -d'

# --- Vim ---
alias v='nvim'
alias vdiff='nvim -d'

# --- Tmux ---
alias tmx_src='tmux source ~/.tmux.conf'

# --- Zellij ---
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

# --- Yazi ---
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

# yz() {
#     local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
#     yazi "$@" --cwd-file="$tmp"
#     if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
#         builtin cd -- "$cwd"
#     fi
#     rm -f -- "$tmp"
# }

# --- Aerospace Window Tiling Manager ---
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

# as() {
#     case "$1" in
#         "load") aerospace reload-config ;;
#         "debug") aerospace debug-windows ;;
#         "monitor") aerospace list-monitors ;;
#         "app") aerospace list-apps ;;
#         "window")
#             local selection
#             selection=$(aerospace list-windows --all | fzf --bind 'enter:execute(aerospace focus --window-id {})+abort' | tr -d '\n')
#             ;;
#         *) echo "Usage: as <command> (load, debug, monitor, app, window)" ;;
#     esac
# }

# --- Sketchybar ---
alias bar_load='sketchybar --reload'

# --- Justfile ---
alias j='just'

# --- OCRmyPDF ---

# ocrfile: OCR a single PDF (arg or fzf)
ocrfile() {
  local input="$1"
  if [ -z "$input" ]; then
    input="$(fd --type file --extension pdf | fzf)"
    [ -z "$input" ] && echo "No file selected." && return 1
  fi

  local abs_path output
  abs_path="$(realpath "$input")"
  output="${abs_path%.pdf}_ocr.pdf"

  ocrmypdf --rotate-pages --deskew --output-type pdf "$abs_path" "$output"
}

# ocrfolder: OCR all PDFs in a folder (arg or fzf)
ocrfolder() {
  local folder="$1"
  if [ -z "$folder" ]; then
    folder="$(fd --type directory | fzf)"
    [ -z "$folder" ] && echo "No folder selected." && return 1
  fi

  local abs_path pdf output
  abs_path="$(realpath "$folder")"

  while IFS= read -r pdf; do
    local abs_pdf output
    abs_pdf="$(realpath "$pdf")"
    output="${abs_pdf%.pdf}_ocr.pdf"

    if [ -f "$output" ]; then
      echo "⚠️ Skipping (exists): $output"
      continue
    fi

    echo "OCR'ing: $abs_pdf"
    ocrmypdf --rotate-pages --deskew --output-type pdf "$abs_pdf" "$output"
  done < <(fd --type file --extension pdf "$abs_path")

  echo "✅ Batch OCR complete."
}
