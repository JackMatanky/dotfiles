-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/matrices_arrays.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Matrix environments and N×M matrix generator, plus identity matrix.
-- ----------------------------------------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local r = ls.restore_node
local d = ls.dynamic_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

---Generate an N×M grid of nodes for a matrix body.
---@param _ any Unused.
---@param snip table LuaSnip state; uses captures [1]=rows, [2]=cols, [3]=type letter or empty.
---@return table node A snippet_node containing the grid with & and \\ separators.
local function gen_matrix_grid(_, snip)
  local rows = tonumber(snip.captures[1]) or 2
  local cols = tonumber(snip.captures[2]) or 2
  local nodes = {}
  local ins = 1
  for rrow = 1, rows do
    for ccol = 1, cols do
      table.insert(nodes, r(ins, string.format("%dx%d", rrow, ccol), i(1)))
      ins = ins + 1
      if ccol < cols then
        table.insert(nodes, t(" & "))
      end
    end
    if rrow < rows then
      table.insert(nodes, t({ " \\\\", "" }))
    end
  end
  return sn(nil, nodes)
end

return {
  -- Plain matrix (display)
  s(
    { trig = "matrix", name = "matrix (display)" },
    fmta(
      [[
      \begin{matrix}
        <>
      \end{matrix}
    ]],
      { i(1) }
    ),
    { condition = U.in_display_math }
  ),

  -- (p|b|v|B|V)mat → corresponding *matrix (display)
  s(
    { trig = "(p|b|v|B|V)mat", regTrig = true, name = "Xmatrix (display)" },
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
    { condition = U.in_display_math }
  ),

  -- (\d)(\d)([p|b|B|v|V]?)mat → N×M matrix generator (display)
  s(
    {
      trig = "(\\d)(\\d)([pbBvV]?)mat",
      trigEngine = "ecma",
      regTrig = true,
      name = "N×M matrix (display)",
      dscr = "Generate N×M body inside optional Xmatrix",
    },
    fmta(
      [[
      \begin{<>}
        <>
      \end{<>}
    ]],
      {
        f(function(_, snip)
          local tletter = snip.captures[3] or ""
          local env = (tletter ~= "" and (tletter .. "matrix") or "matrix")
          return env
        end),
        d(1, gen_matrix_grid),
        f(function(_, snip)
          local tletter = snip.captures[3] or ""
          local env = (tletter ~= "" and (tletter .. "matrix") or "matrix")
          return env
        end),
      }
    ),
    { condition = U.in_display_math }
  ),

  -- Identity matrix: idenN → pmatrix with identity entries (display)
  s(
    {
      trig = "iden(\\d)",
      trigEngine = "ecma",
      regTrig = true,
      name = "Identity matrix (N×N)",
      dscr = "pmatrix with 1 on diagonal",
    },
    f(function(_, snip)
      ---Build a pmatrix identity of size N.
      ---@param _ any
      ---@param snip table LuaSnip state; uses captures[1] as size.
      ---@return string tex A LaTeX pmatrix body string.
      local n = tonumber(snip.captures[1]) or 2
      local rows = {}
      for rrow = 1, n do
        local cols = {}
        for ccol = 1, n do
          table.insert(cols, (rrow == ccol) and "1" or "0")
        end
        table.insert(rows, table.concat(cols, " & "))
      end
      local body = table.concat(rows, " \\\\\n")
      return string.format(
        [[
\begin{pmatrix}
%s
\end{pmatrix]],
        body
      )
    end),
    { condition = U.in_display_math }
  ),
}
