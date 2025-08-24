-- ----------------------------------------------------------------------------
--  Filename: ~/.config/nvim/lua/plugins/comment_divider.lua
--  Comment Divider: https://github.com/fangjunzhou/comment-divider.nvim
--  Description: Plugin config with visual mode aware wrappers
-- ----------------------------------------------------------------------------

-- Load enhanced divider logic with visual-mode support.
-- Uses selection or prompt to insert titled lines/boxes.
-- local divider = require("config.utils.comment_divider")

return {
  "fangjunzhou/comment-divider.nvim",
  opts = {
    -- Whether to enable developer debug info.
    debug = true,
    -- The length of divide line and box.
    commentLength = 64,
    defaultConfig = {
      lineStart = "/*",
      lineSeperator = "-",
      lineEnd = "*/",
    },
    languageConfig = {
      bash = {
        lineStart = "#",
        lineSeperator = "-",
        lineEnd = "#",
      },
      Brewfile = {
        lineStart = "#",
        lineSeperator = "-",
        lineEnd = "#",
      },
      cpp = {
        lineStart = "/*",
        lineSeperator = "-",
        lineEnd = "*/",
      },
      html = {
        lineStart = "<!--",
        lineSeperator = "-",
        lineEnd = "-->",
      },
      javascript = {
        lineStart = "/*",
        lineSeperator = "-",
        lineEnd = "*/",
      },
      justile = {
        lineStart = "#",
        lineSeperator = "-",
        lineEnd = "#",
      },
      lua = {
        lineStart = "--",
        lineSeperator = "-",
        lineEnd = "--",
      },
      nushell = {
        lineStart = "#",
        lineSeperator = "-",
        lineEnd = "#",
      },
      python = {
        lineStart = "#",
        lineSeperator = "-",
        lineEnd = "#",
      },
      toml = {
        lineStart = "#",
        lineSeperator = "-",
        lineEnd = "#",
      },
      sh = {
        lineStart = "#",
        lineSeperator = "-",
        lineEnd = "#",
      },
    },
  },
  keys = {
    -- CommentDividerLine to create a comment divide line.
    -- If the comment is empty, a solid line will be added.
    {
      "<leader>cDl",
      function()
        print("[Divider] Triggered insert_divider_line()")
        require("config.utils.comment_divider").insert_divider_line()
      end,
      desc = "Insert comment divider line",
      mode = { "n", "v" },
    },
    {
      "<leader>cDb",
      function()
        print("[Divider] Triggered insert_divider_box()")
        require("config.utils.comment_divider").insert_divider_box()
      end,
      desc = "Insert comment divider box",
      mode = { "n", "v" },
    },
    -- CommentDividerFiletype to check the file type of current buffer.
    {
      "<leader>cDf",
      "<cmd>CommentDividerFiletype<CR>",
      desc = "Show comment filetype config",
    },
    -- CommentDividerConfigInfo to get the current config.
    {
      "<leader>cDc",
      "<cmd>CommentDividerConfigInfo<CR>",
      desc = "Show comment config info",
    },
  },
}
