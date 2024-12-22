-- lua/plugins/ui/lualine.lua
return {
  -- Status line plugin
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Dependency: nvim-web-devicons for icons
    event = "VeryLazy", -- Load lualine very early
    opts = function()
      -- Icons for diagnostics and git
      local icons = {
        diagnostics = {
          Error = " ",
          Warn = " ",
          Info = " ",
          Hint = " ",
        },
        git = {
          added = " ",
          modified = " ",
          removed = " ",
        },
      }

      return {
        options = {
          theme = "catppuccin", -- Use the Catppuccin theme
          globalstatus = vim.o.laststatus == 3, -- Use a global statusline (if laststatus is 3)
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "starter" }, -- Disabled for these filetypes
          },
        },
        sections = {
          lualine_a = { "mode" }, -- Display the current mode
          lualine_b = { "branch" }, -- Display the current git branch
          lualine_c = {
            -- Display diagnostics using the configured icons
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            -- Display the filetype icon
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            -- Display the file path relative to the working directory
            {
              function()
                local file = vim.fn.expand("%:.") -- Get the path relative to the buffer
                if file == "" then
                  return "No File"
                end
                local cwd = vim.fn.getcwd() -- Get the current working directory
                -- If the file path starts with the cwd, remove the cwd part
                if string.sub(file, 1, string.len(cwd)) == cwd then
                  file = string.sub(file, string.len(cwd) + 2)
                end
                return file
              end,
            },
          },
          lualine_x = {
            -- Display snacks status (if snacks plugin is loaded)
            {
              function()
                return require("snacks").status()
              end,
              cond = function()
                return package.loaded["snacks"]
              end,
            },
            -- Display noice.nvim command status (if noice plugin is loaded)
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = { fg = "#ff9e64" }, -- Customize the color
            },
            -- Display noice.nvim mode status (if noice plugin is loaded)
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
              color = { fg = "#ff9e64" }, -- Customize the color
            },
            -- Display DAP (Debug Adapter Protocol) status (if dap plugin is loaded)
            {
              function()
                return " " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
            },
            -- Display pending updates (if lazy.nvim plugin is loaded)
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
            },
            -- Display git diff information
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              -- Get git diff info from gitsigns plugin (if available)
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } }, -- Display progress
            { "location", padding = { left = 0, right = 1 } }, -- Display the cursor location
          },
          lualine_z = {
            -- Display the current time
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "neo-tree", "lazy", "fzf" }, -- Enable extensions for these plugins
      }
    end,
  },
}
