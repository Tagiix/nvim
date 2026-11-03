-- LazyVim's lang.tex extra already loads vimtex + texlab + treesitter.
-- This file only overrides specific settings.
return {
  {
    "lervag/vimtex",
    config = function()
      -- vimtex's "not in a comment" regex uses a lookbehind that makes Vim's
      -- NFA engine take >1s on a normal preamble (0.7ms with the backtracking
      -- engine). Force engine 1 for that pattern; it is always used at pattern start.
      vim.cmd("runtime autoload/vimtex/re.vim")
      local re = vim.g["vimtex#re#not_comment"]
      if re and not re:find("\\%#=", 1, true) then
        vim.g["vimtex#re#not_comment"] = "\\%#=1" .. re
      end
    end,
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
