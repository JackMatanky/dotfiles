-- Filename: ~dotfiles/nvim/lua/plugins/catppuccin.lua
--
-- GitHub Repo: https://github.com/catppuccin/nvim
return {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup(
            {
                flavour = "macchiato", -- latte, frappe, macchiato, mocha
                background = {
                    -- :h background
                    light = "latte",
                    dark = "macchiato"
                },
                transparent_background = false,
                show_end_of_buffer = false, -- show the '~' characters after the end of buffers
                term_colors = true,
                dim_inactive = {
                    enabled = false,
                    shade = "dark",
                    percentage = 0.15
                },
                no_italic = false, -- Force no italic
                no_bold = false, -- Force no bold
                styles = {
                    comments = {"italic"},
                    conditionals = {"italic"},
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {}
                },
                color_overrides = {},
                custom_highlights = {},
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    telescope = true,
                    notify = false,
                    mini = false
                    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
                }
            }
        )
        -- setup must be called before loading
        vim.cmd.colorscheme "catppuccin"
    end
}



-- LazyVim
-- {
  -- "catppuccin/nvim",
  -- lazy = true,
  -- name = "catppuccin",
  -- opts = {
    -- integrations = {
      -- aerial = true,
      -- alpha = true,
      -- cmp = true,
      -- dashboard = true,
      -- flash = true,
      -- fzf = true,
      -- grug_far = true,
      -- gitsigns = true,
      -- headlines = true,
      -- illuminate = true,
      -- indent_blankline = { enabled = true },
      -- leap = true,
      -- lsp_trouble = true,
      -- mason = true,
      -- markdown = true,
      -- mini = true,
      -- native_lsp = {
        -- enabled = true,
        -- underlines = {
          -- errors = { "undercurl" },
          -- hints = { "undercurl" },
          -- warnings = { "undercurl" },
          -- information = { "undercurl" },
        -- },
      -- },
      -- navic = { enabled = true, custom_bg = "lualine" },
      -- neotest = true,
      -- neotree = true,
      -- noice = true,
      -- notify = true,
      -- semantic_tokens = true,
      -- snacks = true,
      -- telescope = true,
      -- treesitter = true,
      -- treesitter_context = true,
      -- which_key = true,
    -- },
  -- },
  -- specs = {
    -- {
      -- "akinsho/bufferline.nvim",
      -- optional = true,
      -- opts = function(_, opts)
        -- if (vim.g.colors_name or ""):find("catppuccin") then
          -- opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
        -- end
      -- end,
    -- },
  -- },
-- }
