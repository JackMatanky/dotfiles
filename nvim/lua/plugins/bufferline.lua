-- --------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/plugins/bufferline.lua
--  LazyVim Docs: https://www.lazyvim.org/plugins/ui#bufferlinenvim
--  Bufferline Docs: https://github.com/akinsho/bufferline.nvim
--  Description: This powers LazyVim's fancy-looking tab bar,
--               providing filetype icons, close buttons, and navigation.
-- --------------------------------------------------------------------

return {
  "akinsho/bufferline.nvim", -- Plugin name
  event = "VeryLazy", -- Load when needed (LazyVim optimization)

  -- Keybindings for buffer navigation and management
  keys = {
    -- Pin/unpin a buffer
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    -- Close all unpinned buffers
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    -- Close buffers to the right
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    -- Close buffers to the left
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    -- Move buffer to the left
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
    -- Move buffer to the right
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    -- Switch to previous buffer
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    -- Switch to next buffer
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
  },

  -- Bufferline settings
  opts = {
    options = {
      -- Custom close behavior (using Snacks.bufdelete for buffer management)
      close_command = function(n) Snacks.bufdelete(n) end,
      right_mouse_command = function(n) Snacks.bufdelete(n) end,

      -- Show diagnostics (LSP warnings/errors) in the bufferline
      diagnostics = "nvim_lsp",

      -- Hide the bufferline when only one buffer is open
      always_show_bufferline = false,

      -- Custom diagnostics indicator using LazyVim’s icon set
      diagnostics_indicator = function(_, _, diag)
        local icons = LazyVim.config.icons.diagnostics
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,

      -- Configure offsets for sidebars like Neo-tree
      offsets = {
        {
          filetype = "neo-tree", -- Offset space for Neo-tree file explorer
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
        {
          filetype = "snacks_layout_box", -- Custom layout component
        },
      },

      -- Set filetype icons using LazyVim's icon config
      ---@param opts bufferline.IconFetcherOpts
      get_element_icon = function(opts)
        return LazyVim.config.icons.ft[opts.filetype]
      end,
    },
  },

  -- Configuration function to properly set up Bufferline
  config = function(_, opts)
    require("bufferline").setup(opts) -- Load Bufferline with provided options

    -- Auto-fix Bufferline when restoring a session
    vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline) -- Prevent errors in case Bufferline is not loaded
        end)
      end,
    })
  end,
}
