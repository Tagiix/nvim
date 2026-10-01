# Python in Neovim — Guide

Plugin: `lazyvim.plugins.extras.lang.python` · Config: `lua/plugins/python.lua`
Autocmds + keymaps: `lua/config/autocmds.lua`

---

## What's Installed

| Tool | Role |
|------|------|
| **pyright** | LSP: type checking, completions, go-to-definition, hover |
| **ruff** | Linter + formatter (replaces flake8, black, isort) |
| **venv-selector.nvim** | Virtual environment picker |
| **nvim-treesitter** | Python syntax highlighting and text objects |

All installed automatically via Mason on first launch — no manual setup.

---

## Python-Only Keymaps  (only active in `.py` files)

| Key | Action |
|-----|--------|
| `<leader>Dp` | Open this Python guide |
| `<leader>rp` | Run current file in a terminal (`python3 %`) |
| `<leader>ri` | Open interactive Python REPL |

---

## LSP Features  (pyright)

These work everywhere via LazyVim's defaults:

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Show all references |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `<leader>ca` | Code action (auto-fix, organize imports, …) |
| `<leader>cr` | Rename symbol across the project |
| `<leader>cd` | Show diagnostics for current line |
| `[d` / `]d` | Jump to previous/next diagnostic |
| `<leader>xx` | Toggle diagnostics list (trouble.nvim) |

### Type checking modes

Edit `lua/plugins/python.lua` to change strictness:

```lua
return {
  { import = "lazyvim.plugins.extras.lang.python" },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",  -- "off" | "basic" | "standard" | "strict"
              },
            },
          },
        },
      },
    },
  },
}
```

---

## Formatting with Ruff

Ruff replaces black + isort — it formats and sorts imports in one pass, and is ~100x faster.

| Key | Action |
|-----|--------|
| `<leader>cf` | Format current file |

Ruff respects `pyproject.toml` or `ruff.toml` in your project root.

**Common ruff config** — add to your project's `pyproject.toml`:

```toml
[tool.ruff]
line-length = 100

[tool.ruff.lint]
select = ["E", "F", "I"]   # pycodestyle, pyflakes, isort
ignore = ["E501"]           # ignore line-too-long if you prefer
```

---

## Virtual Environments

### Selecting a venv

```
<leader>cv
```

Opens a picker listing all virtualenvs found in your home directory (`.venv`, `venv`, `env`, conda envs, etc.).
Selecting one tells **pyright and ruff** to use that environment's Python and installed packages.

### Creating a venv from the terminal

Press `<leader>ri` to open a Python REPL, then `<C-\><C-n>` to get back to normal mode,
or use `<leader>ft` (LazyVim's floating terminal) and run:

```bash
cd /your/project
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Then use `<leader>cv` to select the `.venv` you just created.

---

## Running Python Files

### Run current file

```
<leader>rp
```

Opens a terminal and executes `python3 /path/to/current/file.py`.
The terminal stays open so you can read the output.

**Close the terminal** — press `q` or `<Esc>` if it's a floating terminal,
or `:bd!` to force-close a buffer terminal.

### Interactive REPL

```
<leader>ri
```

Opens an interactive `python3` session. Useful for quick experiments.

**Tips in the REPL:**
- `import <module>` works if you activated the right venv (`<leader>cv`)
- Use `exit()` or `Ctrl-D` to quit
- Use `<C-\><C-n>` to leave terminal insert mode without closing it

### LazyVim's built-in terminal

```
<leader>ft    floating terminal
<leader>fT    terminal in current directory
```

These open a full shell — use them for `pip install`, `pytest`, `git`, etc.

---

## Linting

Ruff runs as an LSP source and shows diagnostics inline as you type.
Errors and warnings appear in the sign column; hover over them with `K` or check with `<leader>cd`.

**Run ruff manually** from the terminal:

```bash
ruff check .          # lint all files
ruff check --fix .    # auto-fix fixable errors
ruff format .         # format all files
```

---

## Testing

neotest + neotest-python are set up (`lua/plugins/neotest.lua`), running pytest.
pytest itself must be installed in the project's venv.

| Key | Action |
|-----|--------|
| `<leader>tr` | Run the test under the cursor |
| `<leader>tf` | Run all tests in this file |
| `<leader>to` | Show test output |
| `<leader>ts` | Toggle the test summary panel |

Or from a terminal (`<C-/>`):

```
pytest tests/   # run your test suite
pytest -x       # stop at first failure
pytest -v       # verbose
pytest -k "my_test_name"  # run a specific test
```

---

## Debugging

nvim-dap + nvim-dap-python are installed, with debugpy from Mason.

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` | Start / continue |
| `<leader>dO` | Step over |
| `<leader>di` / `<leader>do` | Step into / out |
| `<leader>dC` | Run to cursor |
| `<leader>du` | Toggle DAP UI |
| `<leader>dt` | Terminate |
| `<leader>dPt` | Debug the test method under the cursor |
| `<leader>dPc` | Debug the test class under the cursor |

---

## Useful Commands

| Command | Action |
|---------|--------|
| `:Mason` | Open Mason UI — install/uninstall tools |
| `:LspInfo` | Show active LSP servers for current file |
| `:LspRestart` | Restart LSP (useful after installing packages) |
| `<leader>cv` | Select virtualenv |
| `<leader>cf` | Format with ruff |

---

## Tips

**LSP doesn't see my installed packages?**
You need to select the right virtualenv. Run `<leader>cv` and pick the venv
that has your packages. Then `:LspRestart` to reload pyright.

**Ruff isn't formatting on save?**
LazyVim formats on save by default. If it's not working, check `:ConformInfo`
to see which formatter is active for python files.

**Imports not being auto-sorted?**
Ruff handles this via `ruff_organize_imports` formatter. Use `<leader>ca` →
"Organize imports" for a one-shot sort, or add it to `formatters_by_ft` in
`lua/plugins/python.lua` for auto-sort on save.

**False positive type errors from pyright?**
Lower the type checking mode to `"basic"` or `"off"` for loose codebases.
Or add `# type: ignore` at the end of a line to suppress a specific error.

**Speed up diagnostics in large files?**
pyright is fast but can lag in huge files. Lower `typeCheckingMode`
or disable `diagnosticMode = "workspace"` to only check open files.
