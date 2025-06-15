local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local divider = require("config.utils.luasnip_comment")

-- Centered title box snippet
return {
  s("cbox", f(function(_, snip)
    local title = snip.captures[1] or snip.env.TM_SELECTED_TEXT[1] or snip.env.TM_CURRENT_LINE
    return divider.box(title)
  end, {}, {
    user_args = {},
  })),
}
