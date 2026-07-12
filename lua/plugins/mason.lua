return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",   -- C++ LSP
        "pyright",  -- Python LSP
        "texlab",   -- LaTeX LSP
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    config = function() end, -- LazyVim owns lspconfig setup
  },
}
