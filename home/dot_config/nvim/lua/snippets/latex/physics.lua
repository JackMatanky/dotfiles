-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/physics.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Snippets for common physics notation.
-- ----------------------------------------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local U = require("snippets.latex.utils")

return {
  s(
    { trig = "kbt", name = "k_B T", dscr = "Boltzmann constant k_B * T" },
    t("k_{B}T"),
    { condition = U.in_math }
  ),
  s(
    { trig = "msun", name = "M_\\odot", dscr = "Solar mass (M☉)" },
    t("M_{\\odot}"),
    { condition = U.in_math }
  ),
}
