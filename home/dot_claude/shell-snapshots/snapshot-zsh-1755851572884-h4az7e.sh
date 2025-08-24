# Snapshot file
# Unset all aliases to avoid conflicts with functions
unalias -a 2>/dev/null || true
# Functions
log_error () {
	_log_with_color 1 "ERROR" "$1"
}
log_info () {
	_log_with_color 2 "INFO" "$1"
}
log_warn () {
	_log_with_color 3 "WARN" "$1"
}
source_sh_files () {
	local dir="$1" 
	if [[ ! -d "$dir" ]]
	then
		if typeset -f log_warn &> /dev/null
		then
			log_warn "Directory not found: $dir"
		else
			echo "source_sh_files: Directory not found: $dir" >&2
		fi
		return
	fi
	IFS=$'\n' 
	files=($(find "$dir" \
        -maxdepth 1 \
        -type f \
        -name "*.sh" | sort)) 
	unset IFS
	for file in "${files[@]}"
	do
		if [[ ! -r "$file" ]]
		then
			if typeset -f log_warn &> /dev/null
			then
				log_warn "Skipping unreadable file: $file"
			else
				echo "[WARN] Skipping unreadable file: $file" >&2
			fi
			continue
		fi
		source "$file"
		if typeset -f log_info &> /dev/null
		then
			log_info "Sourced: $file"
		fi
	done
}
# Shell Options
setopt nohashdirs
setopt login
# Aliases
alias -- run-help=man
alias -- which-command=whence
# Check for rg availability
if ! command -v rg >/dev/null 2>&1; then
  alias rg='/opt/homebrew/Cellar/ripgrep/14.1.1/bin/rg'
fi
export PATH=/Users/jack/.config/carapace/bin\:/opt/homebrew/opt/ruby/bin\:/opt/homebrew/opt/ruby/gems/3.4.0/bin\:/Users/jack/.config/carapace/bin\:/opt/homebrew/lib/ruby/gems/3.4/bin\:/opt/homebrew/Cellar/pyenv-virtualenv/1.2.4/shims\:/Users/jack/.pyenv/shims\:/Users/jack/.pyenv/bin\:/opt/homebrew/opt/openjdk/bin\:/opt/homebrew/bin/nvim\:/opt/homebrew/bin\:/Users/jack/.cargo/bin\:/opt/homebrew/sbin\:/usr/local/bin\:/System/Cryptexes/App/usr/bin\:/usr/bin\:/bin\:/usr/sbin\:/sbin\:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin\:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin\:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin\:/Users/jack/.local/bin\:/opt/homebrew/bin/ghostty\:/Applications/Ghostty.app/Contents/MacOS/ghostty\:/Users/jack/.pyenv/plugins/pyenv-virtualenv/bin\:/Users/jack/.pyenv/versions/neovim/bin\:/Users/jack/.pyenv/versions/zed/bin
