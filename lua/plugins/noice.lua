return {
  "folke/noice.nvim",
  opts = {
    routes = {
      -- LazyVim's own default route (long write-confirmation messages -> mini
      -- view). Re-declared here because LazyVim merges `opts.routes` by array
      -- index, not by concatenation, so this file's routes would otherwise
      -- silently replace it instead of adding to it.
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
      {
        filter = {
          event = "lsp",
          kind = "progress",
          find = "pyright",
        },
        opts = { skip = true },
      },
      -- Ruler/file-info messages (e.g. <C-g>: `"path" line N of M --NN%-- col C`).
      -- These have kind = "" so they'd otherwise go to the "notify" view, which
      -- Snacks caps at 40% of window width -- long paths get clipped and the
      -- line number falls off-screen. "mini" sizes to content instead.
      {
        filter = {
          event = "msg_show",
          find = "%-%-%d+%%%-%-",
        },
        view = "mini",
      },
    },
  },
}
