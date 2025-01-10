-- ------------------------------------------------------------------
-- Filename: ~/dotfiles/wezterm/wezterm.lua

-- WezTerm Docs: https://wezfurlong.org/wezterm/config/files.html
-- ------------------------------------------------------------------
-- Pull in the wezterm API
local wezterm = require 'wezterm'

config = {
    default_prog = { 'nu', '-c', "zellij -l welcome --config-dir ~/.config/zellij options --layout-dir ~/.config/zellij/layouts" },
    -- { "/opt/homebrew/bin/nu" },
    set_environment_variables = {
        XDG_CONFIG_HOME = "/Users/jack/.config",
    },
    -- Appearance
    color_scheme = 'Catppuccin Macchiato',
    font = wezterm.font_with_fallback({
        'JetBrains Mono',
        'FiraCode',
        'Monaco',
    }),
    font_size = 16.0,
    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = true,
    tab_bar_at_bottom = false,
    use_fancy_tab_bar = false,

    -- Removes the macos bar at the top with the 3 buttons
	window_decorations = "RESIZE",

    macos_window_background_blur = 30,
    window_background_opacity = 0.92,

    -- Padding
    window_padding = {
        left = 10,
        right = 10,
        top = 10,
        bottom = 10,
    },

    -- Hyperlinks
    hyperlink_rules = wezterm.default_hyperlink_rules(),

    -- Scrolling
    scrollback_lines = 10000,

    -- Keybindings
    keys = {
        -- Fullscreen Toggle
        {
            key = 'f',
            mods = 'CTRL',
            action = wezterm.action.ToggleFullScreen,
        },
        -- Clear Scrollback
        {
            key = '\'',
            mods = 'CTRL',
            action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
        },
        -- New Tab
        {
            key = 't',
            mods = 'CTRL',
            action = wezterm.action.SpawnTab 'CurrentPaneDomain',
        },
    },

    -- Mouse bindings for opening links
    mouse_bindings = {
        {
            event = { Up = { streak = 1, button = 'Left' } },
            mods = 'CTRL',
            action = wezterm.action.OpenLinkAtMouseCursor,
        },
    },

    -- -- Tabs appear only on hover
    -- tab_bar_style = {
    --     window_hide_tab_bar_if_only_one_tab = true,
    --     tab_bar_bg_color = "#1e1e2e", -- Slightly darker for Dracula feel
    --     hover_tab_bar = fa,
    -- },
}

-- Return the configuration to wezterm
return config
