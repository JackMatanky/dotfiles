-- --------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/plugins/bufferline.lua
--  LazyVim Docs: https://www.lazyvim.org/plugins/ui#lualinenvim
--  Lualine Docs: https://github.com/nvim-lualine/lualine.nvim
--  Description: A blazing fast and easy to configure Neovim statusline
--               written in Lua.
-- --------------------------------------------------------------------

-- Other separator symbols:
-- █
--   
--   
--   
--   
--   

return {
  "nvim-lualine/lualine.nvim", -- Plugin: Statusline enhancement
  event = "VeryLazy", -- Load only when needed (LazyVim optimization)

  -- Setup statusline behavior before Lualine loads
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus

    -- If Neovim is launched with a file, set an empty statusline
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = " "
    else
      -- Hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,

  -- Configure Lualine settings
  opts = function()
    -- PERF: Avoid unnecessary require calls
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    local icons = LazyVim.config.icons

    -- Restore last statusline setting after initialization
    vim.o.laststatus = vim.g.lualine_laststatus

    -- Define Lualine configuration
    local opts = {
      options = {
        theme = "auto", -- Automatically adapt to colorscheme
        globalstatus = vim.o.laststatus == 3, -- Use global statusline if enabled
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } }, -- Disable for UI components
      },

      -- Define Lualine sections
      sections = {
        lualine_a = { "mode" }, -- Show current mode (NORMAL, INSERT, etc.)
        lualine_b = { "branch" }, -- Show current Git branch

        -- Central section (file info, diagnostics, path)
        lualine_c = {
          LazyVim.lualine.root_dir(), -- Show root directory
          {
            "diagnostics", -- Display LSP diagnostics with custom icons
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } }, -- Show filetype icon
          { LazyVim.lualine.pretty_path() }, -- Display file path in a user-friendly way
        },

        -- Right section (profiling, Noice, debugging, Git)
        lualine_x = {
          Snacks.profiler.status(), -- Show profiling status (if enabled)

          -- Noice status (command, mode)
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = function() return { fg = Snacks.util.color("Statement") } end,
          },
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color("Constant") } end,
          },

          -- Debug Adapter Protocol (DAP) status
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return { fg = Snacks.util.color("Debug") } end,
          },

          -- Lazy plugin updates status
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return { fg = Snacks.util.color("Special") } end,
          },

          -- Git diff status (added, modified, removed)
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
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

        -- Bottom-right: Progress and cursor location
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } }, -- Show progress percentage
          { "location", padding = { left = 0, right = 1 } }, -- Show cursor position
        },

        -- Bottom-right: Clock display
        lualine_z = {
          function()
            return " " .. os.date("%R") -- Show current time (HH:MM)
          end,
        },
      },

      -- Enable extensions for these plugins
      extensions = { "neo-tree", "lazy", "fzf" },
    }

    -- 🔹 Extra: Add Trouble.nvim symbols (if available)
    -- If trouble.nvim is loaded, add its symbols to Lualine
    if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })

      table.insert(opts.sections.lualine_c, {
        symbols and symbols.get,
        cond = function()
          return vim.b.trouble_lualine ~= false and symbols.has()
        end,
      })
    end

    return opts
  end,
}
