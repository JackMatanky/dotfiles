-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex/utils.lua
-- Docs:     https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description:
--   Reusable helpers for LaTeX LuaSnip snippets, written in small,
--   injectable units. This module centralizes:
--     • Math/Environment detection (vimtex-aware, regex fallback)
--     • Visual-selection helpers
--     • Alignment helpers (operator-aware)
--     • Dynamic node factories (matrix, cases)
--     • Formatting helpers (env blocks, star choice)
--   Design:
--     - Shared regexes/patterns are defined once and reused.
--     - Longer behaviors are composed from smaller private helpers (M._.*).
-- ----------------------------------------------------------------------------

local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node
local r = ls.restore_node
local t = ls.text_node
local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta

local M = {}
M._ = {} -- private helpers (kept on the table for easy overriding)

-- ---------------------------------------------------------- --
--           Environment Groups & Prebuilt Patterns           --
-- ---------------------------------------------------------- --

--- Canonical groups of LaTeX environments we care about.
--- You can extend/trim these lists to match your workflow.
M.ENV_GROUPS = {
  display = {
    "align%**",
    "alignat%**",
    "gather%**",
    "equation%**",
    "multline%**",
    "flalign%**",
    "cases",
  },
  align_like = {
    "align%**",
    "alignat%**",
  },
}

--- Build an alternation regex "(foo|bar|baz)" from a list.
--- @param list string[]  list of patterns (already %-escaped if needed)
--- @return string pattern Alternation group, e.g. "(foo|bar)"
function M._.alt(list)
  return "(" .. table.concat(list or {}, "|") .. ")"
end

-- Precomputed, shared patterns
M._.PATTERN = {
  display_envs = M._.alt(M.ENV_GROUPS.display),
  align_envs = M._.alt(M.ENV_GROUPS.align_like),
}

-- ---------------------------------------------------------- --
--                 Math/environment Detection                 --
-- ---------------------------------------------------------- --

--- Use vimtex to test for math-zone, if available.
--- @return boolean|nil  true/false if vimtex answered, nil if unavailable
function M._.vimtex_in_math()
  local ok, res = pcall(function()
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
  end)
  if not ok then
    return nil
  end
  return res
end

--- Heuristic inline-math check using '$' parity on the current line.
--- @return boolean in_math  true if line suggests math (odd number of '$')
function M._.heuristic_in_math()
  local line = vim.api.nvim_get_current_line()
  local _, n = line:gsub("%$", "")
  return (n % 2) == 1
end

--- Scan backward and apply a predicate to each line until it returns non-nil.
--- @param predicate fun(line:string):any|nil   test to run per line
--- @param limit integer|nil                    max lines to scan (default: 250)
--- @return any|nil                             first non-nil predicate result
function M._.scan_back(predicate, limit)
  local row = (vim.api.nvim_win_get_cursor(0))[1]
  local start = row
  local stop = math.max(1, row - (limit or 250))
  for rrow = start, stop, -1 do
    local l = vim.api.nvim_buf_get_lines(0, rrow - 1, rrow, false)[1] or ""
    local res = predicate(l)
    if res ~= nil then
      return res
    end
  end
  return nil
end

--- Create a begin/end environment predicate for a given alternation pattern.
--- Returns a function(line) that yields true at begin, false at end, nil otherwise.
--- @param alt_pattern string e.g. "(align%**|gather%**|...)" (no braces)
--- @return fun(line:string):boolean|nil
function M._.make_env_bounds_predicate(alt_pattern)
  local begin_pat = "\\begin%s*{" .. alt_pattern .. "}"
  local end_pat = "\\end%s*{" .. alt_pattern .. "}"
  return function(line)
    if line:match(begin_pat) then
      return true
    end
    if line:match(end_pat) then
      return false
    end
    return nil
  end
end

-- Prebuilt predicates for display and align-like envs
M._.pred_display_bounds =
  M._.make_env_bounds_predicate(M._.PATTERN.display_envs)
M._.pred_align_bounds = M._.make_env_bounds_predicate(M._.PATTERN.align_envs)

--- Determine whether the cursor is inside LaTeX math mode.
--- Uses vimtex if available, else falls back to a '$'-parity heuristic.
--- @return boolean in_math
function M.in_math()
  local vtx = M._.vimtex_in_math()
  if vtx ~= nil then
    return vtx
  end
  return M._.heuristic_in_math()
end

