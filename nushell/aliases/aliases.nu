# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/nushell/aliases.nu
# -----------------------------------------------------------------------------

# --- Navigation ---
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

# --- GNU Stow ---
def stow_all [] {
  cd ~/dotfiles/
  stow .
}

def unstow_all [] {
  cd ~/dotfiles/
  stow -D .
}

def restow_all [] {
  cd ~/dotfiles/
  stow -R .
}

alias unstow = stow -D
alias restow = stow -R

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

# --- OCRmyPDF ---
# ocrfile: OCR a PDF file using ocrmypdf
def ocrfile [path?: string] {
  # If no path is provided, use fzf to interactively select a .pdf file via fd
  let file = (if ($path == null) {
    fd --type file --extension pdf | fzf
  } else {
    $path
  })

  # Get absolute path of selected file
  let absolute_path = ($file | path expand)

  # Define output path with "_ocr" suffix
  let output_path = ($absolute_path | str replace ".pdf" "_ocr.pdf")

  # Run OCR with basic cleanup and output formatting
  ocrmypdf --rotate-pages --deskew --output-type pdf $absolute_path $output_path
}

# ocrfolder: OCR a folder's PDF files using ocrmypdf
def ocrfolder [path?: string] {
  # If no folder provided, use fd + fzf to select one interactively
  let folder = (if ($path == null) {
    fd --type directory | fzf
  } else {
    $path
  })

  # Get absolute path of selected folder
  let absolute_path = ($folder | path expand)

  # Recursively find all .pdf files in the folder
  let folder_pdfs = (fd --type file --extension pdf $absolute_path)

  # Abort if no PDFs found
  if ($folder_pdfs | is-empty) {
    print $"No PDF files found in folder: ($absolute_path)"
    return
  }

  # Process each PDF in the folder
  for pdf in $folder_pdfs {
    let pdf_path = ($pdf | path expand)
    let output_path = ($pdf_path | str replace ".pdf" "_ocr.pdf")

    # Skip files that already have an OCR'd version
    if ($output_path | path exists) {
      print $"⚠️ Skipping (already exists): ($output_path)"
      continue
    }

    # Run OCR on the current PDF
    print $"OCR'ing: ($pdf_path)"
    ocrmypdf --rotate-pages --deskew --output-type pdf $pdf_path $output_path
  }

  print "✅ Batch OCR complete."
}
