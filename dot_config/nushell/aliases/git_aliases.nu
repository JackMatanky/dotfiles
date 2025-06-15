# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/nushell/aliases/git_aliases.nu
# Source: https://github.com/nushell/nu_scripts/blob/main/aliases/git/git-aliases.nu
# -----------------------------------------------------------------------------
# Lazygit
alias lg = lazygit

# returns the name of the current branch
export def git_current_branch [] {
    ^git rev-parse --abbrev-ref HEAD
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
alias gc = git commit --message
def gcmsg [message: string] {
    git commit --message $message
}
def gcam [message: string] {
    git commit --all --message $message
}

# Push
alias gps = git push
alias gpso = git push origin
alias gpsod = git push origin --delete
alias gpsodc = git push origin --delete (git_current_branch)
alias gpsup = git push --set-upstream origin (git_current_branch)

# Pull
alias gpl = git pull
alias gplo = git pull origin
alias gplup = git pull upstream (git_main_branch)

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
alias gcom = git checkout (git_main_branch)
alias gcob = git checkout -b
alias gcoa = git checkout -- .

# Switch
export alias gsw = git switch
export alias gswc = git switch --create

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
alias gconf = git config --list

# Remove DS_Store
def grmds [] {
    git rm --cached '*.DS_Store'
    git commit --all --message 'Remove .DS_Store files'
}
