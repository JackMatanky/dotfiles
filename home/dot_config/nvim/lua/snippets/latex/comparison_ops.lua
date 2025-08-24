-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/comparison_ops.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Snippets for comparison operators.
-- ----------------------------------------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local fmta = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

return {
  s(
    {
      trig = "(===|!=|>=|<=|!>=|!<=|!<|!>|nle|nge|>>|<<|simm|sim=|simeq|prop)",
      regTrig = true,
      name = "comparison ops",
      dscr = "Comparison operators (≡, ≠, ≥, ≤, etc.)",
    },
    fmta("<>", {
      require("luasnip").function_node(function(_, snip)
        local raw = snip.captures[1]
        local map = {
          ["==="] = "\\equiv",
          ["!="] = "\\neq",
          [">="] = "\\geq",
          ["<="] = "\\leq",
          [">>"] = "\\gg",
          ["<<"] = "\\ll",
          ["simeq"] = "\\simeq",
          ["sim="] = "\\simeq",
          ["simm"] = "\\sim",
          ["prop"] = "\\propto",
          ["!<"] = "\\not<",
          ["!>"] = "\\not>",
          ["!<="] = "\\not\\leq",
          ["!>="] = "\\not\\geq",
          ["nle"] = "\\not\\leq",
          ["nge"] = "\\not\\geq",
        }
        return map[raw] or ""
      end),
    }),
    { condition = U.in_math }
  ),
}
