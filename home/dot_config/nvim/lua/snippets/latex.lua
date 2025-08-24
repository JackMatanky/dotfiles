-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/latex.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Entry point for modular LaTeX snippets. This file collects and
--              returns all snippets from the `latex/` directory.
-- ----------------------------------------------------------------------------

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

-- Utility functions shared across snippets
local utils_ok, utils = pcall(require, "snippets.latex.utils")
if not utils_ok then
  utils = {}
end

-- Collect modular snippets
local snippets = {}

-- Load snippets from modular files
local function load(module)
  local ok, mod = pcall(require, "snippets.latex." .. module)
  if ok and type(mod) == "table" then
    vim.list_extend(snippets, mod)
  else
    vim.notify(
      "LuaSnip (latex.lua): Failed to load module " .. module,
      vim.log.levels.WARN
    )
  end
end

-- List of modules to include
local modules = {
  "arrows",
  "basic",
  "calculus_integrals",
  "chemistry",
  "comparison_ops",
  "environments",
  "greek",
  "logic",
  "math_mode",
  "matrices_arrays",
  "physics",
  "quantum_mechanics",
  "selection_ops",
  "series_limits",
  "sets",
  "subscript",
  "superscript",
  "symbols",
}

for _, m in ipairs(modules) do
  load(m)
end

-- Return all snippets for LaTeX filetype
return snippets
