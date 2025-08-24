# Snapshot file
# Unset all aliases to avoid conflicts with functions
unalias -a 2>/dev/null || true
# Functions
# Shell Options
setopt nohashdirs
setopt login
# Aliases
alias -- run-help=man
alias -- which-command=whence
# Check for rg availability
if ! command -v rg >/dev/null 2>&1; then
  alias rg='/opt/homebrew/Caskroom/claude-code/1.0.72/claude --ripgrep'
fi
export PATH=/Users/jack/Documents/_dev_work/hive_urban_github/geo-data/.venv/bin\:/Users/jack/.config/carapace/bin\:/opt/homebrew/opt/ruby/bin\:/opt/homebrew/opt/ruby/gems/3.4.0/bin\:/usr/bin\:/bin\:/usr/sbin\:/sbin\:/Applications/Ghostty.app/Contents/MacOS\:/usr/local/bin\:/Users/jack/.local/bin\:/Users/jack/.cargo/bin\:/opt/homebrew/bin\:/opt/homebrew/sbin\:/opt/homebrew/opt/openjdk/bin\:/opt/homebrew/bin/ghostty\:/opt/homebrew/bin/nvim\:/Applications/Ghostty.app/Contents/MacOS/ghostty\:/Users/jack/.pyenv/bin\:/Users/jack/.pyenv/shims\:/Users/jack/.pyenv/plugins/pyenv-virtualenv/bin\:/Users/jack/.pyenv/versions/neovim/bin\:/Users/jack/.pyenv/versions/zed/bin
