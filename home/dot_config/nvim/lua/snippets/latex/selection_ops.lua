-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/selection_ops.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Visual selection wrappers (under/over/cancel/box/sqrt) and
--              selection → gather/align (smart) with operator alignment logic.
-- ----------------------------------------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local t = ls.text_node
local fmta = require("luasnip.extras.fmt").fmta
local U = require("snippets.latex.utils")

---Replace newlines in a string with LaTeX line breaks.
---@param str string|nil Raw selection content.
---@return string processed Selection with `\\` inserted at newlines.
local function nl_to_breaks(str)
  return (str or ""):gsub("\n", " \\\\\n")
end

---Basic &= alignment: replace "=" with "&=" then add LaTeX newline breaks.
---@param str string|nil Raw selection content.
---@return string processed Processed selection for align environment.
local function align_basic(str)
  return nl_to_breaks((str or ""):gsub("=", "&="))
end

local basic_ops = { "=", ">", "<" }
local latex_ops =
  { "\\geq", "\\iff", "\\impliedby", "\\implies", "\\in", "\\leq", "\\neq" }
local special_ops = { "\\int", "\\prod", "\\sum" }

---Find the first operator occurrence in a line from a known list.
---@param line string A single math line.
---@return integer|nil idx Byte index of operator start (1-based) or nil.
---@return string|nil op The operator found or nil.
local function find_first_operator(line)
  local first_idx, first_op = math.huge, nil
  for _, op in ipairs(latex_ops) do
    local i1 = line:find(op, 1, true)
    if i1 and i1 < first_idx then
      first_idx, first_op = i1, op
    end
  end
  for _, op in ipairs(basic_ops) do
    local i1 = line:find(op, 1, true)
    if i1 and i1 < first_idx then
      first_idx, first_op = i1, op
    end
  end
  if first_op then
    return first_idx, first_op
  end
  return nil, nil
end

---Heuristically determine if position `pos` sits within an argument of a special operator.
---Scans brace depth after the last occurrence of \int, \prod, or \sum.
---@param line string The input line.
---@param pos integer Position to test (1-based byte index).
---@return boolean within True if pos is inside a still-open {...} group.
local function is_within_special(line, pos)
  for _, sop in ipairs(special_ops) do
    local last = line:match(".*()" .. sop) -- byte index AFTER last match
    if last then
      local depth = 0
      for idx = last, #line do
        local ch = line:sub(idx, idx)
        if ch == "{" then
          depth = depth + 1
        elseif ch == "}" then
          depth = depth - 1
          if depth < 0 then
            depth = 0
          end
        end
        if idx >= pos then
          if depth > 0 then
            return true
          end
          break
        end
      end
    end
  end
  return false
end

---Strip leading/trailing $ or $$ fences from a math block.
---@param block string Dollar-delimited block (e.g., "$x=1$" or "$$...$$").
---@return string inner Content without surrounding dollars.
local function strip_dollars(block)
  local s1 = block:gsub("^%s*%$%$?%s*", "")
  s1 = s1:gsub("%s*%$%$?%s*$", "")
  return s1
end

---Split a math expression into lines by explicit '\\\\' or newlines.
---@param eqn string Math expression (no dollar fences).
---@return string[] lines Cleaned lines (no surrounding spaces).
local function split_equation_lines(eqn)
  local out = {}
  local tmp = eqn:gsub("%s*\\\\%s*", "\n")
  for line in tmp:gmatch("([^\n]+)") do
    local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
    if #trimmed > 0 then
      table.insert(out, trimmed)
    end
  end
  return out
end

---Insert an '&' before the first suitable operator on a line (if not inside special args).
---@param line string Math line.
---@return string aligned Line with alignment marker inserted, or unchanged.
local function add_alignment_markers(line)
  local idx = select(1, find_first_operator(line))
  if not idx then
    return line
  end
  if is_within_special(line, idx) then
    return line
  end
  return line:sub(1, idx - 1) .. "&" .. line:sub(idx)
end

