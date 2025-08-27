-- TODO: temporary fix for bufferline integration
--https://github.com/LazyVim/LazyVim/issues/6355#issuecomment-3212986215
return {
  {
    "catppuccin/nvim",
    opts = function(_, opts)
      local module = require("catppuccin.groups.integrations.bufferline")
      if module then
        -- temporarily alias the missing function
        module.get = module.get_theme
      end
      return opts
    end,
  },
}
