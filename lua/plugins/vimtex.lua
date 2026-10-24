-- LazyVim's lang.tex extra already loads vimtex + texlab + treesitter.
-- This file only overrides specific settings.
return {
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_view_method = vim.fn.has("win32") == 1 and "general" or "zathura"
      vim.g.vimtex_compiler_latexmk = {
        out_dir = "build",
      }
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
