return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-neotest/neotest-python",
  },
  keys = {
    { "<leader>tr", function() require("neotest").run.run() end, desc = "Test: Run nearest" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: Run file" },
    { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test: Output" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test: Summary" },
  },
  opts = {
    adapters = {
      ["neotest-python"] = {
        runner = "pytest",
      },
    },
  },
}
