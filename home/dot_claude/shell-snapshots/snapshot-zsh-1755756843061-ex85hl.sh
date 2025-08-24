# Snapshot file
# Unset all aliases to avoid conflicts with functions
unalias -a 2>/dev/null || true
# Functions
add-zle-hook-widget () {
	# undefined
	builtin autoload -XU
}
add-zsh-hook () {
	emulate -L zsh
	local -a hooktypes
	hooktypes=(chpwd precmd preexec periodic zshaddhistory zshexit zsh_directory_name) 
	local usage="Usage: add-zsh-hook hook function\nValid hooks are:\n  $hooktypes" 
	local opt
	local -a autoopts
	integer del list help
	while getopts "dDhLUzk" opt
	do
		case $opt in
			(d) del=1  ;;
			(D) del=2  ;;
			(h) help=1  ;;
			(L) list=1  ;;
			([Uzk]) autoopts+=(-$opt)  ;;
			(*) return 1 ;;
		esac
	done
	shift $(( OPTIND - 1 ))
	if (( list ))
	then
		typeset -mp "(${1:-${(@j:|:)hooktypes}})_functions"
		return $?
	elif (( help || $# != 2 || ${hooktypes[(I)$1]} == 0 ))
	then
		print -u$(( 2 - help )) $usage
		return $(( 1 - help ))
	fi
	local hook="${1}_functions" 
	local fn="$2" 
	if (( del ))
	then
		if (( ${(P)+hook} ))
		then
			if (( del == 2 ))
			then
				set -A $hook ${(P)hook:#${~fn}}
			else
				set -A $hook ${(P)hook:#$fn}
			fi
			if (( ! ${(P)#hook} ))
			then
				unset $hook
			fi
		fi
	else
		if (( ${(P)+hook} ))
		then
			if (( ${${(P)hook}[(I)$fn]} == 0 ))
			then
				typeset -ga $hook
				set -A $hook ${(P)hook} $fn
			fi
		else
			typeset -ga $hook
			set -A $hook $fn
		fi
		autoload $autoopts -- $fn
	fi
}
as () {
	case "$1" in
		(load) aerospace reload-config ;;
		(debug) aerospace debug-windows ;;
		(monitor) aerospace list-monitors ;;
		(app) aerospace list-apps ;;
		(window) aerospace list-windows --all | fzf --bind 'enter:execute(aerospace focus --window-id {1})+abort' | xargs -r aerospace focus --window-id ;;
		(*) cat <<EOF ;;
Usage: as <command>
Available commands: load, debug, monitor, app, window
EOF
	esac
}
compaudit () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
compdef () {
	local opt autol type func delete eval new i ret=0 cmd svc 
	local -a match mbegin mend
	emulate -L zsh
	setopt extendedglob
	if (( ! $# ))
	then
		print -u2 "$0: I need arguments"
		return 1
	fi
	while getopts "anpPkKde" opt
	do
		case "$opt" in
			(a) autol=yes  ;;
			(n) new=yes  ;;
			([pPkK]) if [[ -n "$type" ]]
				then
					print -u2 "$0: type already set to $type"
					return 1
				fi
				if [[ "$opt" = p ]]
				then
					type=pattern 
				elif [[ "$opt" = P ]]
				then
					type=postpattern 
				elif [[ "$opt" = K ]]
				then
					type=widgetkey 
				else
					type=key 
				fi ;;
			(d) delete=yes  ;;
			(e) eval=yes  ;;
		esac
	done
	shift OPTIND-1
	if (( ! $# ))
	then
		print -u2 "$0: I need arguments"
		return 1
	fi
	if [[ -z "$delete" ]]
	then
		if [[ -z "$eval" ]] && [[ "$1" = *\=* ]]
		then
			while (( $# ))
			do
				if [[ "$1" = *\=* ]]
				then
					cmd="${1%%\=*}" 
					svc="${1#*\=}" 
					func="$_comps[${_services[(r)$svc]:-$svc}]" 
					[[ -n ${_services[$svc]} ]] && svc=${_services[$svc]} 
					[[ -z "$func" ]] && func="${${_patcomps[(K)$svc][1]}:-${_postpatcomps[(K)$svc][1]}}" 
					if [[ -n "$func" ]]
					then
						_comps[$cmd]="$func" 
						_services[$cmd]="$svc" 
					else
						print -u2 "$0: unknown command or service: $svc"
						ret=1 
					fi
				else
					print -u2 "$0: invalid argument: $1"
					ret=1 
				fi
				shift
			done
			return ret
		fi
		func="$1" 
		[[ -n "$autol" ]] && autoload -rUz "$func"
		shift
		case "$type" in
			(widgetkey) while [[ -n $1 ]]
				do
					if [[ $# -lt 3 ]]
					then
						print -u2 "$0: compdef -K requires <widget> <comp-widget> <key>"
						return 1
					fi
					[[ $1 = _* ]] || 1="_$1" 
					[[ $2 = .* ]] || 2=".$2" 
					[[ $2 = .menu-select ]] && zmodload -i zsh/complist
					zle -C "$1" "$2" "$func"
					if [[ -n $new ]]
					then
						bindkey "$3" | IFS=$' \t' read -A opt
						[[ $opt[-1] = undefined-key ]] && bindkey "$3" "$1"
					else
						bindkey "$3" "$1"
					fi
					shift 3
				done ;;
			(key) if [[ $# -lt 2 ]]
				then
					print -u2 "$0: missing keys"
					return 1
				fi
				if [[ $1 = .* ]]
				then
					[[ $1 = .menu-select ]] && zmodload -i zsh/complist
					zle -C "$func" "$1" "$func"
				else
					[[ $1 = menu-select ]] && zmodload -i zsh/complist
					zle -C "$func" ".$1" "$func"
				fi
				shift
				for i
				do
					if [[ -n $new ]]
					then
						bindkey "$i" | IFS=$' \t' read -A opt
						[[ $opt[-1] = undefined-key ]] || continue
					fi
					bindkey "$i" "$func"
				done ;;
			(*) while (( $# ))
				do
					if [[ "$1" = -N ]]
					then
						type=normal 
					elif [[ "$1" = -p ]]
					then
						type=pattern 
					elif [[ "$1" = -P ]]
					then
						type=postpattern 
					else
						case "$type" in
							(pattern) if [[ $1 = (#b)(*)=(*) ]]
								then
									_patcomps[$match[1]]="=$match[2]=$func" 
								else
									_patcomps[$1]="$func" 
								fi ;;
							(postpattern) if [[ $1 = (#b)(*)=(*) ]]
								then
									_postpatcomps[$match[1]]="=$match[2]=$func" 
								else
									_postpatcomps[$1]="$func" 
								fi ;;
							(*) if [[ "$1" = *\=* ]]
								then
									cmd="${1%%\=*}" 
									svc=yes 
								else
									cmd="$1" 
									svc= 
								fi
								if [[ -z "$new" || -z "${_comps[$1]}" ]]
								then
									_comps[$cmd]="$func" 
									[[ -n "$svc" ]] && _services[$cmd]="${1#*\=}" 
								fi ;;
						esac
					fi
					shift
				done ;;
		esac
	else
		case "$type" in
			(pattern) unset "_patcomps[$^@]" ;;
			(postpattern) unset "_postpatcomps[$^@]" ;;
			(key) print -u2 "$0: cannot restore key bindings"
				return 1 ;;
			(*) unset "_comps[$^@]" ;;
		esac
	fi
}
compdump () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
compinit () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
compinstall () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/5.9/functions
}
cx () {
	local target="${1:-}" 
	if [ -z "$target" ]
	then
		target="$(__fzf_pick_dir)" 
	fi
	if [ -n "$target" ]
	then
		__cd_and_run "$target" eza -la --group-directories-first --icons
	fi
}
f () {
	local file
	file="$(__fzf_pick_file)" 
	if [ -n "$file" ]
	then
		printf '%s' "$file" | pbcopy
	fi
}
fdv () {
	local dir
	dir="$(__fzf_pick_dir)" 
	if [ -n "$dir" ]
	then
		nvim "$dir"
	fi
}
ffv () {
	local file
	file="$(__fzf_pick_file)" 
	if [ -n "$file" ]
	then
		nvim "$file"
	fi
}
fgv () {
	local repo
	repo=$(fd --type directory --hidden --exclude .git |
        fzf --preview 'eza --tree --level=2 --color=always {}') 
	[ -n "$repo" ] && nvim "$repo"
}
gbs () {
	local branch
	branch=$(git_select_branch) 
	if [ -z "$branch" ]
	then
		echo "No branch selected or entered." >&2
		return 1
	fi
	git_switch_or_create_branch "$branch"
}
gcam () {
	local msg="${1:-}" 
	if [ -z "$msg" ]
	then
		echo "Usage: gcam <message>" >&2
		return 1
	fi
	git commit --all --message "$msg"
}
gcm () {
	local msg="${1:-}" 
	if [ -z "$msg" ]
	then
		echo "Usage: gcm <message>" >&2
		return 1
	fi
	git commit --message "$msg"
}
get-env () {
	echo "${(P)1}"
}
getent () {
	if [[ $1 = hosts ]]
	then
		sed 's/#.*//' /etc/$1 | grep -w $2
	elif [[ $2 = <-> ]]
	then
		grep ":$2:[^:]*$" /etc/$1
	else
		grep "^$2:" /etc/$1
	fi
}
git_current_branch () {
	git rev-parse --abbrev-ref HEAD
}
git_list_branches () {
	git branch --all --format="%(refname:short)" | sed 's#^remotes/##' | sort -u
}
git_main_branch () {
	git remote show origin | grep -E 'HEAD.*: ' | sed -E 's/.*HEAD.*: (.*)/\1/'
}
git_select_branch () {
	local branches selection
	branches=$(git_list_branches) 
	selection=$(
        printf '%s
        ' "$branches" |
            fzf --prompt="Branch> " --print-query
    ) 
	printf '%s' "$selection" | tail -n1
}
git_switch_or_create_branch () {
	local branch="$1" 
	if git show-ref --verify --quiet "refs/heads/$branch"
	then
		git switch "$branch"
	else
		git switch -c "$branch"
	fi
}
gplup () {
	git pull upstream "$(git_main_branch)"
}
gpsodc () {
	git push origin --delete "$(git_current_branch)"
}
gpsup () {
	git push --set-upstream origin "$(git_current_branch)"
}
grmds () {
	git rm --cached '*.DS_Store'
	git commit --all --message 'Remove .DS_Store files'
}
is-at-least () {
	emulate -L zsh
	local IFS=".-" min_cnt=0 ver_cnt=0 part min_ver version order 
	min_ver=(${=1}) 
	version=(${=2:-$ZSH_VERSION} 0) 
	while (( $min_cnt <= ${#min_ver} ))
	do
		while [[ "$part" != <-> ]]
		do
			(( ++ver_cnt > ${#version} )) && return 0
			if [[ ${version[ver_cnt]} = *[0-9][^0-9]* ]]
			then
				order=(${version[ver_cnt]} ${min_ver[ver_cnt]}) 
				if [[ ${version[ver_cnt]} = <->* ]]
				then
					[[ $order != ${${(On)order}} ]] && return 1
				else
					[[ $order != ${${(O)order}} ]] && return 1
				fi
				[[ $order[1] != $order[2] ]] && return 0
			fi
			part=${version[ver_cnt]##*[^0-9]} 
		done
		while true
		do
			(( ++min_cnt > ${#min_ver} )) && return 0
			[[ ${min_ver[min_cnt]} = <-> ]] && break
		done
		(( part > min_ver[min_cnt] )) && return 0
		(( part < min_ver[min_cnt] )) && return 1
		part='' 
	done
}
log_error () {
	_log_with_color 1 "ERROR" "$1"
}
log_info () {
	_log_with_color 2 "INFO" "$1"
}
log_warn () {
	_log_with_color 3 "WARN" "$1"
}
mvf () {
	local dir="." 
	local dry_run=false 
	local confirm=false 
	local arg
	while [[ $# -gt 0 ]]
	do
		arg="$1" 
		case "$arg" in
			(--current-dir) dir="." 
				shift ;;
			(--dir) dir="$2" 
				shift 2 ;;
			(--dry-run) dry_run=true 
				shift ;;
			(--confirm) confirm=true 
				shift ;;
			(*) echo "Unknown option: $arg" >&2
				return 1 ;;
		esac
	done
	local files
	files=$(fd --type f . "$dir" | fzf --multi \
        --prompt="Select file(s) to move: " \
        --preview="bat --style=plain --color=always --line-range :40 {}") 
	if [[ -z "$files" ]]
	then
		echo "No files selected."
		return 1
	fi
	local dest
	dest="$(__fzf_pick_dir)" 
	if [[ -z "$dest" ]]
	then
		echo "No destination selected."
		return 1
	fi
	if $confirm
	then
		echo -e "\nSelected files:\n$files"
		echo "Destination: $dest"
		read -rp "Proceed with move? [y/N]: " choice
		if [[ ! "$choice" =~ ^[Yy]$ ]]
		then
			echo "Operation cancelled."
			return 1
		fi
	fi
	local file
	while IFS= read -r file
	do
		if $dry_run
		then
			echo "[Dry Run] mv \"$file\" \"$dest/\""
		else
			mv "$file" "$dest" && echo "Moved '$file' -> '$dest/'"
		fi
	done <<< "$files"
}
obsidian_gpl () {
	cd ~/obsidian_vault && git pull
}
ocrfile () {
	local input="$1" 
	if [ -z "$input" ]
	then
		input="$(fd --type file --extension pdf | fzf)" 
		[ -z "$input" ] && echo "No file selected." && return 1
	fi
	local abs_path output
	abs_path="$(realpath "$input")" 
	output="${abs_path%.pdf}_ocr.pdf" 
	ocrmypdf --rotate-pages --deskew --output-type pdf "$abs_path" "$output"
}
ocrfolder () {
	local folder="$1" 
	if [ -z "$folder" ]
	then
		folder="$(fd --type directory | fzf)" 
		[ -z "$folder" ] && echo "No folder selected." && return 1
	fi
	local abs_path pdf output
	abs_path="$(realpath "$folder")" 
	while IFS= read -r pdf
	do
		local abs_pdf output
		abs_pdf="$(realpath "$pdf")" 
		output="${abs_pdf%.pdf}_ocr.pdf" 
		if [ -f "$output" ]
		then
			echo "⚠️ Skipping (exists): $output"
			continue
		fi
		echo "OCR'ing: $abs_pdf"
		ocrmypdf --rotate-pages --deskew --output-type pdf "$abs_pdf" "$output"
	done < <(fd --type file --extension pdf "$abs_path")
	echo "✅ Batch OCR complete."
}
prompt_starship_precmd () {
	STARSHIP_CMD_STATUS=$? STARSHIP_PIPE_STATUS=(${pipestatus[@]}) 
	if (( ${+STARSHIP_START_TIME} ))
	then
		__starship_get_time && (( STARSHIP_DURATION = STARSHIP_CAPTURED_TIME - STARSHIP_START_TIME ))
		unset STARSHIP_START_TIME
	else
		unset STARSHIP_DURATION STARSHIP_CMD_STATUS STARSHIP_PIPE_STATUS
	fi
	STARSHIP_JOBS_COUNT=${#jobstates} 
}
prompt_starship_preexec () {
	__starship_get_time && STARSHIP_START_TIME=$STARSHIP_CAPTURED_TIME 
}
pyenv () {
	local command=${1:-} 
	[ "$#" -gt 0 ] && shift
	case "$command" in
		(activate | deactivate | rehash | shell) eval "$(pyenv "sh-$command" "$@")" ;;
		(*) command pyenv "$command" "$@" ;;
	esac
}
restow_all () {
	cd "$HOME/dotfiles" || return
	stow -R .
}
rgf () {
	(
		local reload_cmd
		reload_cmd=$'reload:rg --column --line-number \
                --no-heading --color=always \
                --smart-case {q} || :' 
		eval 'fd --type file --hidden --follow --exclude .git' | fzf --ansi --multi --preview 'bat --style=full --color=always {} || cat {}' --bind "$reload_cmd" --delimiter : --preview-window 'right:60%' --query "$*"
	)
}
set-env () {
	export "$1=$2"
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
starship_zle-keymap-select () {
	zle reset-prompt
}
stow_all () {
	(
		cd "$HOME/dotfiles" && stow .
	)
}
tmx () {
	local dir="${1:-~/}" 
	local name dirpath
	case "$dir" in
		(dot) name="dotfiles" 
			dirpath="$HOME/dotfiles"  ;;
		(dotvim) name="neovim_config" 
			dirpath="$HOME/dotfiles/nvim"  ;;
		(obsidian) name="obsidian_vault" 
			dirpath="$HOME/obsidian_vault"  ;;
		(kb) name="keyboard_dev" 
			dirpath="$HOME/Documents/keyboard_dev"  ;;
		(*) name="general" 
			dirpath="$dir"  ;;
	esac
	cd "$dirpath" || return
	if tmux list-sessions | grep -xq "$name"
	then
		tmux attach-session -t "$name"
	else
		tmux new-session -s "$name"
	fi
}
unset-env () {
	unset "$1"
}
unstow_all () {
	cd "$HOME/dotfiles" || return
	stow -D .
}
yz () {
	local tmp
	tmp="$(mktemp -t yazi-cwd.XXXXXX)" 
	yazi --cwd-file "$tmp" "$@"
	if [[ -s "$tmp" ]]
	then
		local cwd
		cwd="$(<"$tmp")" 
		if [[ -n "$cwd" && "$cwd" != "$PWD" ]]
		then
			cd "$cwd"
		fi
	fi
	rm -f "$tmp"
}
z () {
	__zoxide_z "$@"
}
zi () {
	__zoxide_zi "$@"
}
zj () {
	local session="${1:-~/}" 
	local name dirpath
	case "$session" in
		(dot) name="dotfiles" 
			dirpath="$HOME/dotfiles"  ;;
		(dotvim) name="neovim_config" 
			dirpath="$HOME/dotfiles/nvim"  ;;
		(obsidian) name="obsidian_vault" 
			dirpath="$HOME/obsidian_vault"  ;;
		(kb) name="keyboard_dev" 
			dirpath="$HOME/Documents/keyboard_dev"  ;;
		(*) name="general" 
			dirpath="$session"  ;;
	esac
	cd "$dirpath" || return
	if zellij list-sessions | grep -xq "$name"
	then
		zellij attach "$name"
	else
		zellij --session "$name"
	fi
}
zj_dot () {
	cd "$HOME/dotfiles" && zellij
}
zj_obsidian () {
	cd "$HOME/obsidian_vault" && zellij
}
# Shell Options
setopt nohashdirs
setopt histfcntllock
setopt histignoredups
setopt histignorespace
setopt login
setopt promptsubst
setopt sharehistory
# Aliases
alias -- bar_load='sketchybar --reload'
alias -- c=clear
alias -- cg_empty='sudo nix-collect-garbage'
alias -- cg_empty_all='sudo nix-collect-garbage -d'
alias -- conf-dir='cd ~/.config'
alias -- dev-geo-data='cd ~/Documents/_dev_work/hive_urban_github/geo-data'
alias -- dev-hive='cd ~/Documents/_dev_work/hive_urban_github'
alias -- dev-work='cd ~/Documents/_dev_work'
alias -- docs='cd ~/Documents'
alias -- dot='cd ~/dotfiles'
alias -- dot-nix='cd ~/dotfiles/nixos'
alias -- flake_rebuild='sudo nixos-rebuild switch --flake .'
alias -- flake_rebuild_trace='sudo nixos-rebuild switch --flake . --show-trace'
alias -- flake_up='sudo nix flake update'
alias -- flake_up_trace='sudo nix flake update --show-trace'
alias -- ga='git add'
alias -- gaa='git add --all'
alias -- gapa='git add --patch'
alias -- gau='git add --update'
alias -- gb='git branch'
alias -- gbD='git branch --delete --force'
alias -- gbd='git branch --delete'
alias -- gbra='git branch --all'
alias -- gc='git commit --message'
alias -- gco='git checkout'
alias -- gcoa='git checkout -- .'
alias -- gcob='git checkout -b'
alias -- gcom='git checkout $(git_main_branch)'
alias -- gconf='git config --list'
alias -- gdiff='git diff'
alias -- gf='git fetch'
alias -- gfo='git fetch origin'
alias -- gl='git log'
alias -- glog=$'git log --graph --topo-order \\\n    --pretty="%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n\\\n%C(bold)%C(white)%s %N" \\\n    --abbrev-commit'
alias -- gpl='git pull'
alias -- gplo='git pull origin'
alias -- gps='git push'
alias -- gpso='git push origin'
alias -- gpsod='git push origin --delete'
alias -- gr='git remote'
alias -- gra='git remote add'
alias -- grs='git reset'
alias -- grset='git remote set-url'
alias -- grsh='git reset --hard'
alias -- gst='git status'
alias -- gsw='git switch'
alias -- gswc='git switch --create'
alias -- hm_switch='home-manager switch --flake .'
alias -- hm_switch_trace='home-manager switch --flake . --show-trace'
alias -- j=just
alias -- kb-dev='cd ~/Documents/keyboard_dev'
alias -- kb-ergogen='cd ~/Documents/keyboard_dev/ergogen'
alias -- kb-snak_dir='cd ~/Documents/keyboard_dev/kb_snak'
alias -- kb-zmk='cd ~/Documents/keyboard_dev/zmk-config'
alias -- l='ls -l'
alias -- lg=lazygit
alias -- ll='eza --long --icons --git --all --group-directories-first'
alias -- lt='eza --tree --level=2 --icons --git --ignore-glob "__pycache__"'
alias -- ltree='eza --tree --level=3 --icons --git --ignore-glob "__pycache__"'
alias -- ltree-full='eza --tree --level=5 --icons --git --ignore-glob "__pycache__"'
alias -- obsidian='cd ~/obsidian_vault'
alias -- obsidian-gpl=obsidian_gpl
alias -- restow='stow -R'
alias -- restow-all=restow_all
alias -- run-help=man
alias -- stow-all=stow_all
alias -- taskmaster=task-master
alias -- tm=task-master
alias -- tmx-src='tmux source-file "$HOME/.config/tmux/tmux.conf"'
alias -- unstow='stow -D'
alias -- unstow-all=unstow_all
alias -- v=nvim
alias -- vdiff='nvim -d'
alias -- which-command=whence
alias -- za='zoxide add'
alias -- zj-dot=zj_dot
alias -- zj-obsidian=zj_obsidian
alias -- zj-welcome='zellij -l welcome'
alias -- zq='zoxide query'
# Check for rg availability
if ! command -v rg >/dev/null 2>&1; then
  alias rg='/opt/homebrew/Caskroom/claude-code/1.0.83/claude --ripgrep'
fi
export PATH=/Users/jack/Documents/_dev_work/hive_urban_github/geo-data/.venv/bin\:/Users/jack/.config/carapace/bin\:/opt/homebrew/lib/ruby/gems/3.4/bin\:/opt/homebrew/opt/ruby/bin\:/opt/homebrew/Cellar/pyenv-virtualenv/1.2.4/shims\:/Users/jack/.pyenv/shims\:/Users/jack/.pyenv/bin\:/opt/homebrew/opt/openjdk/bin\:/opt/homebrew/bin/nvim\:/opt/homebrew/bin\:/Users/jack/.cargo/bin\:/opt/homebrew/bin\:/opt/homebrew/sbin\:/usr/local/bin\:/System/Cryptexes/App/usr/bin\:/usr/bin\:/bin\:/usr/sbin\:/sbin\:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin\:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin\:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin
