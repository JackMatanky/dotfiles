-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/python/boilerplate.lua
-- Description: Contains snippets for boilerplate code, linter directives,
--              and basic file structure.
-- ----------------------------------------------------------------------------

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s({
    trig = "#env",
    name = "#!/usr/bin/env python",
    dscr = "Shebang line for default python interpreter",
  }, {
    t("#!/usr/bin/env python"),
    i(0),
  }),

  s({
    trig = "enco",
    name = "# coding=utf-8",
    dscr = "Set default python3 encoding specification to utf-8.",
  }, {
    t("# coding=utf-8"),
    i(0),
  }),

  s(
    {
      trig = "ifmain",
      name = "if __name__ == __main__",
      dscr = "Execute code if the file is executed directly",
    },
    fmt(
      [[
  if __name__ == "__main__":
      {}
  ]],
      {
        i(0),
      }
    )
  ),

  s(
    {
      trig = "#",
      name = "Multiline string",
      dscr = 'Avoid autopair plugin annoyances when typing multiple "',
    },
    fmt(
      [[
  """
  {}
  """
  {}
  ]],
      {
        i(1),
        i(0),
      }
    )
  ),

  s(
    {
      trig = "##",
      name = "One-line multiline string",
      dscr = 'Avoid autopair plugin annoyances when typing multiple "',
    },
    fmt('"""{}"""{}', {
      i(1),
      i(0),
    })
  ),
}
