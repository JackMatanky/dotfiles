-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/python/converted_from_zed.lua
-- Description: Python snippets converted from Zed editor snippets
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

return {
  -- Shebangs and encoding
  s("#env", { t("#!/usr/bin/env python"), i(0) }),
  s("enco", { t("# coding=utf-8"), t({ "", "" }), i(0) }),

  -- Ignore comments
  s("pyignore", {
    t("# pyright: ignore["),
    c(1, {
      t("reportAny"),
      t("reportExplicitAny"),
      t("reportUnnecessaryComparison"),
      t("reportUnreachable"),
      t("reportUnknownArgumentType"),
      t("reportUnknownParameterType"),
      t("reportUnusedImport"),
      t("reportUnusedParameter"),
    }),
    t("]"),
    i(0),
  }),

  s("ruffignore", {
    t("# noqa: "),
    c(1, {
      t("E501"), -- Line too long
      t("F401"), -- Module imported but unused
      t("F403"), -- Star import used
      t("F405"), -- Name may be undefined
      t("F841"), -- Local variable assigned but never used
    }),
    i(0),
  }),

  -- Multiline strings
  s("#", { t({ '"""', "" }), i(0), t({ "", '"""' }) }),
  s("##", { t('"""'), i(0), t('"""') }),

  -- Main block
  s("ifmain", {
    t({ 'if __name__ == "__main__":', "    " }),
    i(0),
  }),

  -- Jupyter cells
  s("jpy", {
    t("# %% "),
    c(1, {
      t(""),
      t("[markdown]"),
    }),
    t({ "", "" }),
    i(0),
  }),
  s("jpc", { t("# %%") }),
  s("jpm", { t("# %% [markdown]") }),

  -- Imports
  s("im", { t("import "), i(1, "module") }),
  s("ifm", { t("from "), i(1, "module"), t(" import "), i(2, "item"), i(0) }),

  s("pydbase", {
    t({ "from pydantic import BaseModel", "", "" }),
    t("class "),
    i(1, "Model"),
    t("("),
    c(2, { t("BaseModel"), i(1, "BaseModel") }),
    t("):"),
    i(0),
  }),

  s("fenc", {
    t({ "# -*- coding: utf-8 -*-", "from __future__ import absolute_import, division, print_function, unicode_literals" }),
  }),

  s("fenco", {
    t({ "# coding: utf-8", "from __future__ import absolute_import, division, print_function, unicode_literals" }),
  }),

  -- Control flow
  s("if", {
    t("if "),
    i(1, "condition"),
    t({ ":", "    " }),
    i(0),
  }),

  s("elif", {
    t("elif "),
    i(1, "condition"),
    t({ ":", "    " }),
    i(0),
  }),

  s("else", {
    t({ "else:", "    " }),
    i(0),
  }),

  s("ifelse", {
    t("if "),
    i(1, "condition"),
    t({ ":", "    " }),
    i(2, "action"),
    t({ "", "else:", "    " }),
    i(0),
  }),

  -- Loops
  s("for", {
    t("for "),
    i(1, "target"),
    t(" in "),
    i(2, "iterable"),
    t({ ":", "    " }),
    i(0),
  }),

  s("forr", {
    t("for "),
    i(1, "target"),
    t(" in range("),
    i(2, "..."),
    t({ "):", "    " }),
    i(0),
  }),

  s("while", {
    t("while "),
    i(1, "condition"),
    t({ ":", "    " }),
    i(0),
  }),

  s("dowhile", {
    t({ "do = True", "while do or " }),
    i(1),
    t({ ":", "    do = False", "    " }),
    i(0),
  }),

  -- Comprehensions
  s("lc", {
    t("["),
    i(1, "expr"),
    t(" for "),
    i(2, "item"),
    t(" in "),
    i(3, "iterable"),
    t("]"),
    i(0),
  }),

  s("lcie", {
    t("["),
    i(1, "expr1"),
    t(" if "),
    i(2, "condition"),
    t(" else "),
    i(3, "expr2"),
    t(" for "),
    i(4, "item"),
    t(" in "),
    i(5, "iterable"),
    t("]"),
    i(0),
  }),

  s("lci", {
    t("["),
    i(1, "expr"),
    t(" for "),
    i(2, "item"),
    t(" in "),
    i(3, "iterable"),
    t(" if "),
    i(4, "condition"),
    t("]"),
    i(0),
  }),

  s("dc", {
    t("{"),
    i(1, "key"),
    t(": "),
    i(2, "value"),
    t(" for "),
    i(3, "k"),
    t(", "),
    i(4, "v"),
    t(" in "),
    i(5, "items"),
    t("}"),
    i(0),
  }),

  s("dci", {
    t("{"),
    i(1, "key"),
    t(": "),
    i(2, "value"),
    t(" for "),
    i(3, "k"),
    t(", "),
    i(4, "v"),
    t(" in "),
    i(5, "items"),
    t(" if "),
    i(6, "condition"),
    t("}"),
    i(0),
  }),

  s("sc", {
    t("{"),
    i(1, "item"),
    t(" for "),
    i(2, "item"),
    t(" in "),
    i(3, "iterable"),
    t("}"),
    i(0),
  }),

  s("sci", {
    t("{"),
    i(1, "item"),
    t(" for "),
    i(2, "item"),
    t(" in "),
    i(3, "iterable"),
    t(" if "),
    i(4, "condition"),
    t("}"),
    i(0),
  }),

  s("gc", {
    t("("),
    i(1, "item"),
    t(" for "),
    i(2, "item"),
    t(" in "),
    i(3, "iterable"),
    t(")"),
    i(0),
  }),

  s("gci", {
    t("("),
    i(1, "item"),
    t(" for "),
    i(2, "item"),
    t(" in "),
    i(3, "iterable"),
    t(" if "),
    i(4, "condition"),
    t(")"),
    i(0),
  }),

  -- Match/case (Python 3.10+)
  s("match", {
    t("match "),
    i(1, "subject"),
    t({ ":", "    case " }),
    i(2, "pattern"),
    t({ ":", "        " }),
    i(0),
  }),

  s("case", {
    t("case "),
    i(1, "pattern"),
    t({ ":", "    " }),
    i(0),
  }),

  s("casew", {
    t({ "case _:", "    " }),
    i(0),
  }),

  -- Context managers
  s("with", {
    t("with "),
    i(1),
    t(" as "),
    i(2),
    t({ ":", "    " }),
    i(0),
  }),

  s("withf", {
    t("with open("),
    i(1, "filename"),
    t(", 'r') as "),
    i(2, "file"),
    t({ ":", "    " }),
    i(0),
  }),

  s("withsq", {
    t("with sqlite3.connect("),
    i(1, "database"),
    t(") as "),
    i(2, "conn"),
    t({ ":", "    " }),
    i(0),
  }),

  s("witha", {
    t("async with "),
    i(1),
    t(" as "),
    i(2),
    t({ ":", "    " }),
    i(0),
  }),

  -- Functions
  s("def", {
    t("def "),
    i(1, "func"),
    t("("),
    i(2, "args"),
    t(") -> "),
    c(3, { t("None"), i(1) }),
    t({ ":", "    " }),
    c(4, { t("pass"), i(1) }),
    i(0),
  }),

  s("adef", {
    t("async def "),
    i(1, "func"),
    t("("),
    i(2, "args"),
    t(") -> "),
    c(3, { t("None"), i(1) }),
    t({ ":", "    " }),
    c(4, { t("pass"), i(1) }),
    i(0),
  }),

  s("lam", {
    t("lambda "),
    i(1, "x"),
    t(": "),
    i(2, "..."),
  }),

  -- Classes
  s("class", {
    t("class "),
    i(1, "ClassName"),
    t({ ":", "    " }),
    i(0),
  }),

  s("classd", {
    t("class "),
    i(1, "ClassName"),
    t("("),
    i(2, "BaseClass"),
    t({ "):", "    " }),
    i(0),
  }),

  s("classi", {
    t("class "),
    i(1, "ClassName"),
    t("("),
    i(2, "BaseClass"),
    t({ "):", "    " }),
    t('"""'),
    i(3),
    t({ '"""', "    def __init__(self, " }),
    i(4),
    t({ "):", "        " }),
    i(5, "super().__init__()"),
    t({ "", "        self." }),
    i(6),
    t(" = "),
    i(7),
    t({ "", "        " }),
    i(0),
  }),

  s("defst", {
    t("def "),
    i(1, "method"),
    t("(self, "),
    i(2, "args"),
    t(") -> "),
    c(3, { t("None"), i(1) }),
    t({ ":", "    " }),
    i(0),
  }),

  -- Properties and magic methods
  s("property", {
    t({ "@property", "def " }),
    i(1, "attr"),
    t({ "(self):", '    """' }),
    i(2, "docstring"),
    t({ '"""', "    " }),
    i(3),
    t({ "", "", "@" }),
    f(function(args)
      return args[1][1] .. ".setter"
    end, { 1 }),
    t({ "", "def " }),
    f(function(args)
      return args[1][1]
    end, { 1 }),
    t({ "(self, value):", "    " }),
    f(function(args)
      return "self._" .. args[1][1]
    end, { 1 }),
    t(" = value"),
  }),

  s("enum", {
    t({ "from enum import Enum", "", "" }),
    t("class "),
    i(1, "EnumName"),
    t({ "(Enum):", '    """' }),
    i(2, "docstring"),
    t({ '"""', "    " }),
    i(3, "KEY1"),
    t(' = "'),
    i(4, "value1"),
    t({ '"', "    " }),
    i(5, "KEY2"),
    t(' = "'),
    i(6, "value2"),
    t({ '"', "    " }),
    i(0),
  }),

  s("datacls", {
    t({ "from dataclasses import dataclass", "", "" }),
    t({ "@dataclass", "class " }),
    i(1, "ClassName"),
    t("("),
    i(2, "object"),
    t({ "):", '    """' }),
    i(3, "docstring"),
    t({ '"""', "    " }),
    i(4, "attr"),
    t(": "),
    i(5, "type"),
    t(" = "),
    i(6, "default"),
    t({ "", "    " }),
    i(0),
  }),

  s("s", {
    t("self."),
    i(0),
  }),

  s("__", {
    t("__"),
    i(1),
    t("__"),
    i(0),
  }),

  -- Exception handling
  s("except", {
    t("except"),
    i(1),
    t({ ":", "    " }),
    i(0),
  }),

  s("exceptas", {
    t("except "),
    i(1),
    t(" as "),
    i(2),
    t({ ":", "    " }),
    i(0),
  }),

  s("try", {
    t({ "try:", "    " }),
    i(1),
    t({ "", "except " }),
    i(2),
    t(" as "),
    i(3),
    t({ ":", "    " }),
    i(0),
  }),

  s("trya", {
    t({ "try:", "    " }),
    i(1),
    t({ "", "except " }),
    i(2),
    t(" as "),
    i(3),
    t({ ":", "    " }),
    i(4),
    t({ "", "else:", "    " }),
    i(0),
  }),

  s("tryf", {
    t({ "try:", "    " }),
    i(1),
    t({ "", "except " }),
    i(2),
    t(" as "),
    i(3),
    t({ ":", "    " }),
    i(4),
    t({ "", "finally:", "    " }),
    i(0),
  }),

  s("tryef", {
    t({ "try:", "    " }),
    i(1),
    t({ "", "except " }),
    i(2),
    t(" "),
    i(3),
    t(" as "),
    i(4),
    t({ ":", "    " }),
    i(5),
    t({ "", "else:", "    " }),
    i(6),
    t({ "", "finally:", "    " }),
    i(0),
  }),

  -- Docstrings
  s("#docsimple", {
    t({ '"""', "    " }),
    i(1),
    t({ "", "    ", "    " }),
    i(2),
    t({ "", "    ", "    Args:", "        " }),
    i(4),
    t(": "),
    i(5),
    t({ "", "    ", "    Returns:", "        " }),
    i(3),
    t({ "", "    ", "    Example:", "        # " }),
    i(6),
    t({ "", "        " }),
    i(7),
    t({ "", '    """', "" }),
    i(0),
  }),

  s("###function", {
    t({ '"""', "    " }),
    i(1),
    t({ "", "    ", "    " }),
    i(2),
    t({ "", "    ", "    Args:", "        " }),
    i(4),
    t(": "),
    i(5),
    t({ "", "    ", "    Returns:", "        " }),
    i(3),
    t({ "", "    ", "    Example:", "        # " }),
    i(6),
    t({ "", "        " }),
    i(7),
    t({ "", '    """', "" }),
    i(0),
  }),

  s("###class", {
    t({ '"""', "" }),
    i(1),
    t({ "", "", "    Attributes:", "        " }),
    i(3),
    t(": "),
    i(4),
    t({ "", '    """', "" }),
    i(0),
  }),
}
