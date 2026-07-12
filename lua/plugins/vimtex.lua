-- LazyVim's lang.tex extra already loads vimtex + texlab + treesitter.
-- This file only sets the compiler engine to LuaLaTeX (the extra leaves it as pdflatex).
return {
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_compiler_latexmk_engines = { _ = "-lualatex" }
    end,
  },
}