---Process selection: find $...$ or $$...$$ blocks, align operators, and wrap in $$+align.
---@param sel string Raw selection text.
---@return table|nil node A snippet node (fmta result) or nil if no math blocks were found.
local function process_inline_or_block_math(sel)
  local equations = {}
  for dbl in sel:gmatch("%$%$.-%$%$") do
    table.insert(equations, dbl)
  end
  local remainder = sel:gsub("%$%$.-%$%$", "")
  for sgl in remainder:gmatch("%$.-%$") do
    table.insert(equations, sgl)
  end
  if #equations == 0 then
    return nil
  end

  local lines_out = {}
  for _, eq in ipairs(equations) do
    local inner = strip_dollars(eq)
    for _, ln in ipairs(split_equation_lines(inner)) do
      table.insert(lines_out, add_alignment_markers(ln))
    end
  end
  if #lines_out == 0 then
    return nil
  end

  local joined = table.concat(lines_out, " \\\\\n")
  return fmta(
    [[
    $$
    \begin{align}
      <>
    \end{align}
    $$
  ]],
    { t(joined) }
  )
end

---Dynamic node: wrap selection in a gather environment, converting newlines to line breaks.
---@param _ any
---@param snip table LuaSnip snippet state (uses env.SELECT_RAW).
---@return table node A snippet_node containing formatted gather environment.
local function wrap_gather(_, snip)
  local processed = nl_to_breaks(snip.env.SELECT_RAW or "")
  return sn(
    nil,
    fmta(
      [[
    \begin{gather}
      <>
    \end{gather}
  ]],
      { t(processed) }
    )
  )
end

---Dynamic node: smart align wrapper. If selection contains $...$/$$...$$, align inside align env.
---Otherwise, do basic &= conversion line-by-line and wrap in align.
---@param _ any
---@param snip table LuaSnip snippet state (uses env.SELECT_RAW).
---@return table node A snippet_node containing formatted align environment.
local function wrap_align_smart(_, snip)
  local sel = snip.env.SELECT_RAW or ""
  local advanced = process_inline_or_block_math(sel)
  if advanced then
    return sn(nil, advanced)
  end
  local processed = align_basic(sel)
  return sn(
    nil,
    fmta(
      [[
    \begin{align}
      <>
    \end{align}
  ]],
      { t(processed) }
    )
  )
end

return {
  -- Visual wrappers (math only)
  s(
    { trig = "U", name = "Underbrace (sel)", dscr = "underbrace selection" },
    fmta("\\underbrace{ <> }_{ <> }", { d(1, U.get_visual), i(2) }),
    { condition = U.in_math }
  ),
  s(
    { trig = "O", name = "Overbrace (sel)", dscr = "overbrace selection" },
    fmta("\\overbrace{ <> }^{ <> }", { d(1, U.get_visual), i(2) }),
    { condition = U.in_math }
  ),
  s(
    { trig = "B", name = "Underset (sel)", dscr = "underset selection" },
    fmta("\\underset{ <> }{ <> }", { i(1), d(2, U.get_visual) }),
    { condition = U.in_math }
  ),
  s(
    { trig = "K", name = "Cancelto (sel)", dscr = "cancelto selection" },
    fmta("\\cancelto{ <> }{ <> }", { i(1), d(2, U.get_visual) }),
    { condition = U.in_math }
  ),
  s(
    { trig = "C", name = "Cancel (sel)", dscr = "cancel selection" },
    fmta("\\cancel{ <> }", { d(1, U.get_visual) }),
    { condition = U.in_math }
  ),
  s(
    { trig = "Q", name = "Boxed (sel)", dscr = "boxed selection" },
    fmta("\\boxed{ <> }", { d(1, U.get_visual) }),
    { condition = U.in_math }
  ),
  s(
    { trig = "S", name = "Sqrt (sel)", dscr = "sqrt selection" },
    fmta("\\sqrt{ <> }", { d(1, U.get_visual) }),
    { condition = U.in_math }
  ),

  -- Selection → gather
  s(
    { trig = "G", name = "Gather (sel)", dscr = "selection → gather" },
    d(1, wrap_gather),
    { condition = U.in_math }
  ),

  -- Selection → align (smart)
  s(
    {
      trig = "A",
      name = "Align (sel, smart)",
      dscr = "selection → align (smart)",
    },
    d(1, wrap_align_smart),
    { condition = U.in_math }
  ),
}
