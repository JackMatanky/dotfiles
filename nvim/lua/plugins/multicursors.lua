-- --------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/plugins/multicursors.lua
--  multicursors.nvim Docs: https://github.com/smoka7/multicursors.nvim
--  Description: The Multicursor Plugin for Neovim extends the native Neovim
--               text editing capabilities, providing a more intuitive
--               way to edit repetitive text with multiple selections.
-- --------------------------------------------------------------------

return {
  "smoka7/multicursors.nvim",
  event = "VeryLazy",
  dependencies = { "smoka7/hydra.nvim" }, -- Dependency for managing multi-cursor hints
  opts = {
    DEBUG_MODE = false, -- Enable debugging mode (set to `true` for debugging logs)
    create_commands = true, -- Create `Multicursor` user commands for ease of use
    updatetime = 50, -- Time (ms) before selections update in insert mode (see `:help updatetime`)
    nowait = true, -- Prevent delay in keybinding execution (see `:help :map-nowait`)

    -- Multi-Cursor Mode Keys (similar to VS Code)
    mode_keys = {
      append = "a", -- Enter append mode
      change = "c", -- Enter change mode
      extend = "e", -- Extend selection
      insert = "i", -- Enter insert mode
    },

    -- Configurations for displaying hints
    hint_config = {
      float_opts = { border = "none" }, -- Hide borders around the hint popups
      position = "bottom", -- Display hints at the bottom of the window
    },

    -- Generate hints for different modes (normal, insert, extend)
    generate_hints = {
      normal = true, -- Enable hints in normal mode
      insert = true, -- Enable hints in insert mode
      extend = true, -- Enable hints in extend mode
      config = {
        column_count = nil, -- Auto-adjust the number of hint columns based on window size
        max_hint_length = 25, -- Max width of each hint column
      },
    },
  },

  -- Keybindings for Multicursor (VS Code/Zed Style)
  keys = {
    {
      "<C-n>",
      function()
        require("multicursors").start()
      end,
      desc = "Start Multi-Cursor Mode",
      mode = { "n", "v" },
    },
    {
      "<C-k>",
      function()
        require("multicursors").remove_cursor()
      end,
      desc = "Remove Last Multi-Cursor",
      mode = { "n", "v" },
    },
    {
      "<C-l>",
      function()
        require("multicursors").select_next_cursor()
      end,
      desc = "Select Next Multi-Cursor",
      mode = { "n", "v" },
    },
    {
      "<C-j>",
      function()
        require("multicursors").select_prev_cursor()
      end,
      desc = "Select Previous Multi-Cursor",
      mode = { "n", "v" },
    },
    {
      "<C-d>",
      function()
        require("multicursors").select_next_occurrence()
      end,
      desc = "Add Next Occurrence",
      mode = { "n", "v" },
    },
    {
      "<A-n>",
      function()
        require("multicursors").select_all_occurrences()
      end,
      desc = "Select All Occurrences",
      mode = { "n", "v" },
    },
  },
}
