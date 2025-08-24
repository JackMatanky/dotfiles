-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/subscript.lua
-- Docs:     https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Subscript helpers. Generic _{...}, text subscript, and a simple
--              a1 -> a_{1} pattern (Lua pattern based).
-- ----------------------------------------------------------------------------
local ls    = require("luasnip")
local s     = ls.snippet
local sn    = ls.snippet_node
local i     = ls.insert_node
local f     = ls.function_node
local t     = ls.text_node
local fmta  = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

return {
  s(
    { trig = "_", wordTrig = false, name = "subscript", dscr = "_{...}" },
    fmta([[_{<>}<>]], { i(1), i(0) }),
    { condition = U.in_math }
  ),

  s(
    { trig = "sc", name = "subscript (tabstop)", dscr = "_{...} with tabstop" },
    fmta([[_{<>}]], { i(1) }),
    { condition = U.in_math }
  ),

  s(
    { trig = "sts", name = "text subscript", dscr = "_\\text{...}" },
    fmta([[_\text{<>}]], { i(1) }),
    { condition = U.in_math }
  ),

  -- Simple auto: a1 -> a_{1} or {x}1 -> {x}_{1}
  s(
    { trig = "([%a]%b{}?)(%d%d?)$", regTrig = true, name = "auto subscript", dscr = "a1 -> a_{1}" },
    f(function(_, snip)
      local base = snip.captures[1]
      local digs = snip.captures[2]
      return string.format("%s_{%s}", base, digs)
    end),
    { condition = U.in_math }
  ),
}
