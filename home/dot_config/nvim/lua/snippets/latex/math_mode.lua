-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/math_mode.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Inline and display math. Guarded to expand only OUTSIDE math.
-- ----------------------------------------------------------------------------

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

local U = require("snippets.latex.utils")

return {
  -- Inline math: only when not already inside math
  s(
    { trig = "mk", name = "Inline math", dscr = "Insert $...$ outside math" },
    fmta("$<>$ <>", { i(1), i(0) }),
    { condition = U.not_in_math }
  ),

  -- Display math: only when not already inside math
  s(
    {
      trig = "dm",
      name = "Display math",
      dscr = "Insert $$...$$ block outside math",
    },
    fmta(
      [[
      $$
        <>
      $$
      ]],
      { i(1) }
    ),
    { condition = U.not_in_math }
  ),
}
