return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",  -- C++ LSP
        "pyright", -- Python LSP
        -- texlab and basedpyright handled by lang.tex and lang.python extras
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    config = function() end, -- LazyVim owns lspconfig setup
  },
}
