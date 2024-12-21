return {
  {
    'nvim-lualine/lualine.nvim', -- The main plugin: lualine.nvim for the statusline
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Dependency: nvim-web-devicons for icons
    config = function()
      -- Configure lualine after it's loaded
      require('lualine').setup {
        options = {
          icons_enabled = true,    -- Enable icons (requires nvim-web-devicons)
          component_separators = '|', -- Separator between components within a section
          section_separators = '',   -- Separator between sections
        },
        sections = {
          lualine_x = { -- Right section of the statusline
            {
              -- Display the current Vim mode (e.g., NORMAL, INSERT) using noice.nvim
              require("noice").api.statusline.mode.get,
              cond = require("noice").api.statusline.mode.has, -- Only show if noice.nvim's mode is available
              color = { fg = "#ff9e64" }, -- Set the foreground color
            },
            {
              -- Display the current command (if any) using noice.nvim
              require("noice").api.status.command.get,
              cond = require("noice").api.status.command.has, -- Only show if noice.nvim's command is available
              color = { fg = "#ff9e64" }, -- Set the foreground color
            },
          },
          lualine_a = { -- Left section of the statusline
            {
              'buffers', -- Show the list of open buffers
            }
          }
        }
      }
    end
  }
}
