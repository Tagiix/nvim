-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.opt.clipboard = "unnamedplus" -- sync with system clipboard
vim.opt.textwidth = 160
vim.opt.undofile = true -- persist undo history across sessions

-- Use a project's .venv automatically: if one exists in the directory nvim was
-- started from (or a parent), put it first on PATH so python3, the terminal,
-- the language server, tests and <leader>rp all use it. Runs here, before
-- plugins load, so the LSP starts with the right interpreter. Does nothing if
-- a venv is already active in the shell.
local is_win = vim.fn.has("win32") == 1
if not vim.env.VIRTUAL_ENV then
  local venv = vim.fs.find(".venv", { upward = true, type = "directory", path = vim.fn.getcwd() })[1]
  local bin = venv and (venv .. (is_win and "/Scripts" or "/bin"))
  if bin and vim.fn.executable(bin .. (is_win and "/python.exe" or "/python")) == 1 then
    vim.env.VIRTUAL_ENV = venv
    vim.env.PATH = bin .. (is_win and ";" or ":") .. vim.env.PATH
  end
end

-- Load local secrets (API keys etc.) — file is gitignored, won't error if missing
pcall(require, "config.secrets")
