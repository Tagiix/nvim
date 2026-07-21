-- LazyVim's lang.tex extra already loads vimtex + texlab + treesitter.
-- This file only overrides specific settings.
return {
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_view_method = "sioyek"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              chktex = {
                onOpenAndSave = false,
                onEdit = false,
              },
            },
          },
        },
      },
    },
  },
}
