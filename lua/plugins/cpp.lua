local nproc = vim.trim(vim.fn.system("nproc"))

return {
  -- Override clangd args: use all CPU threads, enable clang-tidy, IWYU-aware headers
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.clangd = opts.servers.clangd or {}
      opts.servers.clangd.cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-detail",
        "--fallback-style=google",
        "-j=" .. nproc,
      }
      return opts
    end,
  },

  -- clangd_extensions: memory layout, type hierarchy, AST viewer
  {
    "p00f/clangd_extensions.nvim",
    opts = {
      inlay_hints = {
        -- Use Neovim native inlay hints (toggleable via <leader>uh)
        inline = false,
      },
    },
  },

  -- Compiler Explorer (Godbolt) — select code, see generated assembly
  {
    "krady21/compiler-explorer.nvim",
    dependencies = { "stevearc/dressing.nvim" },
    cmd = { "CECompile", "CECompileLive", "CEFormat", "CEAddLibrary" },
    keys = {
      { "<leader>ce", "<cmd>CECompile<cr>",     desc = "Compiler Explorer",        ft = "cpp" },
      { "<leader>cE", "<cmd>CECompileLive<cr>", desc = "Compiler Explorer (live)", ft = "cpp" },
    },
  },

  -- 4-space indent for C/C++ (LazyVim defaults to 2)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "cpp", "c", "cmake" })
    end,
  },
}
