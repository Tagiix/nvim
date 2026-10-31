-- LazyVim's lang.tex extra already loads vimtex + texlab + treesitter.
-- This file only overrides specific settings.
return {
  {
    "lervag/vimtex",
    init = function()
      if vim.fn.has("win32") == 1 then
        vim.g.vimtex_view_method = "general"
      elseif vim.fn.has("mac") == 1 then
        vim.g.vimtex_view_method = "skim" -- SyncTeX both ways; ⌘⇧-click in Skim jumps to the source
      else
        vim.g.vimtex_view_method = "zathura"
      end
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
