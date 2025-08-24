-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/sets.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Snippets for set theory operators and number systems.
-- ----------------------------------------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

return {
  -- Set operators
  s(
    { trig = "sand", name = "\\cap", dscr = "Intersection (∩)" },
    t("\\cap"),
    { condition = U.in_math }
  ),
  s(
    { trig = "capp", name = "\\cap", dscr = "Intersection (∩)" },
    t("\\cap"),
    { condition = U.in_math }
  ),
  s(
    { trig = "sor", name = "\\cup", dscr = "Union (∪)" },
    t("\\cup"),
    { condition = U.in_math }
  ),
  s(
    { trig = "cupp", name = "\\cup", dscr = "Union (∪)" },
    t("\\cup"),
    { condition = U.in_math }
  ),
  s(
    { trig = "inn", name = "\\in", dscr = "Element of (∈)" },
    t("\\in"),
    { condition = U.in_math }
  ),
  s(
    { trig = "ninn", name = "\\notin", dscr = "Not an element of (∉)" },
    t("\\notin"),
    { condition = U.in_math }
  ),
  s(
    { trig = "notin", name = "\\notin", dscr = "Not an element of (∉)" },
    t("\\notin"),
    { condition = U.in_math }
  ),
  s(
    { trig = "sless", name = "\\setminus", dscr = "Set difference (∖)" },
    t("\\setminus"),
    { condition = U.in_math }
  ),
  s(
    { trig = "setmin", name = "\\setminus", dscr = "Set difference (∖)" },
    t("\\setminus"),
    { condition = U.in_math }
  ),
  s(
    {
      trig = "\\\\\\\\",
      name = "\\setminus (slash triple)",
      dscr = "Set difference (∖)",
      regTrig = true,
    },
    t("\\setminus"),
    { condition = U.in_math }
  ),
  s(
    { trig = "subeq", name = "\\subseteq", dscr = "Subset or equal to (⊆)" },
    t("\\subseteq"),
    { condition = U.in_math }
  ),
  s(
    { trig = "sub=", name = "\\subseteq", dscr = "Subset or equal to (⊆)" },
    t("\\subseteq"),
    { condition = U.in_math }
  ),
  s(
    { trig = "supeq", name = "\\supseteq", dscr = "Superset or equal to (⊇)" },
    t("\\supseteq"),
    { condition = U.in_math }
  ),
  s(
    { trig = "sup=", name = "\\supseteq", dscr = "Superset or equal to (⊇)" },
    t("\\supseteq"),
    { condition = U.in_math }
  ),
  s(
    { trig = "eset", name = "\\emptyset", dscr = "Empty set (∅)" },
    t("\\emptyset"),
    { condition = U.in_math }
  ),
  s(
    { trig = "sempty", name = "\\emptyset", dscr = "Empty set (∅)" },
    t("\\emptyset"),
    { condition = U.in_math }
  ),

  -- Set literal: \{ ... \}
  s(
    {
      trig = "set",
      name = "\\{ ... \\}",
      dscr = "Set literal { ... }",
      priority = -1,
    },
    fmta("\\{ <> \\}<>", { i(1), i(0) }),
    { condition = U.in_math }
  ),

  -- Big cap / cup
  s(
    {
      trig = "b(cap|cup)",
      regTrig = true,
      name = "\\bigcap / \\bigcup",
      dscr = "N-ary intersection (⋂) / union (⋃)",
    },
    fmta("\\big<>_{ <> \\in <> }^{ <> } <>", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1, "i"),
      i(2, "I"),
      i(3, "N"),
      i(0),
    }),
    { condition = U.in_math }
  ),

  -- Number systems and common calligraphic: CC, FF, ..., LL, HH
  s(
    {
      trig = "(CC|FF|II|NN|QQ|RR|ZZ|LL|HH)",
      regTrig = true,
      name = "number systems",
      dscr = "Number systems (ℂ, ℕ, ℝ, etc.)",
    },
    fmta("\\<>{<>}<>", {
      f(function(_, snip)
        local dbl = snip.captures[1]
        local letter = dbl:sub(1, 1)
        local bb = {
          C = true,
          F = true,
          I = true,
          N = true,
          Q = true,
          R = true,
          Z = true,
        }
        return (bb[letter] and "mathbb" or "mathcal")
      end),
      f(function(_, snip)
        return (snip.captures[1]):sub(1, 1)
      end),
      i(0),
    }),
    { condition = U.in_math }
  ),
}
