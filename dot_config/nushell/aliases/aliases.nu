# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/nushell/aliases/aliases.nu
# -----------------------------------------------------------------------------

# -------------------------------------------------------- #
#                        Navigation                        #
# -------------------------------------------------------- #
# cx: Change into a directory and list its contents
def --env cx [path?: string] {
    # - If a path is not provided, use fzf to interactively select a directory
    let target = (if ($path == null) {
        fd --type directory --hidden --exclude .git | fzf
    } else {
        # - If a path is passed, cd to it
        $path
    })
    if ($target != "") {
        cd $target
        ls -l
    }
}

# f: Fuzzy search for a file and copy its path to clipboard
def f [] {
    let file = (fd --type file --hidden --exclude .git | fzf)
    if ($file != "") {
        echo $file | pbcopy
    }
}

# fb: Fuzzy-find a file with inline preview and then view it with bat
def ffb [] {
    # Use fd to find all files (including hidden, excluding .git), pipe to fzf
    let file = (
        fd --type file --hidden --exclude .git
        | fzf --preview 'bat --style=numbers --color=always {}'  # Inline preview using bat
    )

    # If a file was selected, display it with bat
    if ($file != "") {
        bat $file
    }
}

# ffv: Fuzzy search for a file and open it in nvim
def ffv [] {
    let file = (fd --type file --hidden --exclude .git | fzf)
    if ($file != "") {
        nvim $file
    }
}

# fdv: Fuzzy search for a directory and open it in nvim
def fdv [] {
    # List directories with fd and select one using fzf
    let dir = (fd --type directory --hidden --exclude .git | fzf)

    # Open selected directory in nvim
    if ($dir != "") {
        nvim $dir
    }
}

# -------------------------------------------------------- #
#                      Shell Commands                      #
# -------------------------------------------------------- #
alias c = clear
alias l = ls -l

# ----------------------- Justfile ----------------------- #
alias j = just

# -------------------------- eza ------------------------- #
alias ll = eza --long --icons --git --all --group-directories-first # Detailed File List
alias lt = eza --tree --level=2 --icons --git # Tree View - 2 levels
alias ltree = eza --tree --level=3 --icons --git # Tree View - 3 levels

# ------------------------ Zoxide ------------------------ #
# Docs: https://github.com/ajeetdsouza/zoxide
alias za = zoxide add
alias zq = zoxide query

# -------------------------------------------------------- #
#                        Directories                       #
# -------------------------------------------------------- #
alias conf-dir = cd ~/.config
alias docs = cd ~/Documents

# ----------------------- Dotfiles ----------------------- #
alias dot = cd ~/dotfiles
alias dot-nix = cd ~/dotfiles/nixos

# -------------------- Obsidian Vault -------------------- #
alias obsidian = cd ~/obsidian_vault
def obsidian-gpl [] {
    cd ~/obsidian_vault
    git pull
}

# --------------------- Keyboard Dev --------------------- #
alias kb-dev = cd ~/Documents/keyboard_dev
alias kb-ergogen = cd ~/Documents/keyboard_dev/ergogen
alias kb-zmk = cd ~/Documents/keyboard_dev/zmk-config
alias kb-snak-dir = cd ~/Documents/keyboard_dev/kb_snak

# ------------------------- Work ------------------------- #
alias dev-work = cd ~/Documents/_dev_work
alias dev-hive = cd ~/Documents/_dev_work/hive_urban_github

# -------------------------------------------------------- #
#                         GNU Stow                         #
# -------------------------------------------------------- #
def stow-all [] {
    cd ~/dotfiles/
    stow .
}

def unstow-all [] {
    cd ~/dotfiles/
    stow -D .
}

def restow-all [] {
    cd ~/dotfiles/
    stow -R .
}

alias unstow = stow -D
alias restow = stow -R

# -------------------------------------------------------- #
#                            Nix                           #
# -------------------------------------------------------- #
alias flake-rebuild = sudo nixos-rebuild switch --flake .
alias flake-rebuild_trace = sudo nixos-rebuild switch --flake . --show-trace
alias flake-up = sudo nix flake update
alias flake-up_trace = sudo nix flake update --show-trace
alias hm-switch = home-manager switch --flake .
alias hm-switch-trace = home-manager switch --flake . --show-trace
alias cg-empty = sudo nix-collect-garbage
alias cg-empty-all = sudo nix-collect-garbage -d


# -------------------------------------------------------- #
#                  Tooling & Integrations                  #
# -------------------------------------------------------- #

# -------------------------- Vim ------------------------- #
alias v = nvim
alias vdiff = nvim -d

# ------------------------- Tmux ------------------------- #

# Reload tmux configuration
alias tmx-src = tmux source-file ~/.config/tmux/tmux.conf

# Run tmux in a specific directory/session
def tmx [dir: string = "~/"] {
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

    let sessions = (tmux list-sessions | lines)
    if ($sessions | any {|s| $s =~ $session_name }) {
        tmux attach-session -t $session_name
    } else {
        tmux new-session -s $session_name
    }
}

# ------------- Zellij: Terminal Multiplexer ------------- #
# Docs: https://zellij.dev/documentation/
# Run Zellij in a particular directory
def zj-dot [] {
    cd ~/dotfiles/
    zellij
}
def zj-obsidian [] {
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
alias zj-welcome = zellij -l welcome

# ------------------------- Yazi ------------------------- #
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

# ----------------------- Aerospace ---------------------- #
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

# ---------------------- Sketchybar ---------------------- #
alias bar-load = sketchybar --reload

# ------------------- Pyenv Integration ------------------ #
# Helper function to activate a pyenv virtualenv
def use_pyenv_env [env_name: string] {
  let pyenv_root = ($env.HOME | path join ".pyenv")
  let env_path = ($pyenv_root | path join "versions" $env_name)
  let bin_path = ($env_path | path join "bin")

  if ($env_path | path exists) {
    # Set required environment variables before loading overlay
    load-env {
      __VIRTUAL_ENV__: $env_path
      __BIN_NAME__: "bin"
      __VIRTUAL_PROMPT__: $env_name
    }

    # Load the overlay which uses these env vars
    overlay use ~/.config/nushell/overlays/activate.nu
  } else {
    print $"❌ pyenv environment not found: ($env_path)"
  }
}

# --- uv ---
# Activate virtual environment
# alias uv_activate = ['use' ['.venv' (if (uname | get operating-system) == 'Windows' { 'Scripts' } else { 'bin' }) 'activate.nu'] | path join] str join ' '

# def activate [] {
#   let os = (uname | get operating-system)
#   let dir = (if $os == 'Windows' { 'Scripts' } else { 'bin' })
#   let path = ['.venv' $dir 'activate.nu'] | path join

#   if (not ($path | path exists)) {
#     error make {
#       msg: $"Could not find activate.nu at: ($path)"
#     }
#   }

#   echo $path
# }
