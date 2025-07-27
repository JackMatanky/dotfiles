-- ----------------------------------------------------------------------------
-- Filename: ~/dotfiles/nvim/lua/snippets/markdown/latex.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: This file contains all the LaTeX-specific snippets. It is
--              designed to be a simple 'content' file, where each snippet
--              is defined without any conditional logic. The responsibility
--              of applying conditions is handled by the main loader file,
--              which 'requires' this file.
-- ----------------------------------------------------------------------------

local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Math Mode & Environments
  s({ trig = "mk", name = "Inline Math", dscr = "Creates an inline LaTeX math block (`$...$`)." }, { t("$"), i(0), t("$") }),
  s({ trig = "dm", name = "Display Math", dscr = "Creates a display LaTeX math block (`$$...$$`)." }, fmt([[\n$$\n{}\n$$\n]], { i(0) })),
  s({ trig = "beg", name = "Begin/End Environment", dscr = "Creates a LaTeX environment (`\\begin{...}`)." },
    fmt([[\begin{{}}\n{}\n\end{{}}]], { i(1, "align"), i(0) })
  ),

  -- Fractions & Roots
  s({ trig = "//", name = "Fraction", dscr = "Inserts a LaTeX fraction (`\\frac{numerator}{denominator}`)." },
    fmt("\\frac{{{}}}{{{}}}", { i(1), i(2) })
  ),
  s({ trig = "sq", name = "Square Root", dscr = "Inserts a square root (`\\sqrt{...}`)." },
    fmt("\\sqrt{{{}}}", { i(1) })
  ),
  s({ trig = "nrt", name = "Nth Root", dscr = "Inserts an nth-root with an index (`\\sqrt[n]{...}`)." },
    fmt("\\sqrt[{}]{{{}}}", { i(1, "n"), i(2) })
  ),

  -- Common Functions & Operators
  s({ trig = "log", name = "Log Function", dscr = "Inserts the log function (`\\log`)." }, t("\\log")),
  s({ trig = "ln", name = "Natural Log", dscr = "Inserts the natural log function (`\\ln`)." }, t("\\ln")),
  s({ trig = "det", name = "Determinant", dscr = "Inserts the determinant function (`\\det`)." }, t("\\det")),
  s({ trig = "exp", name = "Exponent Function", dscr = "Inserts the exponential function (`e^{...}`)." }, fmt("e^{{{}}}", { i(0) })),
  s({ trig = "ee", name = "Natural Exponent", dscr = "Shortcut for the exponential function (`e^{...}`)." }, fmt("e^{{{}}}", { i(0) })),

  -- Sums, Products, and Integrals
  s({ trig = "sum", name = "Summation", dscr = "Inserts a summation with limits (`\\sum`)." },
    fmt("\\sum_{{{}}}^{{{}}}", { i(1, "i=1"), i(2, "n") })
  ),
  s({ trig = "prod", name = "Product", dscr = "Inserts a product with limits (`\\prod`)." },
    fmt("\\prod_{{{}}}^{{{}}}", { i(1, "i=1"), i(2, "n") })
  ),
  s({ trig = "int", name = "Integral", dscr = "Inserts an integral with limits (`\\int`)." },
    fmt("\\int_{{{}}}^{{{}}}", { i(1, "a"), i(2, "b") })
  ),

  -- Greek Letters (Example Set)
  s({ trig = "@a", name = "Alpha", dscr = "Inserts the Greek letter alpha (`\\alpha`)." }, t("\\alpha ")),
  s({ trig = "@b", name = "Beta", dscr = "Inserts the Greek letter beta (`\\beta`)." }, t("\\beta ")),
  s({ trig = "@g", name = "Gamma", dscr = "Inserts the Greek letter gamma (`\\gamma`)." }, t("\\gamma ")),
  s({ trig = "@G", name = "Gamma (Uppercase)", dscr = "Inserts the uppercase Greek letter Gamma (`\\Gamma`)." }, t("\\Gamma ")),
  s({ trig = "@d", name = "Delta", dscr = "Inserts the Greek letter delta (`\\delta`)." }, t("\\delta ")),
  s({ trig = "@D", name = "Delta (Uppercase)", dscr = "Inserts the uppercase Greek letter Delta (`\\Delta`)." }, t("\\Delta ")),
  s({ trig = "@e", name = "Epsilon", dscr = "Inserts the Greek letter epsilon (`\\epsilon`)." }, t("\\epsilon ")),

  -- Superscript & Subscript
  s({ trig = "^", name = "Superscript", dscr = "Creates a superscript (`^{...}`)." }, fmt("^{{{}}}", { i(0) })),
  s({ trig = "_", name = "Subscript", dscr = "Creates a subscript (`_{...}`)." }, fmt("_{{{}}}", { i(0) })),

  -- Brackets & Delimiters
  s({ trig = "lr(", name = "Left/Right Parentheses", dscr = "Inserts auto-sizing parentheses (`\\left( ... \\right)`)." }, fmt("\\left( {} \\right)", { i(0) })),
  s({ trig = "lr[", name = "Left/Right Brackets", dscr = "Inserts auto-sizing square brackets (`\\left[ ... \\right]`)." }, fmt("\\left[ {} \\right]", { i(0) })),
  s({ trig = "lr{", name = "Left/Right Curly Braces", dscr = "Inserts auto-sizing curly braces (`\\left\\{ ... \\right\\}`)." }, fmt("\\left\\{ {} \\right\\}", { i(0) })),
  s({ trig = "lr|", name = "Left/Right Vertical Bar", dscr = "Inserts auto-sizing vertical bars for absolute value (`\\left| ... \\right|`)." }, fmt("\\left| {} \\right|", { i(0) })),

  -- Matrices
  s({ trig = "pmat", name = "Matrix (Parentheses)", dscr = "Creates a matrix enclosed in parentheses (`pmatrix`)." },
    fmt([[\begin{pmatrix}\n{}\n\end{pmatrix}]], { i(1, "a & b \\\\ c & d") })
  ),
  s({ trig = "bmat", name = "Matrix (Brackets)", dscr = "Creates a matrix enclosed in square brackets (`bmatrix`)." },
    fmt([[\begin{bmatrix}\n{}\n\end{bmatrix}]], { i(1, "a & b \\\\ c & d") })
  ),
  s({
    trig = "2mat",
    name = "2x2 Matrix",
    dscr = "Creates a 2x2 pmatrix with placeholders."
  }, fmt([[\begin{pmatrix}\n{} & {} \\ \n{} & {}\n\end{pmatrix}]], { i(1, "a"), i(2, "b"), i(3, "c"), i(4, "d") })),
}
