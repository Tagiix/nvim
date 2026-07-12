-- LuaSnip: snippet engine + LaTeX snippet pack
-- Keybindings for snippet navigation are in lua/config/keymaps.lua
--
-- Custom snippet files live in lua/plugins/luasnips/tex/ and luasnips/bib.lua
-- To activate them, uncomment the loader call below and set your config path:
--   require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/lua/plugins/luasnips/" })
return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    opts = { enable_autosnippets = true },
  },
  {
    "evesdropper/luasnip-latex-snippets.nvim",
  },
}
