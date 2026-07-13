return {
  "folke/noice.nvim",
  opts = {
    routes = {
      {
        filter = {
          event = "lsp",
          kind = "progress",
          find = "pyright",
        },
        opts = { skip = true },
      },
    },
  },
}
