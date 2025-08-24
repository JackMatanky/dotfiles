#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Filename: ~/.config/tmux/gen-tmux-docs.sh
# Description: Regenerate tmux keybinding cheatsheet and which-key YAML from
#              live tmux keymap
# Instructions:
#   - Run `chmod +x ~/.config/tmux/gen-tmux-docs.sh` to use the script.
#   - Run `~/.config/tmux/gen-tmux-docs.sh` to generate the cheat sheet and YAML.
# -----------------------------------------------------------------------------

DOTFILES=~/dotfiles
OUT_CHEATSHEET="$DOTFILES/tmux/tmux.keybindings"
OUT_YAML="$DOTFILES/tmux/which-key.yaml"

# --- Generate Cheat Sheet ---
generate_cheatsheet() {
  echo "Generating $OUT_CHEATSHEET..."
  echo '#!/usr/bin/env bash
clear
echo "
████████╗███╗   ███╗██╗   ██╗██╗  ██╗
╚══██╔══╝████╗ ████║██║   ██║╚██╗██╔╝
   ██║   ██╔████╔██║██║   ██║ ╚███╔╝
   ██║   ██║╚██╔╝██║██║   ██║ ██╔██╗
   ██║   ██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗
   ╚═╝   ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝

           TMUX KEYBINDING CHEAT SHEET
=====================================================
Prefix Key: C-a

[Keybindings]"' > "$OUT_CHEATSHEET"

  tmux list-keys | while read -r line; do
    key=$(echo "$line" | awk '{print $2}')
    cmd=$(echo "$line" | cut -d' ' -f3-)
    printf '  C-a %-8s  %s\n' "$key" "$cmd" >> "$OUT_CHEATSHEET"
  done

  chmod +x "$OUT_CHEATSHEET"
  echo "✓ Cheat sheet updated at $OUT_CHEATSHEET"
}

# --- Generate which-key YAML ---
generate_yaml() {
  echo "Generating $OUT_YAML..."
  {
    echo "command_alias_start_index: 200"
    echo "keybindings:"
    echo "  prefix_table: \" \""
    echo "  root_table: \"C-Space\""
    echo "title:"
    echo "  style: align=centre,bold"
    echo "  prefix: tmux"
    echo "  prefix_style: fg=green,align=centre,bold"
    echo "position:"
    echo "  x: R"
    echo "  y: P"
    echo "items:"
    tmux list-keys | while read -r line; do
      key=$(echo "$line" | awk '{print $2}')
      cmd=$(echo "$line" | cut -d' ' -f3-)
      name=$(echo "$cmd" | cut -d' ' -f1 | sed 's/-/ /g' | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
      printf '  - name: "%s"\n    key: "%s"\n    command: "%s"\n' "$name" "$key" "$cmd"
    done
  } > "$OUT_YAML"
  echo "✓ YAML config updated at $OUT_YAML"
}

generate_cheatsheet
generate_yaml
