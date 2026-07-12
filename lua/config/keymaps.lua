-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local ls = require("luasnip")

-- LuaSnip navigation
vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

-- Cycle through snippet choices
vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

-- Doc viewer — open any file in docs/ as a floating window
local function open_doc(filename)
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

-- Cheatsheet floating window (<leader>?)
vim.keymap.set("n", "<leader>?", function()
  local path = vim.fn.stdpath("config") .. "/cheatsheet.md"
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
    title = "  Cheatsheet  ", title_pos = "center",
  })
  vim.bo[buf].modifiable = false
  vim.wo[win].wrap = false
  vim.wo[win].scrolloff = 4
  vim.keymap.set("n", "q",     "<cmd>close<cr>", { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, nowait = true, silent = true })
end, { desc = "Cheatsheet" })

-- Plugin docs (<leader>nt already taken by neovim-tips)
vim.keymap.set("n", "<leader>dl", function() open_doc("leetcode.md") end, { desc = "Docs: LeetCode" })
