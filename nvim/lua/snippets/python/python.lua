-- ----------------------------------------------------------------------------
-- Filename: ~/dotfiles/nvim/lua/snippets/python.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: Native LuaSnip snippets for Python, organized by category. This
--              file demonstrates advanced features like format strings, dynamic
--              nodes, and context-aware docstring generation to create an
--              efficient and DRY snippet library.
-- ----------------------------------------------------------------------------

-- Require the main luasnip module to access its API.
local ls = require('luasnip')
-- Create local aliases for commonly used nodes to improve readability.
local s = ls.snippet       -- The basic snippet container.
local t = ls.text_node     -- Inserts plain text.
local i = ls.insert_node   -- Creates a placeholder for user input.
local c = ls.choice_node   -- Creates a node where the user can choose between several options.
local f = ls.function_node -- Repeats user input from another node.
local d = ls.dynamic_node  -- Dynamically generates nodes based on user input.
-- `fmt` is a powerful function for creating snippets from a template string.
local fmt = require("luasnip.extras.fmt").fmt

-- ------------------ HELPER FUNCTIONS ------------------ --

-- Helper function to parse argument names from a Python function signature string.
-- This is the core of the dynamic docstring generation. It uses string matching
-- to find identifiers that are likely argument names, excluding 'self' and 'cls'.
--
-- @param sig_str (string) The function signature string (e.g., "self, arg1, arg2").
-- @return (table) A list of parsed argument names.
local function get_args_from_signature(sig_str)
  local args = {}
  -- string.gmatch iterates over all occurrences of a pattern that captures valid
  -- Python identifiers, which are typically delimited by commas, colons, or parentheses.
  for arg in string.gmatch(sig_str, "([a-zA-Z_][a-zA-Z0-9_]*)[%s%*]*[,%):]") do
    if arg ~= "self" and arg ~= "cls" then
      table.insert(args, arg)
    end
  end
  return args
end

-- ---------------------------------------------------------- --
--                       PYTHON SNIPPETS                      --
-- ---------------------------------------------------------- --


