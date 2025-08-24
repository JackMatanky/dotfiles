-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/greek_letters.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Obsidian-style Greek letters:
--   - "@x" → \alpha, \beta, \gamma, ...
--   - ":x" → variant if available (e,t,r,f → \varepsilon,\vartheta,\varrho,\varphi)
-- Supports: [a-gik-pr-uxzDFGLOPSTUX]
-- ----------------------------------------------------------------------------

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

-- Base map mirrors your Obsidian mapping
local greek_map = {
  a = "alpha",
  b = "beta",
  g = "gamma",
  G = "Gamma",
  d = "delta",
  D = "Delta",
  e = "epsilon",
  z = "zeta",
  t = "theta",
  T = "Theta",
  i = "iota",
  k = "kappa",
  l = "lambda",
  L = "Lambda",
  m = "mu",
  n = "nu",
  x = "xi",
  X = "Xi",
  r = "rho",
  s = "sigma",
  S = "Sigma",
  u = "upsilon",
  U = "Upsilon",
  f = "phi",
  F = "Phi",
  p = "psi",
  P = "Psi",
  c = "chi",
  o = "omega",
  O = "Omega",
}

-- Only these support \var- variants in standard LaTeX
local variant = { e = true, t = true, r = true, f = true }

---Build the LaTeX command for a Greek letter trigger.
---@param _ any
---@param snip table LuaSnip state; uses captures: [1]=prefix, [2]=key.
---@return string cmd The LaTeX command (\alpha, \varphi, etc.).
local function build(_, snip)
  local prefix = snip.captures[1]
  local key = snip.captures[2]
  local base = greek_map[key]
  if not base then
    return ""
  end
  if prefix == ":" and variant[key] then
    return "\\var" .. base
  else
    return "\\" .. base
  end
end

return {
  -- Regex trigger: ([@:])([a-gik-pr-uxzDFGLOPSTUX])
  s({
    trig = "([@:])([a-gik-pr-uxzDFGLOPSTUX])",
    regTrig = true,
    wordTrig = false,
    name = "Greek letter (@/:)",
    dscr = "Insert Greek letter using @ (e.g., @a → \\alpha) or variant with : (e.g., :f → \\varphi → ϕ)",
  }, fmta("<><>", { f(build), i(0) }), { condition = U.in_math }),
}
