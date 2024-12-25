-- Filename: ~/dotfiles/nvim/lua/plugins/snacks.lua
--
-- GitHub Repo: https://github.com/folke/snacks.nvim
return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            bigfile = {enabled = true},
            input = {enabled = true},
            notifier = {enabled = true},
            quickfile = {enabled = true},
            scroll = {enabled = true},
            statuscolumn = {enabled = true},
            words = {enabled = true},
            -- Configure indent highlighting
            indent = {
                enabled = true,
                char = "│", -- Set the indent character
                only_scope = false, -- Show indent guides for all scopes
                only_current = false, -- Show indent guides in all windows
                hl = function(level)
                    local colors = require("catppuccin.palettes").get_palette(vim.g.colors_name)
                    local highlight_groups = {}
                    -- Create highlight groups dynamically based on color palette
                    local indent_colors = {
                        colors.lavender,
                        colors.flamingo,
                        colors.pink,
                        colors.mauve,
                        colors.red,
                        colors.maroon,
                        colors.peach,
                        colors.yellow,
                        colors.green,
                        colors.teal,
                        colors.sky,
                        colors.sapphire,
                        colors.blue
                    }
                    for i = 1, #indent_colors do
                        local group_name = "SnacksIndent" .. i
                        vim.api.nvim_set_hl(0, group_name, {fg = indent_colors[i], bold = false})
                        table.insert(highlight_groups, group_name)
                    end
                    return highlight_groups
                end
            },
            dashboard = {
                preset = {
                    header = [[
                                              
       ████ ██████           █████      ██
      ███████████             █████ 
      █████████ ███████████████████ ███   ███████████
     █████████  ███    █████████████ █████ ██████████████
    █████████ ██████████ █████████ █████ █████ ████ █████
  ███████████ ███    ███ █████████ █████ █████ ████ █████
 ██████  █████████████████████ ████ █████ █████ ████ ██████
                ]],
                     keys = {
                         {icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')"},
                         {icon = " ", key = "n", desc = "New File", action = ":ene | startinsert"},
                         {icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')"},
                         {
                             icon = " ",
                             key = "r",
                             desc = "Recent Files",
                             action = ":lua Snacks.dashboard.pick('oldfiles')"
                         },
                         {
                             icon = " ",
                             key = "c",
                             desc = "Config",
                             action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})"
                         },
                         {icon = " ", key = "s", desc = "Restore Session", section = "session"},
                         {icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras"},
                         {icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy"},
                         {icon = " ", key = "q", desc = "Quit", action = ":qa"}
                     }
                 }
             },
             -- Add these routes for similar behavior to your noice.nvim setup
             routes = {
                 {
                     filter = {
                         event = "msg_show",
                         any = {
                             {find = "%d+L, %d+B"},
                             {find = "; after #%d+"},
                             {find = "; before #%d+"}
                         }
                     },
                     view = "mini" -- Use the mini view for these messages
                 }
             },
             -- If you want the bottom search and command palette features
             cmdline = {
                 enabled = true, -- Enable the enhanced command line
                 bottom = true, -- Show the command line at the bottom
                 palette = {
                     enabled = true -- Enable the command palette
                 }
             }
         }
     }
 }
