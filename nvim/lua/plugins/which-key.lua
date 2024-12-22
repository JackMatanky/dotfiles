-- Filename: ~/dotfiles/nvim/lua/plugins/which-key.lua
--
-- https://github.com/folke/which-key.nvim
return {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup({
      -- Only popup if I don't remember the key
      delay = 1500,
    })
  end,
}
