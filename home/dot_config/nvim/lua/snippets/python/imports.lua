-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/python/imports.lua
-- Description: Contains all snippets related to Python imports.
-- ----------------------------------------------------------------------------

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Dynamic snippet that provides an alias for common libraries.
  s({
    trig = "im",
    name = "Import Module (with Alias)",
    dscr = "Import a package, with an automatic alias for common libraries.",
  }, {
    t("import "),
    c(1, {
      t("pandas"),
      t("numpy"),
      t("matplotlib.pyplot"),
      t("seaborn"),
      t("tensorflow"),
      t("torch"),
    }),
    d(2, function(args)
      local module_name = args[1][1]
      local aliases = {
        pandas = "pd",
        numpy = "np",
        ["matplotlib.pyplot"] = "plt",
        seaborn = "sns",
        tensorflow = "tf",
      }
      local alias = aliases[module_name]
      if alias then
        return ls.parser.parse_snippet("alias", " as " .. alias)
      else
        return ls.parser.parse_snippet("alias", "")
      end
    end, { 1 }),
    i(0),
  }),

  s(
    {
      trig = "ifm",
      name = "Import From Module",
      dscr = "Import individual objects directly into the caller’s symbol table",
    },
    fmt("from {} import {}{}", {
      i(1, "module"),
      i(2, "name"),
      i(0),
    })
  ),

  s(
    {
      trig = "fenc",
      name = "from __future__ import (py2)",
      dscr = "Import future statement definitions for python2.x scripts using utf-8 as encoding.",
    },
    fmt(
      [[
  # -*- coding: utf-8 -*-
  from __future__ import absolute_import, division, print_function, unicode_literals

  {}
  ]],
      {
        i(0),
      }
    )
  ),

  s(
    {
      trig = "fenco",
      name = "from __future__ import (py3)",
      dscr = "Import future statement definitions for python3.x scripts using utf-8 as encoding.",
    },
    fmt(
      [[
  # coding: utf-8
  from __future__ import absolute_import, division, print_function, unicode_literals

  {}
  ]],
      {
        i(0),
      }
    )
  ),
}
