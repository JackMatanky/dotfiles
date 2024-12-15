# Nushell Config File
#
# version = "0.95.0"

# Theme Configuration
let dark_theme = {
    separator: white
    leading_trailing_space_bg: { attr: n }
    header: green_bold
    empty: blue
    bool: light_cyan
    int: white
    filesize: cyan
    duration: white
    date: purple
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cell-path: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray
    search_result: { bg: red fg: white }
    shape_and: purple_bold
    shape_garbage: { fg: white bg: red attr: b }
    shape_globpattern: cyan_bold
    shape_list: cyan_bold
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_operator: yellow
}

let light_theme = {
    separator: dark_gray
    leading_trailing_space_bg: { attr: n }
    header: green_bold
    empty: blue
    bool: dark_cyan
    int: dark_gray
    filesize: cyan_bold
    duration: dark_gray
    date: purple
    range: dark_gray
    float: dark_gray
    string: dark_gray
    nothing: dark_gray
    binary: dark_gray
    cell-path: dark_gray
    row_index: green_bold
    record: dark_gray
    list: dark_gray
    block: dark_gray
    hints: dark_gray
    search_result: { fg: white bg: red }
    shape_and: purple_bold
    shape_garbage: { fg: white bg: red attr: b }
    shape_globpattern: cyan_bold
    shape_list: cyan_bold
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_operator: yellow
}

# Environment Configuration
let-env config = {
    use_ls_colors: true
    table_mode: rounded
    error_style: "fancy"
    color_config: $dark_theme
    shell_integration: {
        osc2: true
        osc7: true
        osc8: true
        osc133: true
    }
}

# Source External Aliases
if (path exists ~/dotfiles/cli/aliases.sh) {
    source ~/dotfiles/cli/aliases.sh
} else {
    echo "aliases.sh not found, skipping alias import"
}

# Example Custom Function
def ff [] {
    echo "Custom function example"
}

# Plugins and Integrations
if (path exists ~/.cache/carapace/init.nu) {
    source ~/.cache/carapace/init.nu
} else {
    echo "Carapace integration not found, skipping"
}

if (path exists ~/.cache/starship/init.nu) {
    use ~/.cache/starship/init.nu
} else {
    echo "Starship integration not found, skipping"
}

# --- Aliases ---

# Directory aliases
alias dot = cd ~/.dotfiles
alias dot_nix = cd ~/.dotfiles/nixos
alias obsidian = cd ~/obsidian_vault
alias obsidian_gpl = cd ~/obsidian_vault; git pull
alias vimdiff = nvim -d

# Git aliases
alias gad = git add
alias gad_d = git add .
alias gad_p = git add -p
alias gbr = git branch
alias gbra = git branch -a
alias gc = git commit -m
alias gca = git commit -a -m
alias gco = git checkout
alias gcoall = git checkout -- .
alias gdiff = git diff
alias glog = git log --graph --topo-order --pretty='\''%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N'\'' --abbrev-commit
alias gpl = git pull
alias gpl_o = git pull origin
alias gps = git push
alias gps_o = git push origin
alias grm = git remote
alias grs = git reset
alias gst = git status

# Nix-related aliases
# alias cg_empty = sudo nix-collect-garbage
# alias cg_empty_all = sudo nix-collect-garbage -d
# alias flake_rebuild = sudo nixos-rebuild switch --flake .
# alias flake_rebuild_trace = sudo nixos-rebuild switch --flake . --show-trace
# alias flake_up = sudo nix flake update
# alias flake_up_trace = sudo nix flake update --show-trace
# alias hm_switch = home-manager switch --flake .
# alias hm_switch_trace = home-manager switch --flake . --show-trace
