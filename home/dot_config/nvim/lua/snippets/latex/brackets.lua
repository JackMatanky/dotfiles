-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/brackets_norms.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Angles, absolute value, norms, floor/ceiling, generic enclosures,
--              and selection enclosures.
-- ----------------------------------------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

return {
  s(
    { trig = "ang", name = "\\langle...\\rangle", wordTrig = true },
    fmta("\\langle <> \\rangle <>", { i(1), i(0) }),
    { condition = U.in_math }
  ),

  s(
    { trig = "mod", name = "|...|", wordTrig = true },
    fmta("|<>| <>", { i(1), i(0) }),
    { condition = U.in_math }
  ),

  s(
    { trig = "(n|N)orm", regTrig = true, wordTrig = true, name = "norms" },
    fmta("\\l<> <> \\r<> <>", {
      -- 'n' -> vert, 'N' -> Vert
      require("luasnip").function_node(function(_, snip)
        return snip.captures[1] == "N" and "Vert" or "vert"
      end),
      i(1),
      require("luasnip").function_node(function(_, snip)
        return snip.captures[1] == "N" and "Vert" or "vert"
      end),
      i(0),
    }),
    { condition = U.in_math }
  ),

  s(
    {
      trig = "(lr)?(ceil|floor)",
      regTrig = true,
      wordTrig = true,
      name = "ceil/floor",
    },
    fmta("<> <> <>", {
      require("luasnip").function_node(function(_, snip)
        local big = snip.captures[1]
        local op = snip.captures[2]
        local L = "\\l" .. op
        if big == "lr" then
          L = "\\left " .. L
        end
        return L
      end),
      i(1),
      require("luasnip").function_node(function(_, snip)
        local big = snip.captures[1]
        local op = snip.captures[2]
        local R = "\\r" .. op
        if big == "lr" then
          R = "\\right " .. R
        end
        return R
      end),
    }),
    { condition = U.in_math }
  ),

  -- Generic left/right enclosures for (, [, {
  s(
    {
      trig = "(lr)?([%(%[%{])",
      regTrig = true,
      wordTrig = true,
      name = "left-right enclosures",
    },
    fmta("<>$0<> <>", {
      require("luasnip").function_node(function(_, snip)
        local big = snip.captures[1]
        local left = snip.captures[2]
        local map = { ["("] = ")", ["["] = "]", ["{"] = "}" }
        local ltex = (big == "lr") and ("\\left " .. left .. " ") or left
        local rtex = (big == "lr") and ("\\right " .. map[left]) or map[left]
        return ltex
      end),
      require("luasnip").function_node(function(_, snip)
        local big = snip.captures[1]
        local left = snip.captures[2]
        local map = { ["("] = ")", ["["] = "]", ["{"] = "}" }
        local rtex = (big == "lr") and ("\\right " .. map[left]) or map[left]
        return rtex
      end),
      i(0),
    }),
    { condition = U.in_math }
  ),

  -- \left| ... \right|
  s(
    { trig = "lr|", name = "\\left| ... \\right|" },
    fmta("\\left| <> \\right| <>", { i(1), i(0) }),
    { condition = U.in_math }
  ),

  -- \left< ... \right>
  s(
    { trig = "lra", name = "\\left< ... \\right>" },
    fmta("\\left< <> \\right> <>", { i(1), i(0) }),
    { condition = U.in_math }
  ),

  -- Selection enclosures
  s(
    { trig = "(", name = "(selection)", dscr = "Wrap selection with (...)" },
    fmta("( <>)", { d(1, U.get_visual) }),
    { condition = U.in_math }
  ),
  s(
    { trig = "[", name = "[selection]", dscr = "Wrap selection with [...]" },
    fmta("[ <> ]", { d(1, U.get_visual) }),
    { condition = U.in_math }
  ),
  s(
    { trig = "{", name = "{selection}", dscr = "Wrap selection with {...}" },
    fmta("{ <> }", { d(1, U.get_visual) }),
    { condition = U.in_math }
  ),
  s(
    { trig = "|", name = "|selection|", dscr = "Wrap selection with |...|" },
    fmta("|<>|", { d(1, U.get_visual) }),
    { condition = U.in_math }
  ),
}
