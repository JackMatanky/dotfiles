return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
         dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        -- You can add plugin options here if needed
        opts = {},
        config = function(_, opts)
            require('render-markdown').setup(opts)
        end
    }
}
