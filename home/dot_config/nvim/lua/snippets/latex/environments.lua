-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/environments.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Math environments. Regex triggers at start of line; combined
--              starred/non-starred via an insert node for the asterisk.
--              Expands only in DISPLAY math.
-- ----------------------------------------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

---Return first capture from a regex-triggered snippet.
---@param _ any
---@param snip table LuaSnip snippet state (contains .captures)
---@return string env The captured environment base name or ""
local function cap1(_, snip)
  return snip.captures[1] or ""
end

local display_only = { condition = U.in_display_math }

return {
  -- Generic begin/end with CHOICE list (any math)
  s(
    {
      trig = "beg",
      name = "Begin/End (choice)",
      dscr = "Generic environment in math",
    },
    fmta(
      [[
      \begin{<>}
        <>
      \end{<>}
    ]],
      {
        c(1, {
          t("align"),
          t("align*"),
          t("equation"),
          t("equation*"),
          t("gather"),
          t("gather*"),
          t("cases"),
          t("split"),
          t("pmatrix"),
          t("bmatrix"),
          t("Bmatrix"),
          t("vmatrix"),
          t("Vmatrix"),
          t("matrix"),
          t("array"),
        }),
        i(2),
        rep(1),
      }
    ),
    { condition = U.in_math }
  ),

  -- equation / equation*
  s(
    {
      trig = "^%s*(equation)%*?$",
      regTrig = true,
      wordTrig = false,
      name = "equation",
      dscr = "equation or equation* (SOL, display only)",
    },
    fmta(
      [[
      \begin{<><>}
        <>
      \end{<><>}
    ]],
      { f(cap1), i(1, ""), i(2), f(cap1), rep(1) }
    ),
    display_only
  ),

  -- align / align*
  s(
    {
      trig = "^%s*(align)%*?$",
      regTrig = true,
      wordTrig = false,
      name = "align",
      dscr = "align or align* (SOL, display only)",
    },
    fmta(
      [[
      \begin{<><>}
        <>
      \end{<><>}
    ]],
      { f(cap1), i(1, ""), i(2), f(cap1), rep(1) }
    ),
    display_only
  ),

  -- gather / gather*
  s(
    {
      trig = "^%s*(gather)%*?$",
      regTrig = true,
      wordTrig = false,
      name = "gather",
      dscr = "gather or gather* (SOL, display only)",
    },
    fmta(
      [[
      \begin{<><>}
        <>
      \end{<><>}
    ]],
      { f(cap1), i(1, ""), i(2), f(cap1), rep(1) }
    ),
    display_only
  ),

  -- cases
  s(
    { trig = "^%s*cases$", regTrig = true, wordTrig = false, name = "cases" },
    fmta(
      [[
      \begin{cases}
        <>
      \end{cases}
    ]],
      { i(1) }
    ),
    display_only
  ),

  -- split
  s(
    { trig = "^%s*split$", regTrig = true, wordTrig = false, name = "split" },
    fmta(
      [[
      \begin{split}
        <>
      \end{split}
    ]],
      { i(1) }
    ),
    display_only
  ),

  -- (p|b|B|v|V)matrix
  s(
    {
      trig = "^%s*(p|b|B|v|V)matrix$",
      regTrig = true,
      wordTrig = false,
      name = "Xmatrix",
    },
    fmta(
      [[
      \begin{<>matrix}
        <>
      \end{<>matrix}
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    ),
    display_only
  ),

  -- matrix
  s(
    { trig = "^%s*matrix$", regTrig = true, wordTrig = false, name = "matrix" },
    fmta(
      [[
      \begin{matrix}
        <>
      \end{matrix}
    ]],
      { i(1) }
    ),
    display_only
  ),

  -- array (user supplies column spec)
  s(
    { trig = "^%s*array$", regTrig = true, wordTrig = false, name = "array" },
    fmta(
      [[
      \begin{array}{<>}
        <>
      \end{array}
    ]],
      { i(1, "c"), i(2) }
    ),
    display_only
  ),
}
