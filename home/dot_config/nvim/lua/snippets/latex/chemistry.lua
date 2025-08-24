-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/chemistry.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Snippets for chemistry (pu/ce commands, isotopes).
-- ----------------------------------------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmta = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

return {
  s(
    { trig = "pu", name = "\\pu{...}", dscr = "Physical unit wrapper" },
    fmta("\\pu{ <> }", { i(1) }),
    { condition = U.in_math }
  ),
  s(
    { trig = "cee", name = "\\ce{...}", dscr = "Chemical equation wrapper" },
    fmta("\\ce{ <> }", { i(1) }),
    { condition = U.in_math }
  ),
  s(
    { trig = "he4", name = "He-4 isotope", dscr = "Helium-4 isotope" },
    t("{}^{4}_{2}He "),
    { condition = U.in_math }
  ),
  s(
    { trig = "he3", name = "He-3 isotope", dscr = "Helium-3 isotope" },
    t("{}^{3}_{2}He "),
    { condition = U.in_math }
  ),
  s(
    {
      trig = "iso",
      name = "generic isotope",
      dscr = "Generic isotope notation",
    },
    fmta("{}^{ <> }_{ <> }<>", { i(1, "4"), i(2, "2"), i(3, "He") }),
    { condition = U.in_math }
  ),
}
