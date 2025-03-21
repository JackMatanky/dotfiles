-- ----------------------------------------------------------------------
-- Filename:  ~/dotfiles/nvim/lua/plugins/flash.lua
-- LazyVim Docs:  https://www.lazyvim.org/plugins/editor#flashnvim
-- Flash Docs:  https://github.com/folke/flash.nvim
-- Description:  Flash is a plugin for Neovim that provides a fast and
--               intuitive way to search and jump to text in your code.
-- --------------------------------------------------------------------

return {
  "folke/flash.nvim",
  enabled = true,
  event = "VeryLazy",
  vscode = true,
  ---@type Flash.Config
  opts = {},

  -- stylua: ignore
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function() require("flash").jump() end,
      desc = "Flash"
    },
    {
      "S",
      mode = { "n", "o", "x" },
      function() require("flash").treesitter() end,
      desc = "Flash Treesitter"
    },
    {
      "r",
      mode = "o",
      function() require("flash").remote() end,
      desc = "Remote Flash"
    },
    {
      "R",
      mode = { "o", "x" },
      function() require("flash").treesitter_search() end,
      desc = "Treesitter Search"
    },
    {
      "<c-s>",
      mode = { "c" },
      function() require("flash").toggle() end,
      desc = "Toggle Flash Search"
    },
  },
}
