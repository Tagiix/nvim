-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.opt.clipboard = "unnamedplus" -- sync with system clipboard
vim.opt.textwidth = 160

-- Load local secrets (API keys etc.) — file is gitignored, won't error if missing
pcall(require, "config.secrets")
