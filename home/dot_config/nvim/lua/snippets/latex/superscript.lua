-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/superscript.lua
-- Docs:     https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Superscript helpers usable in math. Includes generic ^{...},
--              explicit text superscripts, and common shorthands.
-- ----------------------------------------------------------------------------
local ls    = require("luasnip")
local s     = ls.snippet
local i     = ls.insert_node
local t     = ls.text_node
local fmta  = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

return {
  s(
    { trig = "^", wordTrig = false, name = "superscript", dscr = "^{...}" },
    fmta([[^{<>}<>]], { i(1), i(0) }),
    { condition = U.in_math }
  ),

  s(
    { trig = "sp", name = "superscript (tabstop)", dscr = "^{...} with tabstop" },
    fmta([[^{<>}]], { i(1) }),
    { condition = U.in_math }
  ),

  s(
    { trig = "stp", name = "text superscript", dscr = "^{\\text{...}}" },
    fmta([[^\text{<>}]], { i(1) }),
    { condition = U.in_math }
  ),

  s(
    { trig = "sr", name = "square", dscr = "^{2}" },
    t("^{2}"),
    { condition = U.in_math }
  ),

  s(
    { trig = "cb", name = "cube", dscr = "^{3}" },
    t("^{3}"),
    { condition = U.in_math }
  ),

  s(
    { trig = "invs", name = "inverse", dscr = "^{-1}" },
    t("^{-1}"),
    { condition = U.in_math }
  ),

  s(
    { trig = "conj", name = "conjugate superscript", dscr = "^{*}" },
    t("^{*}"),
    { condition = U.in_math }
  ),

  s(
    { trig = "++", name = "superscript +", dscr = "^{+}" },
    t("^{+}"),
    { condition = U.in_math }
  ),

  s(
    { trig = "--", name = "superscript -", dscr = "^{-}" },
    t("^{-}"),
    { condition = U.in_math }
  ),
}
