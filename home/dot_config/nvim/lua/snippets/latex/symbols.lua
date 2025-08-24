-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/symbols.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: General symbols, dots, and accents.
-- ----------------------------------------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local fmta = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

return {
  -- Common Symbols
  s(
    {
      trig = "(ooo|%+%-|%-%+|xx|nabl|del|para)",
      regTrig = true,
      name = "common symbols",
      dscr = "Common symbols (∞, ±, ×, ∇, ∥)",
    },
    fmta("<>", {
      require("luasnip").function_node(function(_, snip)
        local m = {
          ["ooo"] = "\\infty",
          ["+-"] = "\\pm",
          ["-+"] = "\\mp",
          ["xx"] = "\\times",
          ["nabl"] = "\\nabla",
          ["del"] = "\\nabla",
          ["para"] = "\\parallel",
        }
        return m[snip.captures[1]] or ""
      end),
    }),
    { condition = U.in_math }
  ),

  -- Dots and center dot
  s(
    { trig = "...", name = "\\dots", dscr = "Ellipsis (...)" },
    t("\\dots"),
    { condition = U.in_math }
  ),
  s(
    { trig = ",d", name = "\\dot{...}", dscr = "Dot accent (˙)" },
    fmta(
      "\\dot{ <> }<>",
      { require("luasnip").insert_node(1), require("luasnip").insert_node(0) }
    ),
    { condition = U.in_math }
  ),
  s(
    {
      trig = ",D",
      name = "\\ddot{...}",
      dscr = "Double dot accent (¨)",
      priority = 2,
    },
    fmta(
      "\\ddot{ <> }<>",
      { require("luasnip").insert_node(1), require("luasnip").insert_node(0) }
    ),
    { condition = U.in_math }
  ),
  s(
    {
      trig = "**",
      name = "\\cdot (inline)",
      dscr = "Center dot (·)",
      wordTrig = false,
    },
    t("\\cdot"),
    { condition = U.in_math }
  ),
  s(
    {
      trig = "*",
      name = "\\cdot (block)",
      dscr = "Center dot (·)",
      wordTrig = true,
    },
    t("\\cdot"),
    { condition = U.in_math }
  ),
  s(
    { trig = "cdot", name = "\\cdot", dscr = "Center dot (·)", priority = 0 },
    t("\\cdot"),
    { condition = U.in_math }
  ),
  s(
    {
      trig = "ccdot",
      name = "\\cdots",
      dscr = "Center ellipsis (⋯)",
      priority = 0,
    },
    t("\\cdots"),
    { condition = U.in_math }
  ),
}
