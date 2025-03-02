-- --------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/plugins/markdown_preview.lua
--  LazyVim Docs: https://www.lazyvim.org/extras/lang/markdown#markdown-previewnvim
--  Markdown Preview Docs: https://github.com/iamcco/markdown-preview.nvim
-- --------------------------------------------------------------------

return {
  "iamcco/markdown-preview.nvim",
  enabled = true,
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = function()
    require("lazy").load({ plugins = { "markdown-preview.nvim" } })
    vim.fn["mkdp#util#install"]()
  end,
  keys = {
    {
      "<leader>cp",
      ft = "markdown",
      "<cmd>MarkdownPreviewToggle<cr>",
      desc = "Markdown Preview",
    },
  },
  config = function()
    vim.cmd([[do FileType]])
  end,
}
