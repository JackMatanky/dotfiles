-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/markdown/utils.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: This file contains utility functions for Markdown snippets.
--              Its single responsibility is to provide the logic needed for
--              conditional snippet expansion, which can be required by any
--              other snippet file.
-- ----------------------------------------------------------------------------

local M = {}

--- Checks if the cursor is currently inside a LaTeX math block.
-- This is determined by counting the number of non-escaped '$' characters
-- on the line before the cursor. An odd number implies the cursor is
-- inside a math zone.
-- @return (boolean) True if in a math zone, false otherwise.
function M.is_in_mathzone()
  local line_to_cursor = vim.api.nvim_buf_get_lines(
    0,
    vim.fn.line(".") - 1,
    vim.fn.line("."),
    true
  )[1]
  line_to_cursor = line_to_cursor:sub(1, vim.fn.col(".") - 1)
  -- Count non-escaped dollar signs.
  local dollars = 0
  for _ in string.gmatch(line_to_cursor, "[^%]$") do
    dollars = dollars + 1
  end
  return dollars % 2 ~= 0
end

return M
