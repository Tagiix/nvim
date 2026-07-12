-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local open_doc = require("util").open_doc

-- Python: buffer-local keymaps (only active in .py files)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function(ev)
    -- Open the Python guide (<leader>dp, visible in which-key only in Python files)
    vim.keymap.set("n", "<leader>dp", function()
      open_doc("python.md")
    end, { buffer = ev.buf, desc = "Docs: Python" })

    -- Run current file in a floating terminal
    vim.keymap.set("n", "<leader>rp", function()
      Snacks.terminal.open("python3 " .. vim.fn.shellescape(vim.fn.expand("%:p")))
    end, { buffer = ev.buf, desc = "Run Python file" })

    -- Open an interactive Python REPL
    vim.keymap.set("n", "<leader>ri", function()
      Snacks.terminal.open("python3")
    end, { buffer = ev.buf, desc = "Python REPL" })
  end,
})
