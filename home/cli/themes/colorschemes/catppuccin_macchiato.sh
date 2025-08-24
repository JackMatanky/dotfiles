#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/themes/colorschemes/catppuccin-macchiato.sh
# Catppuccin Palette: https://catppuccin.com/palette
# Description: Full Catppuccin Macchiato palette with semantic aliases and
#              ANSI color mappings
# -----------------------------------------------------------------------------

# -----------------------------------------------
# Full Named Palette
# -----------------------------------------------
rosewater="#f4dbd6"
flamingo="#f0c6c6"
pink="#f5bde6"
mauve="#c6a0f6"
red="#ed8796"
maroon="#ee99a0"
peach="#f5a97f"
yellow="#eed49f"
green="#a6da95"
teal="#8bd5ca"
sky="#91d7e3"
sapphire="#7dc4e4"
blue="#8aadf4"
lavender="#b7bdf8"

text="#cad3f5"
subtext1="#b8c0e0"
subtext0="#a5adcb"
overlay2="#939ab7"
overlay1="#8087a2"
overlay0="#6e738d"
surface2="#5b6078"
surface1="#494d64"
surface0="#363a4f"
base="#24273a"
mantle="#1e2030"
crust="#181926"

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
md_heading_4="$maroon"
md_heading_5="$lavender"
md_heading_6="$peach"

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
