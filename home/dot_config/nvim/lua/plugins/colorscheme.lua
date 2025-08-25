-- ----------------------------------------------------------------------------
--  Filename: ~/.config/nvim/lua/plugins/colorscheme.lua
--  LazyVim: https://www.lazyvim.org/plugins/colorscheme
--  Catppuccin: https://github.com/catppuccin/nvim
-- ----------------------------------------------------------------------------

return {
  -- Disable unwanted themes
  { "folke/tokyonight.nvim", enabled = false },

  -- Catppuccin
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    name = "catppuccin",
    opts = {
      flavour = "macchiato", -- Custom: Default is "mocha"
      transparent_background = true, -- Custom: Enable transparency
      -- Most integrations are enabled by default, so we only need to specify
      -- integrations that differ from defaults or have custom configurations
      integrations = {
        -- All the listed integrations are already enabled by default in LazyVim
        -- We only need to specify those with custom configurations
        navic = { enabled = true, custom_bg = "lualine" }, -- Custom background
      },
    },
  },

  -- Configure LazyVim to load catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
