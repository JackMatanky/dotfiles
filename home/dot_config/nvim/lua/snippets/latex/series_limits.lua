-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/series_limits.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Sequences, sums, products, limits (display and inline variants).
-- ----------------------------------------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

return {
  -- Sequence notation (r?seq)
  s(
    { trig = "(r)?seq", regTrig = true, name = "sequence notation" },
    fmta("<> <>", {
      f(function(_, snip)
        local sub_r = snip.captures[1]
        local seq = "{\\langle <>_{<>} \\rangle}_{<> = <>}^{<>}"
        local base = seq:gsub("<>", "%s") -- placeholder to be filled by fmta nodes next
        -- We return nothing here; actual body constructed via fmta nodes below.
        return ""
      end),
      fmta("{\\langle <><>{<>} \\rangle}_{<> = <>}^{<>}<>", {
        i(1, "x"),
        t(""),
        i(2, "n"),
        rep(2),
        i(3, "1"),
        i(4, "\\infty"),
        f(function(_, snip)
          return (snip.captures[1] ~= nil) and " \\subseteq \\mathbb{R}" or ""
        end),
      }),
    }),
    { condition = U.in_math }
  ),

  -- Sums (plain / nested / function / set-indexed)
  s(
    { trig = "(f|n|s|st)?sum", regTrig = true, name = "sigma sums" },
    f(function(_, snip)
      ---Return a sum template per type: f, n, s, st or default.
      ---@param _ any
      ---@param snip table LuaSnip state; uses captures[1].
      ---@return string tex
      local tp = snip.captures[1]
      if tp == "f" then
        return "\\sum_{k = 1}^{n} f(k) "
      elseif tp == "n" then
        return "\\sum_{i = 1}^{m} \\sum_{j = 1}^{n} "
      elseif tp == "s" then
        return "\\sum_{k = 1}^{n} x_{k} "
      elseif tp == "st" then
        return "\\sum_{s \\in C} "
      else
        return "\\sum_{k = 1}^{n} "
      end
    end),
    { condition = U.in_math }
  ),

  -- Product (plain)
  s(
    { trig = "prod", name = "product notation" },
    fmta(
      "\\prod_{ <> = <> }^{ <> } <>",
      { i(1, "i"), i(2, "1"), i(3, "N"), i(0) }
    ),
    { condition = U.in_math }
  ),

  -- Limits (display-style)
  s(
    { trig = "(f|s)?lim", regTrig = true, name = "limit (display-ish)" },
    f(function(_, snip)
      ---Return a limit template: default, function, or sequence.
      ---@param _ any
      ---@param snip table LuaSnip state; uses captures[1].
      ---@return string tex
      local tp = snip.captures[1]
      if tp == "f" then
        return "\\lim_{x \\to c} f(x) "
      elseif tp == "s" then
        return "\\lim_{n \\to \\infty} x_{n} "
      else
        return "\\lim_{n \\to \\infty} "
      end
    end),
    { condition = U.in_math }
  ),

  -- Limit superior / inferior
  s(
    { trig = "lm(inf|sup)", regTrig = true, name = "lim inf/sup" },
    fmta("\\lim<>_{ <> \\to <> } <>", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1, "n"),
      i(2, "\\infty"),
      i(0),
    }),
    { condition = U.in_math }
  ),
}
