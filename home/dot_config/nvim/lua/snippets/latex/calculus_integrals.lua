-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/calculus_integrals.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Derivatives and integrals (with common patterns).
-- ----------------------------------------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

return {
  -- Partial derivative (generic)
  s(
    { trig = "par", name = "partial derivative" },
    fmta(
      "\\frac{\\partial <>}{\\partial <>} <>",
      { i(1, "y"), i(2, "x"), i(0) }
    ),
    { condition = U.in_math }
  ),

  -- paXY → \frac{\partial X}{\partial Y}
  s(
    { trig = "pa([A-Za-z])([A-Za-z])", regTrig = true, name = "partial paXY" },
    fmta("\\frac{ \\partial <> }{ \\partial <> } ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    { condition = U.in_math }
  ),

  -- d/dt
  s(
    { trig = "ddt", name = "d/dt" },
    fmta("\\frac{d}{dt} ", {}),
    { condition = U.in_math }
  ),

  -- ensure backslash before \int if missing
  s(
    {
      trig = "([^\\\\])int",
      regTrig = true,
      name = "auto-backslash int",
      priority = -1,
    },
    fmta(
      "<>\\int",
      { f(function(_, snip)
        return snip.captures[1]
      end) }
    ),
    { condition = U.in_math }
  ),

  -- \int ... d*
  s(
    { trig = "\\int", regTrig = true, name = "\\int ... d x" },
    fmta("\\int <> \\, d<> <>", { i(1), i(2, "x"), i(0) }),
    { condition = U.in_math }
  ),

  -- definite integral
  s(
    { trig = "dint", name = "\\int_{a}^{b} ..." },
    fmta(
      "\\int_{ <> }^{ <> } <> \\, d<> <>",
      { i(1, "0"), i(2, "1"), i(3), i(4, "x"), i(0) }
    ),
    { condition = U.in_math }
  ),

  -- o|i|ii int → \oint, \int, \iint prefix
  s(
    { trig = "(o|i|ii)int", regTrig = true, name = "prefixed int" },
    fmta(
      "\\<>int",
      { f(function(_, snip)
        return snip.captures[1]
      end) }
    ),
    { condition = U.in_math }
  ),

  -- 0→∞ integral
  s(
    { trig = "oinf", name = "integral 0 to inf" },
    fmta("\\int_{0}^{\\infty} <> \\, d<> <>", { i(1), i(2, "x"), i(0) }),
    { condition = U.in_math }
  ),

  -- -∞→∞ integral
  s(
    { trig = "infi", name = "integral -inf to inf" },
    fmta("\\int_{-\\infty}^{\\infty} <> \\, d<> <>", { i(1), i(2, "x"), i(0) }),
    { condition = U.in_math }
  ),
}
