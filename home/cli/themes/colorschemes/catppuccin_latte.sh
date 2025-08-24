#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/themes/colorschemes/catppuccin-latte.sh
# Catppuccin Palette: https://catppuccin.com/palette
# Description: Full Catppuccin Latte palette with semantic aliases and
#              ANSI color mappings
# -----------------------------------------------------------------------------

# -----------------------------------------------
# Full Named Palette
# -----------------------------------------------
rosewater="#dc8a78"
flamingo="#dd7878"
pink="#ea76cb"
mauve="#8839ef"
red="#d20f39"
maroon="#e64553"
peach="#fe640b"
yellow="#df8e1d"
green="#40a02b"
teal="#179299"
sky="#04a5e5"
sapphire="#209fb5"
blue="#1e66f5"
lavender="#7287fd"

text="#4c4f69"
subtext1="#5c5f77"
subtext0="#6c6f85"
overlay2="#7c7f93"
overlay1="#8c8fa1"
overlay0="#9ca0b0"
surface2="#acb0be"
surface1="#bcc0cc"
surface0="#ccd0da"
base="#eff1f5"
mantle="#e6e9ef"
crust="#dce0e8"

# -----------------------------------------------
# Semantic Aliases
# -----------------------------------------------
# >>> Background <<<
bg_main="$base"
bg_dim="$mantle"
bg_darkest="$crust"

# >>> Foreground <<<
fg_main="$text"
fg_dim="$subtext1"
fg_faint="$overlay1"
fg_comment="$overlay1"

# >>> Cursor <<<
cursor_color="$peach"
selection_bg="$surface1"
selection_fg="$text"

# >>> Status <<<
status_bg="$surface0"
status_fg="$subtext1"
inactive_pane_bg="$surface2"
active_pane_bg="$surface0"

# >>> Accent <<<
accent_info="$blue"
accent_hint="$teal"
accent_warn="$yellow"
accent_error="$red"
accent_ok="$green"
accent_heading="$lavender"
accent_match="$mauve"
accent_secondary="$sapphire"

# >>> Markdown Headings <<<
md_heading_1="$mauve"
md_heading_2="$blue"
md_heading_3="$green"
md_heading_4="$peach"
md_heading_5="$yellow"
md_heading_6="$pink"

# -----------------------------------------------
# 16-Color ANSI Mapping
# -----------------------------------------------
# >>> Standard Colors <<<
color0="$crust"      # black
color1="$red"        # red
color2="$green"      # green
color3="$yellow"     # yellow
color4="$blue"       # blue
color5="$mauve"      # magenta
color6="$teal"       # cyan
color7="$subtext0"   # white

# >>> Bright Colors <<<
color8="$overlay0"   # bright black
color9="$maroon"     # bright red
color10="$green"     # bright green
color11="$peach"     # bright yellow
color12="$sky"       # bright blue
color13="$pink"      # bright magenta
color14="$sapphire"  # bright cyan
color15="$text"      # bright white

# -----------------------------------------------
#  Optional: Wallpaper
# -----------------------------------------------

wallpaper="$HOME/.config/themes/assets/background_desktop_vale_rolling_hills_daylight.jpg"
