local M = {}

function M.open_doc(filename)
  local path = vim.fn.stdpath("config") .. "/docs/" .. filename
  local buf = vim.fn.bufadd(path)
  vim.fn.bufload(buf)
  vim.bo[buf].filetype = "markdown"
  local width = math.min(math.floor(vim.o.columns * 0.88), 130)
  local height = math.floor(vim.o.lines * 0.88)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor", width = width, height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal", border = "rounded",
    title = "  " .. filename .. "  ", title_pos = "center",
  })
  vim.bo[buf].modifiable = false
  vim.wo[win].wrap = false
  vim.wo[win].scrolloff = 4
  vim.keymap.set("n", "q",     "<cmd>close<cr>", { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, nowait = true, silent = true })
end

return M
