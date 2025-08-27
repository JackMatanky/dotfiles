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
        cmp = true,
        dashboard = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
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
