-- LuaSnip: snippet engine + LaTeX snippet pack
-- Keybindings for snippet navigation are in lua/config/keymaps.lua
--
-- Snippet sources (both active):
--   1. evesdropper/luasnip-latex-snippets.nvim  — community math pack
--   2. lua/plugins/luasnips/                     — personal snippets (loaded below)
--        bib.lua          → .bib files  (BibTeX entry types: article, book, …)
--        tex/bibtex.lua   → .tex files  (\cite, \citet, \citep, …)
--        tex/structure.lua→ .tex files  (sections, labels, \ref, \pageref, …)
--        tex/formatting.lua→.tex files  (fonts, lists, theorem envs, proof, …)
--        tex/floats.lua   → .tex files  (tables, figures, captions)
--        tex/fonts.lua    → .tex files  (font sizes: \tiny, \Large, …)
--        tex/math.lua     → .tex files  (math envs, Greek, operators — partial overlap with evesdropper)
--        tex/templates.lua→ .tex files  (full document templates: phy-art, math-notes, writing)
return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    opts = { enable_autosnippets = true },
    config = function(_, opts)
      require("luasnip").setup(opts)
      require("luasnip.loaders.from_lua").load({
        paths = vim.fn.stdpath("config") .. "/lua/plugins/luasnips/",
      })
    end,
  },
  {
    "evesdropper/luasnip-latex-snippets.nvim",
  },
}
