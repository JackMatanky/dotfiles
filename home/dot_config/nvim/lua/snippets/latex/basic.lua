-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/basic_ops.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Fractions, roots, e^, \text, spacing, &=, \tag, and common functions.
-- ----------------------------------------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

return {
  -- // → \frac{...}{...}
  s({
    trig = "//",
    name = "Fraction",
    dscr = "\\frac{...}{...}",
    wordTrig = false,
  }, fmta("\\frac{<>}{<>}<>", { i(1), i(2), i(0) }), { condition = U.in_math }),

  -- ([0-9nmk]*)sq → \sqrt[...]{}   or sq → \sqrt{}
  s(
    {
      trig = "([0-9nmk]*)sq",
      regTrig = true,
      wordTrig = false,
      name = "sqrt / indexed sqrt",
    },
    fmta("\\sqrt<> { <> }<>", {
      ---Return optional index for \sqrt based on capture.
      f(function(_, snip)
        local k = snip.captures[1]
        return (k ~= "" and "[" .. k .. "]") or ""
      end),
      i(1),
      i(0),
    }),
    { condition = U.in_math }
  ),

  -- e^{...}
  s({
    trig = "ee",
    name = "e^{...}",
    dscr = "Natural exponential",
    wordTrig = false,
  }, fmta("e^{ <> }<>", { i(1), i(0) }), { condition = U.in_math }),

  -- \text{...}
  s({
    trig = "text",
    name = "\\text{...}",
    dscr = "Insert \\text{}",
    wordTrig = true,
  }, fmta("\\text{ <> }<>", { i(1), i(0) }), { condition = U.in_math }),

  -- == → &= (quick align helper)
  s({
    trig = "==",
    name = "&= (align eq)",
    dscr = "Convert == to &=",
    wordTrig = false,
  }, t("&="), { condition = U.in_math }),

  -- \tag{...}
  s(
    {
      trig = "tag",
      name = "\\tag{...}",
      dscr = "Equation tag",
      wordTrig = true,
    },
    fmta("\\tag{ <> }<>", { i(1, "1"), i(0) }),
    { condition = U.in_math }
  ),

  -- quad/qquad → \quad / \qquad
  s(
    { trig = "(qquad|quad)", regTrig = true, name = "spacing command" },
    fmta(
      "\\<> <>",
      { f(function(_, snip)
        return snip.captures[1]
      end), i(0) }
    ),
    { condition = U.in_math }
  ),

  -- Add backslash before common functions: det|exp|log|ln
  s(
    {
      trig = "([^\\\\])(det|exp|log|ln)",
      regTrig = true,
      name = "backslash common funcs",
    },
    fmta("<>\\<>", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    { condition = U.in_math }
  ),
}
