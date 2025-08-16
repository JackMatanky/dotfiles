-- ----------------------------------------------------------------------------
-- Filename: ~/dotfiles/nvim/lua/snippets/markdown.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: This is the main loader for all Markdown-related snippets.
--              It follows a standard pattern of requiring and combining
--              snippet tables from different files.
-- ----------------------------------------------------------------------------

-- Helper function to extend tables
local function extend(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end

-- Load snippets from their respective files.
local all_snippets = require('snippets.markdown.base')
local latex_snippets = require('snippets.markdown.latex')

-- Combine the tables into one for Luasnip to use.
for _, snip in ipairs(latex_snippets) do
  table.insert(all_snippets, snip)
end

-- Load and extend with converted Zed snippets
local converted_snippets = require("snippets.markdown.converted_from_zed")
extend(all_snippets, converted_snippets)

return all_snippets
