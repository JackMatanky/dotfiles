-- -----------------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/plugins/vscode.lua
--  Purpose : Plugins specifically enabled, disabled, or tweaked for VSCodium
-- -----------------------------------------------------------------------------

return {
  -- Disable plugins that conflict with VSCode UI
  { "folke/noice.nvim", enabled = false },
  { "rcarriga/nvim-notify", enabled = false },
  { "nvim-lualine/lualine.nvim", enabled = false },

  -- Use VSCode-friendly colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "macchiato",
      background = {
        light = "latte",
        dark = "macchiato",
      },
      transparent_background = true,
    },
  },

  -- Optional: Disable dashboard, command UI, etc.
  -- { "goolord/alpha-nvim", enabled = false },
  { "folke/persistence.nvim", enabled = false },
  { "stevearc/dressing.nvim", enabled = false },
}
