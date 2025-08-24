local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Load divider snippets
local divider_snippets = require("snippets.comment.dividers")

-- Original centered title box snippet (if the utility still exists)
local original_snippets = {}
-- Check if the old utility exists before using it
local ok, divider_util = pcall(require, "config.utils.luasnip_comment")
if ok then
  table.insert(original_snippets, s("cbox", f(function(_, snip)
    local title = snip.captures[1] or snip.env.TM_SELECTED_TEXT[1] or snip.env.TM_CURRENT_LINE
    return divider_util.box(title)
  end, {}, {
    user_args = {},
  })))
end

-- Combine all comment snippets
local all_snippets = original_snippets
for _, snippet in ipairs(divider_snippets) do
  table.insert(all_snippets, snippet)
end

return all_snippets