--- Determine whether the cursor is inside a display math environment.
--- Uses: (1) If vimtex says "not in math", return false; (2) else scan for
--- begin/end of known display envs or \[...\].
--- @return boolean in_display
function M.in_display_math()
  local vtx = M._.vimtex_in_math()
  if vtx == false then
    return false
  end

  local hit = M._.scan_back(function(line)
    -- explicit envs
    local mark = M._.pred_display_bounds(line)
    if mark ~= nil then
      return mark
    end
    -- \[ ... \]
    if line:match("%\\%[") then
      return true
    end
    if line:match("%\\%]") then
      return false
    end
    return nil
  end, 250)

  return hit == true
end

--- Negation of M.in_math().
--- @return boolean not_in_math
function M.not_in_math()
  return not M.in_math()
end

--- Detect whether the cursor is in an align-like environment.
--- @return boolean in_align  true if inside align/align* or alignat/alignat*
function M.in_align()
  local hit = M._.scan_back(M._.pred_align_bounds, 250)
  return hit == true
end

-- ---------------------------------------------------------- --
--           Visual-selection & Simple Text Helpers           --
-- ---------------------------------------------------------- --

--- Return a snippet node holding VISUAL selection (when present) or an insert node.
--- LuaSnip populates `env.SELECT_RAW` for VISUAL expansions.
--- @param _ any        unused (LuaSnip API)
--- @param parent table parent snippet; expects `parent.snippet.env.SELECT_RAW`
--- @return luasnip.SnippetNode
function M.get_visual(_, parent)
  local sel = parent
      and parent.snippet
      and parent.snippet.env
      and parent.snippet.env.SELECT_RAW
    or ""
  if type(sel) == "string" and #sel > 0 then
    return sn(nil, t(sel))
  end
  return sn(nil, i(1))
end

