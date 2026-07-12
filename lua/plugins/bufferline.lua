-- NOTE: This bufferline catppuccin integration is also declared in colorscheme.lua
-- under the `specs` key. Lazy.nvim merges duplicate specs, so both files are
-- harmless, but this file can be safely removed if colorscheme.lua is kept.
return {
  {
    "akinsho/bufferline.nvim",
    optional = true,
    opts = function(_, opts)
      if (vim.g.colors_name or ""):find("catppuccin") then
        opts.highlights = require("catppuccin.special.bufferline").get_theme()
      end
    end,
  },
}
