-- ----------------------------------------------------------------------------
-- Filename: ~/dotfiles/nvim/lua/snippets/markdown.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: This is the main loader for all Markdown-related snippets.
--              It follows a standard pattern of requiring and combining
--              snippet tables from different files.
-- ----------------------------------------------------------------------------

-- Load snippets from their respective files.
local base_snippets = require('snippets.markdown.base')
local latex_snippets = require('snippets.markdown.latex')

-- Combine the tables into one for Luasnip to use.
for _, snip in ipairs(latex_snippets) do
  table.insert(base_snippets, snip)
end

return base_snippets
