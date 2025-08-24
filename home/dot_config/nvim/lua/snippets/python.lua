-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/python.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Main loader for all Python-related snippets. It requires and
--              combines snippet tables from the `snippets/python/` directory.
-- ----------------------------------------------------------------------------

-- A list of all snippet modules to load.
local modules = {
  "boilerplate",
  "classes",
  "comprehensions",
  "context_managers",
  "control_flow",
  "error_handling",
  "functions",
  "imports",
  "tooling",
}

local all_snippets = {}

-- Helper function to extend the main snippet table.
local function extend(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end

-- Iterate through the module names, require them, and add their snippets.
for _, name in ipairs(modules) do
  local snippet_table = require("snippets.python." .. name)
  extend(all_snippets, snippet_table)
end

return all_snippets
