-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/python/utils.lua
-- Description: Contains helper functions for Python snippets, such as parsers
--              for dynamic docstring generation.
-- ----------------------------------------------------------------------------

local M = {}

--- Parses a Python function signature to extract argument names and types.
-- Handles arguments with and without type hints, ignoring 'self' and 'cls'.
-- @param sig_str (string) The function signature (e.g., "self, arg1: str").
-- @return (table) A list of tables, each { name = string, type = string }.
function M.get_args_from_signature(sig_str)
  local args = {}
  if not sig_str or sig_str == "" then
    return args
  end

  -- Iterates over comma-separated parts of the signature.
  for part in string.gmatch(sig_str, "([^,]+)") do
    -- Extract the argument name (the first identifier, allowing for * and **).
    local arg_name = string.match(part, "%s*([%*%w_]+)")

    if arg_name and arg_name ~= "self" and arg_name ~= "cls" then
      -- Extract the type hint, which is the text between ':' and an optional '='.
      local arg_type_str = string.match(part, ":%s*([^=]+)")
      local arg_type = "any" -- Default type if not specified.
      if arg_type_str then
        arg_type = arg_type_str:match("^%s*(.-)%s*$") -- Trim whitespace.
      end
      table.insert(args, { name = arg_name, type = arg_type })
    end
  end
  return args
end

return M
