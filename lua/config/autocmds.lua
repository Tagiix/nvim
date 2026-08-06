-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local open_doc = require("util").open_doc

-- LazyVim's VimResized runs `tabdo wincmd =` which equalizes all windows in
-- every tab. This breaks leetcode.nvim layouts (menu splits in two, etc.).
vim.api.nvim_del_augroup_by_name("lazyvim_resize_splits")

-- Python: buffer-local keymaps (only active in .py files)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function(ev)
    -- Open the Python guide (<leader>Dp, visible in which-key only in Python files)
    vim.keymap.set("n", "<leader>Dp", function()
      open_doc("python.md")
    end, { buffer = ev.buf, desc = "Docs: Python" })

    -- Run current file in a floating terminal
    vim.keymap.set("n", "<leader>rp", function()
      Snacks.terminal({ "python3", vim.fn.expand("%:p") }, { auto_close = false })
    end, { buffer = ev.buf, desc = "Run Python file" })

    -- Open an interactive Python REPL
    vim.keymap.set("n", "<leader>ri", function()
      Snacks.terminal("python3")
    end, { buffer = ev.buf, desc = "Python REPL" })
  end,
})

-- LaTeX: buffer-local doc keymap (only active in .tex files)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function(ev)
    vim.keymap.set("n", "<leader>Dt", function()
      open_doc("latex.md")
    end, { buffer = ev.buf, desc = "Docs: LaTeX" })
  end,
})

-- C/C++: 4-space indent + buffer-local keymaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function(ev)
    vim.bo[ev.buf].tabstop = 4
    vim.bo[ev.buf].shiftwidth = 4
    vim.bo[ev.buf].expandtab = true

    vim.keymap.set("n", "<leader>Dc", function()
      open_doc("cpp.md")
    end, { buffer = ev.buf, desc = "Docs: C++" })

    -- cppman: cppreference docs for word under cursor (requires: sudo pacman -S cppman && cppman -c)
    vim.keymap.set("n", "<leader>K", function()
      Snacks.terminal({ "cppman", "-p", "less", vim.fn.expand("<cword>") })
    end, { buffer = ev.buf, desc = "cppman docs" })
  end,
})

-- Tutor: fall back to plain sign rendering. Snacks' statuscolumn dedupes
-- same-line signs by keeping the first extmark it sees, but :Tutor's own
-- line-highlight extmark (no sign_text) is created before its ✓/✗ mark
-- extmark, so Snacks picks the blank one and the ✓/✗ never shows.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tutor",
  callback = function()
    vim.opt_local.statuscolumn = ""
  end,
})

-- Auto-commit lazy-lock.json after `:Lazy update`/`:Lazy sync` (local commit only, push manually)
vim.api.nvim_create_autocmd("User", {
  pattern = "LazySync",
  callback = function()
    vim.system({
      "git",
      "-C",
      vim.fn.stdpath("config"),
      "commit",
      "-m",
      "Update lazy-lock.json",
      "--",
      "lazy-lock.json",
    })
  end,
})
