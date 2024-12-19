-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "bash",
    "css",
    "go",
    "html",
    "javascript",
    "json",
    "kdl",
    "lua",
    "markdown",
    "markdown_inline",
    "org",
    "python",
    "regex",
    "rust",
    "sql",
    "terraform",
    "toml",
    "typescript",
    "yaml",
  },

  highlight = { enable = true },
  indent = { enable = true },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      node_decremental = "<c-backspace>",
      scope_incremental = "<c-s>",
    },
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = "@parameter.outer",
        ['ia'] = "@parameter.inner",
        ['af'] = "@function.outer",
        ['if'] = "@function.inner",
        ['ac'] = "@class.outer",
        ['ic'] = "@class.inner",
        ['ai'] = "@conditional.outer",
        ['ii'] = "@conditional.inner",
        ['al'] = "@loop.outer",
        ['il'] = "@loop.inner",
        ['at'] = "@comment.outer",
      },
    },

    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']f'] = "@function.outer",
        [']]'] = "@class.outer",
      },
      goto_next_end = {
        [']F'] = "@function.outer",
        [']['] = "@class.outer",
      },
      goto_previous_start = {
        ['[f'] = "@function.outer",
        ['[['] = "@class.outer",
      },
      goto_previous_end = {
        ['[F'] = "@function.outer",
        ['[]'] = "@class.outer",
      },
    },

    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = "@parameter.inner",
      },
      swap_previous = {
        ['<leader>A'] = "@parameter.inner",
      },
    },
  },
}
