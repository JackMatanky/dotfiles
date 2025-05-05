-- ----------------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/plugins/comment_divider.lua
--  Comment Divider: https://github.com/fangjunzhou/comment-divider.nvim
--  Description   : Plugin config for comment dividers
-- ----------------------------------------------------------------------------

return {
  "fangjunzhou/comment-divider.nvim",
  opts = {
    -- Whether to enable developer debug info.
    debug = false,
    -- The length of divide line and box.
    commentLength = 64,
    defaultConfig = {
      lineStart = "/*",
      lineSeperator = "-",
      lineEnd = "*/",
    },
    languageConfig = {
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
    },
  },
  keys = {
    -- CommentDividerLine to create a comment divide line.
    -- If the comment is empty, a solid line will be added.
    {
      "<leader>cdl",
      "<cmd>CommentDividerLine<CR>",
      desc = "Insert comment divider line",
    },
    -- CommentDividerBox to create a comment divide box.
    {
      "<leader>cdb",
      "<cmd>CommentDividerBox<CR>",
      desc = "Insert comment divider box",
    },
    -- CommentDividerFiletype to check the file type of current buffer.
    {
      "<leader>cdf",
      "<cmd>CommentDividerFiletype<CR>",
      desc = "Show comment filetype config",
    },
    -- CommentDividerConfigInfo to get the current config.
    {
      "<leader>cdc",
      "<cmd>CommentDividerConfigInfo<CR>",
      desc = "Show comment config info",
    },
  },
}
