return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  keys = {
    { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
  },
  opts = {
    window = {
      width = 0.75,
    },
    plugins = {
      twilight = { enabled = false },
    },
  },
}