-- ls.add_snippets registers all snippets in the following table for the 'python' filetype.
ls.add_snippets('python', {
  -- ----------------- BASICS & BOILERPLATE ----------------- --
  s({
    trig = '#env',                                       -- The trigger that expands the snippet.
    name = '#!/usr/bin/env python',                      -- A descriptive name for snippet menus.
    dscr = 'Shebang line for default python interpreter' -- A longer description.
  }, {
    t('#!/usr/bin/env python'),                          -- A simple text node for the shebang.
    i(0),                                                -- The final cursor position after expansion.
  }),

  s({
      trig = 'ifmain',
      name = 'if __name__ == __main__',
      dscr = 'Execute code if the file is executed directly'
    },
    -- `fmt` is used here for its clean, visual templating.
    fmt([[
  if __name__ == "__main__":
      {}
  ]],        -- The first `{}` is replaced by the first node in the table below.
      {
        i(0) -- The final cursor position.
      }
    )),

  s({
    trig = '#',
    name = 'Multiline string',
    dscr = 'Avoid autopair plugin annoyances when typing multiple "'
    -- The first `{}` becomes insert node 1, the second becomes insert node 0.
  }, fmt([[
  """
  {}
  """
  {}
  ]], {
    i(1), i(0)
  })),

  s({
    trig = '##',
    name = 'One-line multiline string',
    dscr = 'Avoid autopair plugin annoyances when typing multiple "'
  }, fmt(
    '"""{}"""{}', {
      i(1), i(0)
    })),

  -- ------------------ LINTER & FORMATTER ------------------ --
  s({
    trig = 'enco',
    name = '# coding=utf-8',
    dscr = 'Set default python3 encoding specification to utf-8.'
  }, {
    t('# coding=utf-8'),
    i(0),
  }),

  s({
    trig = 'pyignore',
    name = 'Pyright Ignore Rule Comment',
    dscr = 'Insert a comment to ignore a specific Pyright diagnostic on the current line.'
  }, {
    t('# pyright: ignore['),
    -- c(1, {...}) creates a choice node where the user can select a pyright rule.
    c(1, {
      t('reportAny'),
      t('reportExplicitAny'),
      t('reportUnnecessaryComparison'),
      t('reportUnreachable'),
      t('reportUnknownArgumentType'),
      t('reportUnknownParameterType'),
      t('reportUnusedImport'),
      t('reportUnusedParameter'),
    }),
    t(']'),
    i(0),
  }),

  s({
    trig = 'ruffignore',
    name = 'Ruff Ignore Rule Comment',
    dscr = 'Insert a comment to ignore a specific Ruff diagnostic on the current line.'
  }, {
    t('# noqa: '),
    i(1, 'E501'), -- Insert node with a default value.
    i(0),
  }),

  -- --------------------- JUPYTER CELLS -------------------- --
  -- This single snippet handles both code and markdown cells,
  -- which is a good example of the DRY principle.
  s({
    trig = 'jpy',
    name = 'py:percent Cell',
    dscr = 'Add new py:percent code or markdown cell'
  }, {
    t('# %%'),
    -- The user can choose to insert nothing (for a code cell) or ' [markdown]'.
    c(1, {
      t(''),
      t(' [markdown]'),
    }),
    t({ '\n' }),
    i(0),
  }),

  -- ------------------------ IMPORTS ----------------------- --
  -- A dynamic snippet that provides an alias for common libraries.
  s({
    trig = 'im',
    name = 'Import Module (with Alias)',
    dscr = 'Import a package, with an automatic alias for common libraries.'
  }, {
    t('import '),
    -- The user chooses a library from this list.
    c(1, {
      t('pandas'),
      t('numpy'),
      t('matplotlib.pyplot'),
      t('seaborn'),
      t('tensorflow'),
      t('torch'),
    }),
    -- d(2, ...) creates a dynamic node that depends on the choice from node 1.
    d(2, function(args)
      -- args[1][1] contains the text of the user's choice from node 1.
      local module_name = args[1][1]
      local aliases = {
        pandas = 'pd',
        numpy = 'np',
        ['matplotlib.pyplot'] = 'plt',
        seaborn = 'sns',
        tensorflow = 'tf',
      }
      local alias = aliases[module_name]
      if alias then
        -- If an alias exists, parse and return a new snippet with the alias.
        return ls.parser.parse_snippet("alias", " as " .. alias)
      else
        -- Otherwise, return an empty snippet.
        return ls.parser.parse_snippet("alias", "")
      end
    end, { 1 }), -- The {1} indicates this dynamic node depends on insert node 1.
    i(0),
  }),

  s({
    trig = 'ifm',
    name = 'Import From Module',
    dscr = 'Import individual objects directly into the caller’s symbol table'
  }, fmt('from {} import {}{}', {
    i(1, "module"), i(2, "name"), i(0)
  })),

  s({
    trig = 'fenc',
    name = 'from __future__ import (py2)',
    dscr = 'Import future statement definitions for python2.x scripts using utf-8 as encoding.'
  }, fmt([[
  # -*- coding: utf-8 -*-
  from __future__ import absolute_import, division, print_function, unicode_literals

  {}
  ]], {
    i(0)
  })),

  s({
    trig = 'fenco',
    name = 'from __future__ import (py3)',
    dscr = 'Import future statement definitions for python3.x scripts using utf-8 as encoding.'
  }, fmt([[
  # coding: utf-8
  from __future__ import absolute_import, division, print_function, unicode_literals

  {}
  ]], {
    i(0)
  })),

  -- --------------------- CONTROL FLOW --------------------- --
  s({
    trig = 'if',
    name = 'if',
    dscr = 'if statement'
  }, fmt([[
  if {}:
      {}
  ]], {
    i(1, "condition"), i(0, "pass")
  })),

  s({
    trig = 'elif',
    name = 'elif',
    dscr = 'elif statement'
  }, fmt([[
  elif {}:
      {}
  ]], {
    i(1, "condition"), i(0, "pass")
  })),

  s({
    trig = 'else',
    name = 'else',
    dscr = 'else statement'
  }, fmt([[
  else:
      {}
  ]], {
    i(0, "pass")
  })),

  s({
    trig = 'ifelse',
    name = 'if/else',
    dscr = 'if statement with else'
  }, fmt([[
  if {}:
      {}
  else:
      {}
  ]], {
    i(1, "condition"), i(2, "action"), i(0)
  })),

  s({
    trig = 'for',
    name = 'for loop (dynamic)',
    dscr = 'Creates a for loop, with a choice for a standard iterable or range().'
  }, {
    t('for '), i(1, 'item'), t(' in '),
    c(2, {
      i(1, 'iterable'),                           -- Choice 1: standard iterable
      s(nil, { t('range('), i(1, '10'), t(')') }) -- Choice 2: range()
    }),
    t(':\n'),
    fmt([[
        {}
    ]], {
      i(0, 'pass')
    })
  }),

  s({
    trig = 'while',
    name = 'while / do-while (dynamic)',
    dscr = 'Creates a while loop. If condition is "True", becomes a do-while structure.'
  }, {
    t('while '), i(1, 'condition'), t(':\n'),
    d(2, function(args)
      local cond = args[1][1] or ""
      if cond == 'True' then
        -- If the condition is literally "True", expand to a do-while structure.
        return fmt([[
        {}
        if not ({}):
            break
    {}
    ]], {
          i(1, 'action'), i(2, 'condition'), i(0)
        })
      else
        -- Otherwise, expand to a standard while loop.
        return fmt([[
        {}
    ]], {
          i(0, 'pass')
        })
      end
    end, { 1 })
  }),

  -- -------------------- COMPREHENSIONS -------------------- --
  -- This dynamic snippet combines the simple list comprehension with the conditional one.
  s({
    trig = 'lc',
    name = 'List Comprehension',
    dscr = 'List comprehension with optional condition.'
  }, {
    t('['), i(1, 'expr'), t(' for '), i(2, 'item'), t(' in '), i(3, 'iterable'),
    -- The user chooses to add the ' if ' part or not.
    c(4, { t(''), t(' if ') }),
    -- Based on the choice, this dynamic node inserts a condition placeholder or nothing.
    d(5, function(args)
      if #args[1] > 0 then return s(nil, { i(1, 'condition') }) else return s(nil, {}) end
    end, { 4 }),
    t(']'),
    i(0)
  }),

  s({
      trig = 'lcie',
      name = 'List comprehension if else',
      dscr = 'List comprehension with conditional if-else.'
    },
    fmt('[{} if {} else {} for {} in {}]{}',
      { i(1, "expr1"), i(2, "condition"), i(3, "expr2"), i(4, "item"), i(5, "iterable"), i(0) })),

  s({
    trig = 'dc',
    name = 'Dictionary Comprehension',
    dscr = 'Dictionary comprehension with optional condition.'
  }, {
    t('{'), i(1, 'key'), t(': '), i(2, 'value'), t(' for '), i(3, 'k'), t(', '), i(4, 'v'), t(' in '), i(5, 'iterable'),
    c(6, { t(''), t(' if ') }),
    d(7, function(args)
      if #args[1] > 0 then return s(nil, { i(1, 'condition') }) else return s(nil, {}) end
    end, { 6 }),
    t('}'),
    i(0)
  }),

  s({
    trig = 'sc',
    name = 'Set Comprehension',
    dscr = 'Set comprehension with optional condition.'
  }, {
    t('{'), i(1, 'item'), t(' for '), i(2, 'item'), t(' in '), i(3, 'iterable'),
    c(4, { t(''), t(' if ') }),
    d(5, function(args)
      if #args[1] > 0 then return s(nil, { i(1, 'condition') }) else return s(nil, {}) end
    end, { 4 }),
    t('}'),
    i(0)
  }),

  s({
    trig = 'gc',
    name = 'Generator Comprehension',
    dscr = 'Generator comprehension with optional condition.'
  }, {
    t('('), i(1, 'item'), t(' for '), i(2, 'item'), t(' in '), i(3, 'iterable'),
    c(4, { t(''), t(' if ') }),
    d(5, function(args)
      if #args[1] > 0 then return s(nil, { i(1, 'condition') }) else return s(nil, {}) end
    end, { 4 }),
    t(')'),
    i(0)
  }),

  -- ----------------- MATCH/CASE STATEMENTS ---------------- --
  s({
    trig = 'match',
    name = 'match/case',
    dscr = 'match/case statements'
  }, fmt([[
  match {}:
      case {}:
          {}
  ]], {
    i(1, "subject"), i(2, "pattern"), i(0, "pass")
  })),

  s({
    trig = 'case',
    name = 'case',
    dscr = 'case block'
  }, fmt([[
  case {}:
      {}
  ]], {
    i(1, "pattern"), i(0, "pass")
  })),

  s({
    trig = 'casew',
    name = 'case wildcard',
    dscr = 'case wildcard block if other cases fail'
  }, fmt([[
  case _:
      {}
  ]], {
    i(0, "pass")
  })),

  -- ------------------- CONTEXT MANAGERS ------------------- --
  s({
    trig = 'with',
    name = 'With Statement',
    dscr = "'with' statement"
  }, fmt([[
  with {} as {}:
      {}
  ]], {
    i(1, "expr"), i(2, "var"), i(0, "pass")
  })),

  s({
    trig = 'withf',
    name = 'With Statement for File',
    dscr = "'with' statement for reading/writing files"
  }, {
    t('with open('),
    i(1, 'filename'),
    t(', "'),
    c(2, { t('r'), t('w'), t('a'), t('r+'), t('rb'), t('wb') }),
    t('") as '),
    i(3, 'f'),
    t({ ':', '    ' }),
    i(0, 'pass'),
  }),

  s({
    trig = 'withsq',
    name = 'With Statement for SQLite',
    dscr = "'with' statement for SQLite database connection"
  }, fmt([[
  import sqlite3

  with sqlite3.connect({}) as {}:
      {}
  ]], {
    i(1, "database"), i(2, "conn"), i(0, "pass")
  })),

  s({
    trig = 'witha',
    name = 'With Statement Async',
    dscr = "'async with' statement"
  }, fmt([[
  async with {} as {}:
      {}
  ]], {
    i(1, "expr"), i(2, "var"), i(0, "pass")
  })),

  -- ------------------ FUNCTIONS & LAMBDAS ----------------- --
  -- This advanced snippet generates a complete function with a dynamic Google-style docstring.
  s({
    trig = 'def',
    name = 'Function with Dynamic Docstring',
    dscr = 'Function definition that generates a docstring from its arguments.'
  }, {
    t("def "), i(1, "func_name"), t("("), i(2, "self, arg1, arg2"), t(") -> "), c(3, { t("None"), t("str"), t("int") }),
    t({ ":", '    """' }), i(4, "One-line summary."), t({ "", "" }),
    -- This dynamic node generates the 'Args:' section.
    d(5, function(args)
      -- It gets the function signature from the text of node 2.
      local arg_names = get_args_from_signature(args[1][1] or "")
      if #arg_names == 0 then return s(nil, {}) end -- Don't generate if no args.

      local nodes = { t("Args:\n") }
      -- Loop through the parsed argument names.
      for idx, name in ipairs(arg_names) do
        -- For each name, create a formatted line for the docstring.
        table.insert(nodes, fmt("        {1} ({}): {}\n", { i(1, "type"), i(2, "Description.") }, { name }))
      end
      return s(nil, nodes)
    end, { 2 }),
    t({ "    Returns:", "        " }), i(6, "None"), t(": "), i(7, "Description."),
    t({ "", '    """', "" }),
    i(0, "pass")
  }),

  s({
    trig = 'adef',
    name = 'async Function with Dynamic Docstring',
    dscr = 'Asynchronous function definition that generates a docstring from its arguments.'
  }, {
    t("async def "), i(1, "func_name"), t("("), i(2, "self, arg1, arg2"), t(") -> "), c(3,
    { t("None"), t("str"), t("int") }),
    t({ ":", '    """' }), i(4, "One-line summary."), t({ "", "" }),
    d(5, function(args)
      local arg_names = get_args_from_signature(args[1][1] or "")
      if #arg_names == 0 then return s(nil, {}) end

      local nodes = { t("Args:\n") }
      for idx, name in ipairs(arg_names) do
        table.insert(nodes, fmt("        {1} ({}): {}\n", { i(1, "type"), i(2, "Description.") }, { name }))
      end
      return s(nil, nodes)
    end, { 2 }),
    t({ "    Returns:", "        " }), i(6, "None"), t(": "), i(7, "Description."),
    t({ "", '    """', "" }),
    i(0, "pass")
  }),

  s({
    trig = 'lam',
    name = 'Lambda Function',
    dscr = 'Lambda function'
  }, fmt('lambda {}: {}', {
    i(1, "args"), i(2, "expr")
  })),

  -- --------------------- CLASSES & OOP -------------------- --
  -- This dynamic snippet combines the base class and derived class snippets.
  s({
    trig = 'class',
    name = 'Class (dynamic)',
    dscr = 'Class definition with optional inheritance.'
  }, {
    t('class '),
    i(1, 'ClassName'),
    -- The user chooses whether to add inheritance parentheses or not.
    c(2, { t(''), t('(') }),
    d(3, function(args)
      -- If the choice was '(', add a placeholder for the BaseClass.
      if #args[1] > 0 then return ls.parser.parse_snippet(nil, '${1:BaseClass})') else return s(nil, {}) end
    end, { 2 }),
    t({ ':', '    ' }),
    i(0, 'pass')
  }),

  -- This snippet generates a full class, including a dynamic docstring and __init__ method.
  s({
    trig = 'classi',
    name = 'Class with Dynamic Docstring',
    dscr = 'Class definition that generates a docstring from its __init__ arguments.'
  }, {
    t("class "), i(1, "ClassName"), t(":\n"),
    t('    """'), i(2, "One-line summary."), t({ "", "" }),
    -- The dynamic node for the 'Attributes:' section, depends on node 4.
    d(3, function(args)
      local arg_names = get_args_from_signature(args[1][1] or "")
      if #arg_names == 0 then return s(nil, {}) end

      local nodes = { t("Attributes:\n") }
      for idx, name in ipairs(arg_names) do
        table.insert(nodes, fmt("        {1} ({}): {}\n", { i(1, "type"), i(2, "Description.") }, { name }))
      end
      return s(nil, nodes)
    end, { 4 }),
    t('    """\n\n'),
    t("    def __init__(self, "), i(4, "arg1, arg2"), t("):\n"),
    -- This dynamic node generates the `self.attr = attr` lines in the init method.
    d(5, function(args)
      local arg_names = get_args_from_signature(args[1][1] or "")
      local nodes = {}
      for _, name in ipairs(arg_names) do
        table.insert(nodes, fmt("        self.{1} = {1}\n", {}, { name }))
      end
      return s(nil, nodes)
    end, { 4 }),
    i(0)
  }),

  s({
    trig = 'defst',
    name = 'Class Method w/ Return Type',
    dscr = 'Class method definition'
  }, {
    t('def '), i(1, 'method'), t('(self, '), i(2, 'args'), t(') -> '),
    c(3, { t('None'), t('str'), t('int'), t('bool'), t('list'), t('dict') }),
    t({ ':', '    ' }),
    i(0, 'pass'),
  }),

  -- The `property` snippet uses {1} to repeat the property name multiple times, a key feature of `fmt`.
  s({
    trig = 'property',
    name = 'Property Template',
    dscr = 'New property: get and set via decorator'
  }, fmt([[
  @property
  def {1}(self):
      """Property for {1}"""
      return self._{1}

  @{1}.setter
  def {1}(self, value):
      self._{1} = value
  {2}
  ]], {
    i(1, "prop_name"), i(0)
  })),

  s({
    trig = 'enum',
    name = 'enum Class Template',
    dscr = 'enum definition.'
  }, fmt([[
  from enum import Enum

  class {1}(Enum):
      """{2}"""
      {3} = "{4}"
      {5} = "{6}"
      {7}
  ]], {
    i(1, "EnumName"),
    i(2, "docstring"),
    i(3, "KEY1"), i(4, "value1"),
    i(5, "KEY2"), i(6, "value2"),
    i(0)
  })),

  s({
    trig = 'datacls',
    name = 'Dataclass Template',
    dscr = 'dataclass definition.'
  }, fmt([[
  from dataclasses import dataclass

  @dataclass
  class {1}:
      """{2}"""
      {3}: {4} = {5}
      {6}
  ]], {
    i(1, "ClassName"),
    i(2, "docstring"),
    i(3, "attr"), i(4, "type"), i(5, "default"),
    i(0)
  })),

  s({
    trig = 'pydbasemodel',
    name = 'Pydantic BaseModel',
    dscr = 'Import and create a Pydantic BaseModel'
  }, fmt([[
  from pydantic import BaseModel

  class {}(BaseModel):
      {}
  ]], {
    i(1, "Model"), i(0, "pass")
  })),

  s({ trig = 's', name = 'self' }, fmt('self.{}', { i(0) })),

  s({ trig = '__', name = '__magic__' }, fmt('__{}__', { i(1, "init") })),

  -- -------------------- ERROR HANDLING -------------------- --
  -- This dynamic snippet combines `except` and `except as`.
  s({
    trig = 'except',
    name = 'except block',
    dscr = 'except block with optional alias.'
  }, {
    t('except '),
    c(1, { t('Exception'), t('ValueError'), t('TypeError'), t('KeyError'), t('IndexError') }),
    -- The user chooses whether to add an alias or not.
    c(2, { t(''), t(' as ') }),
    d(3, function(args)
      if #args[1] > 0 then return s(nil, { i(1, 'err') }) else return s(nil, {}) end
    end, { 2 }),
    t({ ':', '    ' }),
    i(0, 'pass'),
  }),

  -- This dynamic snippet consolidates all `try...` variations into one.
  s({
    trig = 'try',
    name = 'try block (dynamic)',
    dscr = 'A dynamic try block with optional else and finally clauses.'
  }, {
    t('try:'), t({ '', '    ' }), i(1, 'pass'),
    t({ '', 'except ' }),
    c(2, { t('Exception'), t('ValueError'), t('TypeError'), t('KeyError'), t('IndexError') }),
    t(' as '), i(3, 'err'),
    t({ ':', '    ' }), i(4, 'pass'),
    -- The user chooses to add `else`, `finally`, both, or neither.
    c(5, {
      s(nil, { i(0) }),                                                            -- Choice 1: No extra clauses, end snippet.
      fmt('\n\nelse:\n    {}', { i(0, "pass") }),                                  -- Choice 2: Else only.
      fmt('\n\nfinally:\n    {}', { i(0, "pass") }),                               -- Choice 3: Finally only.
      fmt('\n\nelse:\n    {}\n\nfinally:\n    {}', { i(1, "pass"), i(0, "pass") }) -- Choice 4: Both.
    })
  }),
})
