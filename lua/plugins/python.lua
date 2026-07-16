-- LazyVim's Python extra bundles: basedpyright, ruff (lint + format), venv-selector, treesitter
return {
  { import = "lazyvim.plugins.extras.lang.python" },
  {
    "linux-cultist/venv-selector.nvim",
    opts = {
      auto_refresh = true,
      search_venv_managers = false,
      parents = 2, -- search up to 2 directories above the current file
    },
  },
}
