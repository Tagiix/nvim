return {
  "rmagatti/goto-preview",
  event = "LspAttach",
  opts = {
    width = 120,
    height = 25,
    border = "rounded",
    default_mappings = false,
    post_open_hook = function(_, win)
      vim.keymap.set("n", "q",     "<cmd>close<cr>", { buffer = true, nowait = true })
      vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = true, nowait = true })
    end,
  },
  keys = {
    { "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>",      desc = "Preview definition" },
    { "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<cr>",      desc = "Preview references" },
    { "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>",  desc = "Preview implementation" },
    { "gpt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<cr>", desc = "Preview type definition" },
    { "gpq", "<cmd>lua require('goto-preview').close_all_win()<cr>",               desc = "Close all previews" },
  },
}
