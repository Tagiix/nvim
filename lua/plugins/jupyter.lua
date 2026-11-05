-- Jupyter notebooks in Neovim. MacBook only: the config is shared with other
-- machines, so this whole file is a no-op unless macOS + `jupytext` exist.
--   jupytext.nvim  opens a .ipynb as plain Python with `# %%` cells (py:percent)
--   molten-nvim    runs code on a Jupyter kernel, output shown under the code
--   image.nvim     draws plots inline (kitty graphics protocol, ImageMagick CLI)
--   <leader>ji init kernel   <leader>jj run cell   <leader>jl run line
--   <leader>jv run selection (visual)   <leader>jr run with motion
--   <leader>jo show output   <leader>jh hide output   <leader>jd delete output
--   <leader>jk restart kernel   <leader>jq stop kernel   ]j / [j next / previous cell
--   <leader>jn / jp next / previous cell (easier than ]j / [j on a French Mac keyboard)
--   <leader>jJ run the cell, then jump to the next one
if vim.fn.has("mac") ~= 1 or vim.fn.executable("jupytext") ~= 1 then
  return {}
end

-- Molten is a Python remote plugin: it needs its own Python with pynvim and
-- jupyter_client (a uv venv, built as logged in mac-dotfiles/NOTES.md).
local host = vim.fn.stdpath("data") .. "/jupyter-host/bin/python"
if vim.fn.executable(host) == 1 then
  vim.g.python3_host_prog = host
end

-- Run the `# %%` cell around the cursor.
local function run_cell()
  local last = vim.api.nvim_buf_line_count(0)
  local cur = vim.api.nvim_win_get_cursor(0)[1]
  local first = 1
  for l = cur, 1, -1 do
    if vim.fn.getline(l):match("^# %%%%") then
      first = l + 1
      break
    end
  end
  local stop = last
  for l = cur + 1, last do
    if vim.fn.getline(l):match("^# %%%%") then
      stop = l - 1
      break
    end
  end
  if first > stop then
    return
  end
  vim.fn.MoltenEvaluateRange(first, stop)
end

return {
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false, -- must be loaded before a .ipynb is opened
    opts = {
      style = "percent",
      output_extension = "auto",
      force_ft = "python",
    },
  },
  {
    "3rd/image.nvim",
    lazy = true,
    opts = {
      backend = "kitty",
      processor = "magick_cli", -- uses the `magick` binary, no luarocks needed
      integrations = { markdown = { enabled = false }, neorg = { enabled = false } },
      max_height_window_percentage = 40,
      window_overlap_clear_enabled = true,
    },
  },
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    ft = { "python" },
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_auto_open_output = false
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_wrap_output = true
      vim.g.molten_output_win_max_height = 20
    end,
    keys = {
      { "<leader>ji", "<cmd>MoltenInit<cr>", desc = "Jupyter: init kernel" },
      { "<leader>jj", run_cell, desc = "Jupyter: run cell" },
      { "<leader>jl", "<cmd>MoltenEvaluateLine<cr>", desc = "Jupyter: run line" },
      { "<leader>jv", ":<C-u>MoltenEvaluateVisual<cr>gv", mode = "v", desc = "Jupyter: run selection" },
      { "<leader>jr", "<cmd>MoltenEvaluateOperator<cr>", desc = "Jupyter: run with motion" },
      { "<leader>jo", "<cmd>noautocmd MoltenEnterOutput<cr>", desc = "Jupyter: show output" },
      { "<leader>jh", "<cmd>MoltenHideOutput<cr>", desc = "Jupyter: hide output" },
      { "<leader>jd", "<cmd>MoltenDelete<cr>", desc = "Jupyter: delete output" },
      { "<leader>jk", "<cmd>MoltenRestart!<cr>", desc = "Jupyter: restart kernel" },
      { "<leader>jq", "<cmd>MoltenDeinit<cr>", desc = "Jupyter: stop kernel" },
      { "]j", [[/^# %%<cr>:noh<cr>]], desc = "Next cell" },
      { "[j", [[?^# %%<cr>:noh<cr>]], desc = "Previous cell" },
      { "<leader>jn", [[/^# %%<cr>:noh<cr>]], desc = "Jupyter: next cell" },
      { "<leader>jp", [[?^# %%<cr>:noh<cr>]], desc = "Jupyter: previous cell" },
      {
        "<leader>jJ",
        function()
          run_cell()
          vim.cmd([[silent! /^# %%/]])
          vim.cmd("noh")
        end,
        desc = "Jupyter: run cell and go to next",
      },
    },
  },
}
