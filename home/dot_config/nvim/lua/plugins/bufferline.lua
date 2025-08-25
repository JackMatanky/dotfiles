-- ----------------------------------------------------------------------------
--  Filename: ~/.config/nvim/lua/plugins/bufferline.lua
--  LazyVim: https://www.lazyvim.org/plugins/ui#bufferlinenvim
--  Bufferline: https://github.com/akinsho/bufferline.nvim
--  Description: Tab-like buffer line for Neovim with Catppuccin theming
-- ----------------------------------------------------------------------------

return {
  "akinsho/bufferline.nvim",
  opts = function(_, opts)
    -- Apply Catppuccin theme to bufferline if Catppuccin is active
    if (vim.g.colors_name or ""):find("catppuccin") then
      opts.highlights = require("catppuccin.groups.integrations.bufferline").get_theme()
    end
    return opts
  end,
}
