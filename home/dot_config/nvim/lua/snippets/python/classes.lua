-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/python/classes.lua
-- Description: Contains snippets for Object-Oriented Programming, including
--              classes, methods, and properties.
-- ----------------------------------------------------------------------------

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

local utils = require("snippets.python.utils")

return {
  s({
    trig = "class",
    name = "Class (dynamic)",
    dscr = "Class definition with optional inheritance.",
  }, {
    t("class "),
    i(1, "ClassName"),
    c(2, { t(""), t("(") }),
    d(3, function(args)
      if #args[1] > 0 then
        return ls.parser.parse_snippet(nil, "${1:BaseClass})")
      else
        return s(nil, {})
      end
    end, { 2 }),
    t({ ":", "    " }),
    i(0, "pass"),
  }),

  s({
    trig = "classi",
    name = "Class with Dynamic Docstring",
    dscr = "Class definition that generates a docstring from its __init__ arguments.",
  }, {
    t("class "),
    i(1, "ClassName"),
    t(":\n"),
    t('    """'),
    i(2, "One-line summary."),
    t({ "", "" }),
    d(3, function(args)
      local arg_names = utils.get_args_from_signature(args[1][1] or "")
      if #arg_names == 0 then
        return s(nil, {})
      end

      local nodes = { t("Attributes:\n") }
      for _, name in ipairs(arg_names) do
        table.insert(
          nodes,
          fmt(
            "        {1} ({}): {}\n",
            { i(1, "type"), i(2, "Description.") },
            { name }
          )
        )
      end
      return s(nil, nodes)
    end, { 4 }),
    t('    """\n\n'),
    t("    def __init__(self, "),
    i(4, "arg1, arg2"),
    t("):\n"),
    d(5, function(args)
      local arg_names = utils.get_args_from_signature(args[1][1] or "")
      local nodes = {}
      for _, name in ipairs(arg_names) do
        table.insert(nodes, fmt("        self.{1} = {1}\n", {}, { name }))
      end
      return s(nil, nodes)
    end, { 4 }),
    i(0),
  }),

  s({
    trig = "defst",
    name = "Class Method w/ Return Type",
    dscr = "Class method definition",
  }, {
    t("def "),
    i(1, "method"),
    t("(self, "),
    i(2, "args"),
    t(") -> "),
    c(3, { t("None"), t("str"), t("int"), t("bool"), t("list"), t("dict") }),
    t({ ":", "    " }),
    i(0, "pass"),
  }),

  s(
    {
      trig = "property",
      name = "Property Template",
      dscr = "New property: get and set via decorator",
    },
    fmt(
      [[
  @property
  def {1}(self):
      """Property for {1}"""
      return self._{1}

  @{1}.setter
  def {1}(self, value):
      self._{1} = value
  {2}
  ]],
      {
        i(1, "prop_name"),
        i(0),
      }
    )
  ),

  s(
    {
      trig = "enum",
      name = "enum Class Template",
      dscr = "enum definition.",
    },
    fmt(
      [[
  from enum import Enum

  class {1}(Enum):
      """{2}"""
      {3} = "{4}"
      {5} = "{6}"
      {7}
  ]],
      {
        i(1, "EnumName"),
        i(2, "docstring"),
        i(3, "KEY1"),
        i(4, "value1"),
        i(5, "KEY2"),
        i(6, "value2"),
        i(0),
      }
    )
  ),

  s(
    {
      trig = "datacls",
      name = "Dataclass Template",
      dscr = "dataclass definition.",
    },
    fmt(
      [[
  from dataclasses import dataclass

  @dataclass
  class {1}:
      """{2}"""
      {3}: {4} = {5}
      {6}
  ]],
      {
        i(1, "ClassName"),
        i(2, "docstring"),
        i(3, "attr"),
        i(4, "type"),
        i(5, "default"),
        i(0),
      }
    )
  ),

  s(
    {
      trig = "pydbasemodel",
      name = "Pydantic BaseModel",
      dscr = "Import and create a Pydantic BaseModel",
    },
    fmt(
      [[
  from pydantic import BaseModel

  class {}(BaseModel):
      {}
  ]],
      {
        i(1, "Model"),
        i(0, "pass"),
      }
    )
  ),

  s({ trig = "s", name = "self" }, fmt("self.{}", { i(0) })),

  s({ trig = "__", name = "__magic__" }, fmt("__{}__", { i(1, "init") })),
}
