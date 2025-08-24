-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/markdown.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: This is the main loader for all Markdown-related snippets.
--              It follows a standard pattern of requiring and combining
--              snippet tables from different files, and extends Markdown
--              with LaTeX snippets so they work inside math in Markdown.
-- ----------------------------------------------------------------------------

-- Helper function to extend tables
local function extend(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end

-- 1) Ensure LaTeX snippets are registered (require your LaTeX loader once).
--    Adjust the module path to match your setup if different.
pcall(require, "snippets.latex") -- this should register all tex snippets

-- 2) Expose LaTeX snippet set to Markdown buffers.
--    Use the SAME key you used when calling ls.add_snippets for LaTeX.
--    If you registered under "tex" (common), keep "tex" here.
local ls = require("luasnip")
ls.filetype_extend("markdown", { "tex" })
-- Optionally also extend related markdown variants:
-- ls.filetype_extend("markdown.mdx", { "tex" })
-- ls.filetype_extend("markdown.pandoc", { "tex" })
-- ls.filetype_extend("quarto", { "tex" })
-- ls.filetype_extend("rmarkdown", { "tex" })

-- 3) Load your Markdown-specific snippets as usual.
local all_snippets = require("snippets.markdown.base")

return all_snippets
