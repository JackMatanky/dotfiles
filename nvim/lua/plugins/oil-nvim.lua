-- Filename: ~/dotfiles/nvim/lua/plugins/oil-nvim.lua
--
-- GitHub Repo: https://github.com/stevearc/oil.nvim
return {
  "stevearc/oil.nvim",
  config = function()
    local oil = require("oil")
    oil.setup()
    vim.keymap.set("n", "-", oil.toggle_float, {})
  end,
}
