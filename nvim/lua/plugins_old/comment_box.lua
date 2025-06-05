-- ----------------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/plugins/comment_box.lua
--  Comment Box: https://github.com/LudoPinelli/comment-box.nvim
--  Description: Clarify and beautify your comments and plain text files using
--               boxes and lines. Integrates line- and block-style comment dividers.
-- ----------------------------------------------------------------------------

return {
  "LudoPinelli/comment-box.nvim",
  opts = {
    -- Comment style options:
    --   - "line":  Always use line comments
    --   - "block": Always use block comments
    --   - "auto":  Use block for multi-line selection, line otherwise
    comment_style = "auto",
    doc_width = 80, -- Target width for overall layout (used for centering)
    box_width = 64, -- Target width for box-based dividers
    line_width = 64, -- Target width for line-based dividers

    -- Box border characters
    -- borders = {
    --   top = "─",
    --   bottom = "─",
    --   left = "│",
    --   right = "│",
    --   top_left = "╭",
    --   top_right = "╮",
    --   bottom_left = "╰",
    --   bottom_right = "╯",
    -- },
    -- Divider line characters
    -- lines = {
    --   line = "─",
    --   line_start = "─",
    --   line_end = "─",
    --   title_left = "─",
    --   title_right = "─",
    -- },
    -- Box spacing configuration
    outer_blank_lines_above = true, -- Insert blank line before box
    outer_blank_lines_below = false, -- Do not insert blank line after box
    inner_blank_lines = false, -- No padding inside the box
    -- Line spacing configuration
    line_blank_line_above = true, -- Insert blank line before divider
    line_blank_line_below = false, -- Do not insert blank line after divider
  },

  -- Key mappings using comment-box with visual/line-based inferred text
  keys = {
    {
      "<leader>cDd",
      "<Cmd>CBlabox<CR>",
      desc = "Insert file description comment box",
      mode = { "n", "v" },
    },
    {
      "<leader>cDb",
      -- "<Cmd>CBlcbox20<CR>",
      "<Cmd>CBlcbox<CR>",
      desc = "Insert left-aligned, horizontally enclosed comment box",
      mode = { "n", "v" },
    },
    {
      "<leader>cDl",
      "<Cmd>CBlcline<CR>",
      desc = "Insert left-aligned comment divider line (64 chars)",
      mode = { "n", "v" },
    },
    {
      "<leader>cDx",
      "<Cmd>CBd<CR>",
      desc = "Remove comment box or line",
      mode = { "n", "v" },
    },
  },
}
