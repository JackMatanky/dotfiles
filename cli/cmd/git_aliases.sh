# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/cli/cmd/git_aliases.sh
# Description: Aliases for common git commands
# -----------------------------------------------------------------------------
# Lazygit
alias lg='lazygit'

# Note: git_current_branch helper
# Returns the name of the current branch
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
gcm() {
    git commit --message "$1";
}
gcam() {
    git commit --all --message "$1";
}

# Push
alias gps='git push'
alias gpso='git push origin'
alias gpsod='git push origin --delete'
gpsodc() {
    git push origin --delete "$(git_current_branch)";
}
gpsup() {
    git push --set-upstream origin "$(git_current_branch)";
}

# Pull
alias gpl='git pull'
alias gplo='git pull origin'
gplup() {
    git pull upstream "$(git_main_branch)";
}

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

# Switch
alias gsw='git switch'
alias gswc='git switch --create'

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
