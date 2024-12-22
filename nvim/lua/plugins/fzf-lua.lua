return {
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
          require("fzf-lua").setup {
            -- Example fzf-lua configuration
            winopts = {
              preview = {
                layout = "vertical",
              },
            },
            fzf_opts = {
              ['--color'] = 'fg:#7F8490,bg:#0F0F14,hl:#82AAFF,fg+:#ABB2BF,bg+:#15151A,hl+:#82AAFF',
              ['--prompt'] = ' ',
            },
          }
          -- Key Bindings
          vim.keymap.set("n", "<leader>ff", ":FzfLua files<CR>")
          vim.keymap.set("n", "<leader>fg", ":FzfLua live_grep<CR>")
          vim.keymap.set("n", "<leader>fb", ":FzfLua buffers<CR>")
          vim.keymap.set("n", "<leader>fh", ":FzfLua help_tags<CR>")
        end,
    }
}
