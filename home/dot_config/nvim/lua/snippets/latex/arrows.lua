-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/arrows.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Snippets for various arrows.
-- ----------------------------------------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local fmta = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

return {
  s(
    {
      trig = "(<=>|<->|->|!->|nto|!>|=>|=<)",
      regTrig = true,
      name = "arrows",
      dscr = "Arrows (⇔, →, mapsto, ⇒, etc.)",
    },
    fmta("<>", {
      require("luasnip").function_node(function(_, snip)
        local map = {
          ["<=>"] = "\\Leftrightarrow",
          ["<->"] = "\\leftrightarrow",
          ["->"] = "\\to",
          ["!->"] = "\\not\\to",
          ["nto"] = "\\not\\to",
          ["!>"] = "\\mapsto",
          ["=>"] = "\\implies",
          ["=<"] = "\\impliedby",
        }
        return map[snip.captures[1]] or ""
      end),
    }),
    { condition = U.in_math }
  ),
}