--- Split a string into lines (keeps empty middle lines, trims trailing empties).
--- @param s string
--- @return string[] lines
function M.split_lines(s)
  if type(s) ~= "string" then
    return {}
  end
  local out = {}
  for line in (s .. "\n"):gmatch("(.-)\n") do
    out[#out + 1] = line
  end
  while #out > 0 and out[#out] == "" do
    out[#out] = nil
  end
  return out
end

--- Join lines with LaTeX linebreaks for align-like environments.
--- @param lines string[]
--- @return string
function M.join_align(lines)
  return table.concat(lines or {}, " \\\\\n")
end

-- ---------------------------------------------------------- --
--       Alignment Helpers (operator-aware, Injectable)       --
-- ---------------------------------------------------------- --

--- Default operator palette for alignment insertion.
M._.default_ops = {
  basic = { "=", ">", "<" },
  latex = {
    "\\geq",
    "\\leq",
    "\\neq",
    "\\iff",
    "\\implies",
    "\\impliedby",
    "\\in",
  },
  special = { "\\int", "\\prod", "\\sum" }, -- skip adding '&' inside their arguments
}

--- Build a flat operator list from categories + extra overrides.
--- @param ops table|nil      table with keys basic/latex/special
--- @param extra string[]|nil additional operators to consider
--- @return string[] flat_ops
function M._.build_ops(ops, extra)
  local cfg = ops or M._.default_ops
  local flat = {}
  local function add(list)
    for _, v in ipairs(list or {}) do
      flat[#flat + 1] = v
    end
  end
  add(cfg.basic)
  add(cfg.latex)
  add(extra)
  return flat
end

--- Naively check whether a position `pos` in `str` sits inside the argument of
--- any "special" operator like \sum, \int, \prod.
--- @param str string
--- @param pos integer
--- @param specials string[]|nil
--- @return boolean
function M._.is_within_special(str, pos, specials)
  specials = specials or M._.default_ops.special
  for _, sp in ipairs(specials) do
    local idx = str:find(sp, 1, true)
    if idx and idx <= pos then
      local depth = 0
      for j = idx, #str do
        local ch = str:sub(j, j)
        if ch == "{" then
          depth = depth + 1
        elseif ch == "}" then
          depth = depth - 1
        end
        if depth == 0 and j >= pos then
          return true
        end
      end
    end
  end
  return false
end

--- Find the earliest operator occurrence in a line.
--- @param line string
--- @param ops string[]
--- @return integer|nil idx, string|nil op
function M._.first_operator(line, ops)
  local best_i, best_op = nil, nil
  for _, op in ipairs(ops or {}) do
    local i1 = line:find(op, 1, true)
    if i1 and (not best_i or i1 < best_i) then
      best_i, best_op = i1, op
    end
  end
  return best_i, best_op
end

--- Add a single '&' before the first non-special operator in a line.
--- @param line string
--- @param ops string[]            operators to consider
--- @param specials string[]|nil   specials with brace scopes to skip
--- @return string transformed_line
function M._.add_amp_to_line(line, ops, specials)
  local s = (line or ""):gsub("^%s+", ""):gsub("%s+$", "")
  local idx, _ = M._.first_operator(s, ops)
  if idx and not M._.is_within_special(s, idx, specials) then
    s = s:sub(1, idx - 1) .. "&" .. s:sub(idx)
  end
  return s
end

--- Insert '&' before the first operator per line (operator-aware).
--- @param lines string[]
--- @param ops_cfg table|nil   keys: basic, latex, special
--- @param extra_ops string[]|nil
--- @return string[] transformed_lines
function M.add_alignment_marks(lines, ops_cfg, extra_ops)
  local ops = M._.build_ops(ops_cfg, extra_ops)
  local specials = (ops_cfg or M._.default_ops).special
  local out = {}
  for _, raw in ipairs(lines or {}) do
    out[#out + 1] = M._.add_amp_to_line(raw, ops, specials)
  end
  return out
end

-- ---------------------------------------------------------- --
--          Dynamic Node Factories (Matrix / Cases)           --
-- ---------------------------------------------------------- --

--- Build node sequence for a matrix row.
--- @param row integer
--- @param cols integer
--- @param idx integer  running restore-node index (updated and returned)
--- @return table nodes, integer next_idx
function M._.matrix_row(row, cols, idx)
  local nodes = {}
  table.insert(nodes, r(idx, string.format("%dx1", row), i(1)))
  idx = idx + 1
  for ccol = 2, cols do
    table.insert(nodes, t(" & "))
    table.insert(nodes, r(idx, string.format("%dx%d", row, ccol), i(1)))
    idx = idx + 1
  end
  return nodes, idx
end

--- Generate a matrix body using restore/insert nodes for an RxC matrix.
--- Intended for use as a `dynamic_node` factory for regex-capture snippets.
--- Expected captures: rows at index 2 and cols at index 3.
--- @param _ any         Unused (LuaSnip API)
--- @param snip table    Snippet state; expects numeric captures in `snip.captures`
--- @return luasnip.SnippetNode  Matrix body nodes with `&` and `\\`.
function M.generate_matrix(_, snip)
  local rows = tonumber((snip.captures or {})[2]) or 2
  local cols = tonumber((snip.captures or {})[3]) or 2

  local seq, idx = {}, 1
  for rrow = 1, rows do
    local row_nodes
    row_nodes, idx = M._.matrix_row(rrow, cols, idx)
    for _, n in ipairs(row_nodes) do
      seq[#seq + 1] = n
    end
    seq[#seq + 1] = t({ " \\\\", "" })
  end
  if #seq > 0 then
    table.remove(seq, #seq)
  end
  return sn(nil, seq)
end

--- Build node sequence for a two-column cases row.
--- @param row integer
--- @param idx integer
--- @return table nodes, integer next_idx
function M._.cases_row(row, idx)
  local nodes = {}
  table.insert(nodes, r(idx, string.format("%dx1", row), i(1)))
  idx = idx + 1
  table.insert(nodes, t(" & "))
  table.insert(nodes, r(idx, string.format("%dx2", row), i(1)))
  idx = idx + 1
  return nodes, idx
end

--- Generate a cases body with two columns and N rows (default 2).
--- Intended for use as a `dynamic_node` factory for regex-capture snippets.
--- Expected capture: row-count at index 1 (optional).
--- @param _ any
--- @param snip table
--- @return luasnip.SnippetNode
function M.generate_cases(_, snip)
  local rows = tonumber((snip.captures or {})[1]) or 2

  local seq, idx = {}, 1
  for rrow = 1, rows do
    local row_nodes
    row_nodes, idx = M._.cases_row(rrow, idx)
    for _, n in ipairs(row_nodes) do
      seq[#seq + 1] = n
    end
    seq[#seq + 1] = t({ " \\\\", "" })
  end
  if #seq > 0 then
    table.remove(seq, #seq)
  end
  return sn(nil, seq)
end

-- ---------------------------------------------------------- --
--                     Formatting Helpers                     --
-- ---------------------------------------------------------- --

--- Render a LaTeX environment block using `fmta` with long strings `[[...]]`.
--- Example:
---   env_block("align", "a &= b \\\\\n c &= d", "*")
--- @param name string     Environment name (e.g., "align", "equation").
--- @param body string     Body content (already joined with line breaks).
--- @param star string|nil "*" for starred variant or ""/nil for unstarred.
--- @return string         Rendered block.
function M.env_block(name, body, star)
  local sfx = star or ""
  return fmta(
    [[
  \begin{<><>}
  <>
  \end{<><>}
  ]],
    { t(name), t(sfx), t(body or ""), t(name), t(sfx) }
  )
end

--- Reusable choice-node for "*" vs "" inside fmta args.
--- @param idx integer  Choice index to allocate
--- @return luasnip.ChoiceNode
function M.star_choice(idx)
  return c(idx, { t(""), t("*") })
end

return M
