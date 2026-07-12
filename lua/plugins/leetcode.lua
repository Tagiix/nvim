return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    -- Default language for new problems. Switch per-problem with :Leet lang
    lang = "cpp",

    -- Code injected automatically at the top of every solution file.
    -- Saves you from typing boilerplate every time.
    injector = {
      ["cpp"] = {
        before = { "#include <bits/stdc++.h>", "using namespace std;" },
      },
      ["python3"] = {
        before = "from typing import List, Optional, Dict, Tuple, Set",
      },
    },

    description = {
      position = "left",
      width = "40%",
      show_stats = true, -- show difficulty + acceptance % in the pane
    },
  },
}
