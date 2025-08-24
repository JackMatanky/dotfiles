-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/logic.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Snippets for logical operators and text.
-- ----------------------------------------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

return {
  -- Logic words as spaced text
  s(
    {
      trig = "(AND|OR)",
      regTrig = true,
      name = "logic text",
      dscr = "Text-based AND/OR",
    },
    fmta("\\quad \\text{ <> } \\quad", {
      f(function(_, snip)
        return (snip.captures[1] or ""):lower()
      end),
    }),
    { condition = U.in_math }
  ),

  -- Logic symbols
  s(
    { trig = "lneg", name = "\\neg", dscr = "Negation (¬)" },
    t("\\neg"),
    { condition = U.in_math }
  ),
  s(
    { trig = "landd", name = "\\land", dscr = "Conjunction / AND (∧)" },
    t("\\land"),
    { condition = U.in_math }
  ),
  s(
    { trig = "lorr", name = "\\lor", dscr = "Disjunction / OR (∨)" },
    t("\\lor"),
    { condition = U.in_math }
  ),
  s(
    { trig = "lsome", name = "\\exists", dscr = "Existential quantifier (∃)" },
    t("\\exists"),
    { condition = U.in_math }
  ),
  s(
    {
      trig = "lnone",
      name = "\\nexists",
      dscr = "Negated existential quantifier (∄)",
    },
    t("\\nexists"),
    { condition = U.in_math }
  ),
  s(
    { trig = "lall", name = "\\forall", dscr = "Universal quantifier (∀)" },
    t("\\forall"),
    { condition = U.in_math }
  ),
  s(
    {
      trig = "lnotall",
      name = "\\not\\forall",
      dscr = "Negated universal quantifier",
    },
    t("\\not \\forall"),
    { condition = U.in_math }
  ),
}
