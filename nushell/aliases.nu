# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/nushell/aliases.nu
# -----------------------------------------------------------------------------

def --env cx [arg] {
    cd $arg
    ls -l
}

# >>> Shell Commands <<<
alias c = clear
alias ll = ls -l

# >>> eza <<<
alias l = eza --long --icons --git --all --group-directories-first # Detailed File List
alias lt = eza --tree --level=2 --long --icons --git # Tree View - Full
alias ltree = eza --tree --level=2 --icons --git # Tree View - Compact

# >>> zoxide <<<
alias za = zoxide add
alias zq = zoxide query

# >>> Directories <<<
alias conf_dir = cd ~/.config
alias docs = cd ~/Documents

# --- Dotfiles ---
alias dot = cd ~/dotfiles
alias dot_nix = cd ~/dotfiles/nixos

# --- Obsidian Vault ---
alias obsidian = cd ~/obsidian_vault
def obsidian_gpl [] {
  cd ~/obsidian_vault
  git pull
}

# --- Keyboard Dev ---
alias kb_dev = cd ~/Documents/keyboard_dev
alias kb_ergogen = cd ~/Documents/keyboard_dev/ergogen
alias kb_zmk = cd ~/Documents/keyboard_dev/zmk-config
alias kb_snak_dir = cd ~/Documents/keyboard_dev/kb_snak

# --- Git ---
# Source: https://github.com/nushell/nu_scripts/blob/main/aliases/git/git-aliases.nu
def git_current_branch [] {
    (gstat).branch
}

def git_main_branch [] {
    git remote show origin
        | lines
        | str trim
        | find --regex 'HEAD .*?[：: ].+'
        | first
        | str replace --regex 'HEAD .*?[：: ]\s*(.+)' '$1'
}

# Add
alias ga = git add
alias gaa = git add --all
alias gapa = git add --patch
alias gau = git add --update

# Commit
alias gc = git commit -m
alias gcam = git commit --all --message

# Push
alias gps = git push
alias gpsog = git push origin

# Pull
alias gpl = git pull
alias gplog = git pull origin

# Fetch
alias gf = git fetch
alias gfo = git fetch origin

# Branch
alias gb = git branch
alias gbra = git branch --all
alias gbd = git branch --delete
alias gbD = git branch --delete --force

# Checkout
alias gco = git checkout
alias gcm = git checkout (git_main_branch)
alias gcb = git checkout -b
alias gcoa = git checkout -- .

# Remote
alias gr = git remote
alias gra = git remote add
alias grset = git remote set-url

# Reset
alias grs = git reset
alias grsh = git reset --hard

# Diff
alias gdiff = git diff

# Status
alias gst = git status

# Log
alias gl = git log
alias glog = git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit
# alias glogtb = git log --pretty=%h»¦«%aN»¦«%s»¦«%aD | lines | split column "»¦«" sha1 committer desc merged_at | first 20

# Config
alias gcf = git config --list

# Remove DS_Store
def grmds [] {
    git rm --cached '*.DS_Store'
    git commit --all --message 'Remove .DS_Store files'
}

# --- GNU Stow ---
alias unstow = stow -D
alias unstow_all = stow -D .
alias restow = stow -R
alias restow_all = stow -R .

# --- Nix ---
alias flake_rebuild = sudo nixos-rebuild switch --flake .
alias flake_rebuild_trace = sudo nixos-rebuild switch --flake . --show-trace
alias flake_up = sudo nix flake update
alias flake_up_trace = sudo nix flake update --show-trace
alias hm_switch = home-manager switch --flake .
alias hm_switch_trace = home-manager switch --flake . --show-trace
alias cg_empty = sudo nix-collect-garbage
alias cg_empty_all = sudo nix-collect-garbage -d

# --- Vim ---
alias v = nvim
alias vdiff = nvim -d

# --- Tmux ---
alias tmx_src = tmux source ~/.tmux.conf

# --- Zellij ---
# Run Zellij in a particular directory
def zj_dot [] {
  cd ~/dotfiles/
  zellij
}
def zj_obsidian [] {
  cd ~/obsidian_vault/
  zellij
}

def zj [dir: string = "~/"] {
    let dir_session = match $dir {
        "dot" => ["dotfiles", "~/dotfiles"],
        "dotvim" => ["neovim_config", "~/dotfiles/nvim"],
        "obsidian" => ["obsidian_vault", "~/obsidian_vault"],
        "kb" => ["keyboard_dev", "~/Documents/keyboard_dev"],
        _ => ["general", $dir]  # Default to "general" session
    }

    let session_name = $dir_session.0
    let target_dir = $dir_session.1

    cd $target_dir

    let existing_sessions = (zellij list-sessions | lines)
    if ($existing_sessions | any {|s| $s == $session_name }) {
        zellij attach $session_name
    } else {
        zellij --session $session_name
    }
}

# Run Zellij with the welcome screen
alias zj_welcome = zellij -l welcome

# --- Yazi ---
# Shell wrapper function "yz"
def --env yz [...args] {
    # Create a temporary file for storing Yazi's current working directory
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")

    # Run Yazi with arguments and save the CWD to the temporary file
    yazi ...$args --cwd-file $tmp

    # Read the saved CWD from the temporary file
    let cwd = (open $tmp)

    # Change to the saved directory if it's valid and different from the current one
    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }

    # Remove the temporary file
    rm -fp $tmp
}

# --- Aerospace ---
def as [command: string = ""] {
  let cmd = match $command {
    "load" => [reload-config]
    "debug" => [debug-windows]
    "monitor" => [list-monitors]
    "app" => [list-apps]
    # "app" => {
    #   let selection = (aerospace list-apps | fzf --bind 'enter:execute(aerospace focus --app-id {1})+abort' | str trim)
    #   return  # Selection is handled inside fzf, no need to return anything
    # }
    "window" => {
      let selection = (aerospace list-windows --all | fzf --bind 'enter:execute(aerospace focus --window-id {1})+abort' | str trim)
      return  # Selection is handled inside fzf
    }
    _ => {
      print "Usage: as <command>\nAvailable commands: load, debug, monitor, app, window"
      return
    }
  }

  # Run aerospace command only for non-fzf commands
  if $command not-in ["window"] {
    aerospace ...$cmd
  }
}

# --- Sketchybar ---
alias bar_load = sketchybar --reload
