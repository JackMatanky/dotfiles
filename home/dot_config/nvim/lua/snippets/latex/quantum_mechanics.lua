-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/quantum.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Snippets for quantum mechanics (bras, kets, etc.).
-- ----------------------------------------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmta = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

return {
  s(
    { trig = "dag", name = "^{\\dagger}", dscr = "Dagger (†)" },
    t("^{\\dagger}"),
    { condition = U.in_math }
  ),
  s(
    { trig = "o+", name = "\\oplus", dscr = "Direct sum (⊕)" },
    t("\\oplus "),
    { condition = U.in_math }
  ),
  s(
    { trig = "ox", name = "\\otimes", dscr = "Tensor product (⊗)" },
    t("\\otimes "),
    { condition = U.in_math, priority = -1 }
  ),
  s(
    { trig = "bra", name = "\\bra{..}", dscr = "Bra vector ⟨...|" },
    fmta("\\bra{ <> } <>", { i(1), i(0) }),
    { condition = U.in_math }
  ),
  s(
    { trig = "ket", name = "\\ket{..}", dscr = "Ket vector |...⟩" },
    fmta("\\ket{ <> } <>", { i(1), i(0) }),
    { condition = U.in_math }
  ),
  s(
    { trig = "brk", name = "\\braket{ a | b }", dscr = "Braket ⟨a|b⟩" },
    fmta("\\braket{ <> | <> } <>", { i(1), i(2), i(0) }),
    { condition = U.in_math }
  ),
  s(
    {
      trig = "outer",
      name = "outer product",
      dscr = "Outer product |ψ⟩⟨ψ|",
    },
    fmta("\\ket{ <> } \\bra{ <> } <>", { i(1, "\\psi"), i(1), i(0) }),
    { condition = U.in_math }
  ),
}
