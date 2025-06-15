-- ----------------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/config/utils/comment_divider.lua
--  Description: Enhanced comment-divider.nvim utilities.
--               Uses current line (comment-stripped and title-cased) to
--               auto-fill and execute divider titles using Lua API.
-- ----------------------------------------------------------------------------

---@class CommentDividerUtils
local M = {}

-- ---------------------------------------------------------- --
--                      String Utilities                      --
-- ---------------------------------------------------------- --

local TRIM_PATTERN = "^%s*(.-)%s*$"

--- Trim leading and trailing whitespace from a string.
---@param str string
---@return string
local function trim_whitespace(str)
  return (str:gsub(TRIM_PATTERN, "%1"))
end

--- Remove newlines and trim whitespace from input.
---@param str string
---@return string
local function sanitize_input(str)
  return trim_whitespace((str:gsub("[\n\r]", "")))
end

--- Check if all letters in a string are uppercase.
---@param s string
---@return boolean
local function is_all_upper(s)
  return s:upper() == s and s:lower() ~= s
end

--- Title-case a string, skipping acronyms and short words.
--- - Words with all-uppercase letters are left as-is.
--- - Words with < 3 characters are left as-is.
---@param str string
---@return string
local function title_case(str)
  return (
    str:gsub("(%S+)", function(word)
      if #word < 3 or is_all_upper(word) then
        return word
      else
        return word:sub(1, 1):upper() .. word:sub(2):lower()
      end
    end)
  )
end

--- Remove comment prefix from line based on filetype.
---@param line string
---@param config table CommentDivider plugin config table
---@return string
local function strip_comment_prefix(line, config)
  local filetype = vim.bo.filetype
  local lang = config.languageConfig[filetype] or config.defaultConfig
  local prefix = vim.pesc(lang.lineStart)
  return (line:gsub("^%s*" .. prefix .. "%s*", ""))
end

-- ---------------------------------------------------------- --
--                      Divider Helpers                       --
-- ---------------------------------------------------------- --

--- Get current line, strip comment prefix, trim, and title-case.
---@param config table
---@return string
function M.get_current_line_title(config)
  local raw = vim.fn.getline(".")
  local no_comment = strip_comment_prefix(raw, config)
  return title_case(trim_whitespace(no_comment))
end

--- Delete the current line and insert an empty line in its place.
--- Ensures the plugin inserts the divider at the correct position.
---@return integer row, string indent
local function prepare_insertion_point()
  local buf = 0
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.fn.getline(row)
  local indent = line:match("^%s*") or ""

  -- Delete the original line
  vim.api.nvim_buf_set_lines(buf, row - 1, row, false, {})

  -- Insert a blank line with original indentation
  vim.api.nvim_buf_set_lines(buf, row - 1, row - 1, false, { indent })

  -- Move cursor to that blank line
  vim.api.nvim_win_set_cursor(buf, { row, #indent })

  return row, indent
end

--- Override vim.ui.input with a prefilled default value.
--- Returns the original input function so it can be restored later.
---@param input string
---@return function
local function override_prompt(input)
  local original = vim.ui.input
  vim.ui.input = function(opts, on_confirm)
    opts.default = opts.default or input
    return original(opts, on_confirm)
  end
  return original
end

--- Restore the original vim.ui.input after override.
---@param original function
local function restore_prompt(original)
  vim.defer_fn(function()
    vim.ui.input = original
  end, 10)
end

--- Simulate pressing <CR> to auto-confirm the input prompt.
local function simulate_cr()
  vim.defer_fn(function()
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<CR>", true, false, true),
      "n",
      false
    )
  end, 20)
end

--- Resolve the generator function from command string.
---@param cmd string
---@return fun(config: table)
local function get_divider_fn(cmd)
  local generator = require("comment-divider.comment-generator")
  return cmd == "CommentDividerLine" and generator.commentLine
    or generator.commentBox
end

-- ---------------------------------------------------------- --
--                  Divider Insertion Logic                   --
-- ---------------------------------------------------------- --

--- Main dispatcher to insert a divider using plugin functions.
--- Extracts the current line, cleans it, deletes original,
--- simulates prompt, and inserts divider in same position.
---@param cmd string  # "CommentDividerLine" or "CommentDividerBox"
function M.insert_divider_command(cmd)
  local config = require("comment-divider.comment-config")
  local title = sanitize_input(M.get_current_line_title(config))
  local fn = get_divider_fn(cmd)

  -- Replace original line with an empty one for the plugin to use
  local original_row, _ = prepare_insertion_point()

  -- Prefill prompt and simulate user pressing <CR>
  local original_ui_input = override_prompt(title)
  simulate_cr()

  -- Call plugin logic (which internally uses vim.ui.input)
  fn(config)

  -- Restore prompt behavior
  restore_prompt(original_ui_input)

  -- Restore cursor to the original row
  vim.defer_fn(function()
    local line_count = vim.api.nvim_buf_line_count(0)
    vim.api.nvim_win_set_cursor(0, { math.min(original_row, line_count), 0 })
  end, 30)
end

-- ---------------------------------------------------------- --
--                      Public Interface                      --
-- ---------------------------------------------------------- --

---@alias DividerType "Line"|"Box"

--- Insert a divider of the given base type ("Line" or "Box").
---@param base DividerType
function M.insert_divider(base)
  M.insert_divider_command("CommentDivider" .. base)
end

--- Public function to insert a line-style divider.
function M.insert_divider_line()
  print("[Divider] insert_divider_line() called")
  M.insert_divider("Line")
end

--- Public function to insert a box-style divider.
function M.insert_divider_box()
  print("[Divider] insert_divider_box() called")
  M.insert_divider("Box")
end

return M
