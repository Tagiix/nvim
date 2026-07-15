# Neovim Configuration

Personal Neovim config built on top of [LazyVim](https://lazyvim.github.io/).
LazyVim provides opinionated defaults for LSP, Treesitter, fuzzy finding, and
more — this config layers personal plugins and snippets on top of it.

---

## Installation

```bash
# 1. Install dependencies (Arch Linux)
sudo pacman -S neovim git ripgrep fd unzip nodejs npm
sudo pacman -S clang cmake ninja          # C++ toolchain
sudo pacman -S cppman && cppman -c        # C++ stdlib docs (cppreference, ~5 min cache)
sudo pacman -S zathura zathura-pdf-mupdf # LaTeX PDF viewer

# 2. Install a Nerd Font and set it in your terminal
#    → https://www.nerdfonts.com

# 3. Clone the config
git clone https://github.com/Tagiix/nvim ~/.config/nvim

# 4. Symlink external config files (clangd, etc.)
~/.config/nvim/install.sh

# 5. Start Neovim — lazy.nvim auto-installs all plugins (~1 min on first launch)
nvim
```

### What `install.sh` sets up

| Symlink created | Source in this repo |
|-----------------|---------------------|
| `~/.config/clangd/config.yaml` | `config/clangd/config.yaml` |

The clangd config enables strict diagnostics and clang-tidy checks (modernize, bugprone, performance, readability). Re-run `install.sh` if you add more external configs in the future.

### API Keys (optional)

Create `~/.config/nvim/lua/config/secrets.lua` (gitignored):

```lua
vim.fn.setenv("GEMINI_API_KEY", "your-key-here")
```

---

## Directory Structure

```
~/.config/nvim/
├── install.sh                        # Symlinks external configs (run after clone)
├── init.lua                          # Entry point — bootstraps lazy.nvim
├── cheatsheet.md                     # In-Neovim cheatsheet (<leader>?)
├── config/
│   └── clangd/
│       └── config.yaml               # clangd diagnostics + clang-tidy config
│                                     # (symlinked to ~/.config/clangd/config.yaml)
├── docs/                             # Guides opened as floating windows
│   ├── cpp.md                        # C++ workflow guide (<leader>Dc, .cpp only)
│   ├── leetcode.md                   # LeetCode workflow guide (<leader>Dl)
│   ├── luasnip.md                    # LuaSnip reference (<leader>Ds)
│   ├── python.md                     # Python dev guide (<leader>Dp, .py only)
│   └── latex.md                      # LaTeX guide (<leader>Dt, .tex only)
├── lua/
│   ├── util.lua                      # Shared helpers (open_doc floating window)
│   ├── config/
│   │   ├── options.lua               # Vim options (clipboard, textwidth, …)
│   │   ├── keymaps.lua               # Custom keybindings
│   │   ├── autocmds.lua              # Filetype-specific keymaps (C++, Python, LaTeX)
│   │   ├── lazy.lua                  # Lazy.nvim bootstrap
│   │   └── secrets.lua              # ⚠ GITIGNORED — API keys go here
│   └── plugins/                      # One file per plugin (auto-loaded by lazy)
│       ├── colorscheme.lua           # Catppuccin theme
│       ├── cpp.lua                   # C++ (clangd tuning, compiler-explorer, treesitter)
│       ├── cmake-tools.lua           # CMake integration (Ninja, keymaps on <leader>m)
│       ├── leetcode.lua              # LeetCode plugin
│       ├── luasnips.lua              # LuaSnip engine + from_lua loader
│       ├── mason.lua                 # LSP installer (clangd, codelldb, pyright)
│       ├── python.lua                # Python extra (basedpyright, ruff, venv-selector)
│       ├── vimtex.lua                # LaTeX (viewer + ChkTeX config)
│       ├── neovim-tips.lua           # Neovim tips popup
│       └── luasnips/                 # Custom LuaSnip snippets
│           ├── bib.lua               # BibTeX entry snippets (.bib)
│           └── tex/                  # LaTeX snippets (.tex)
│               ├── math.lua          # Math envs, Greek, operators, matrices, …
│               ├── structure.lua     # Sections, labels, cross-refs
│               ├── formatting.lua    # Theorem envs, lists, fonts
│               ├── floats.lua        # Tables, figures, captions
│               ├── fonts.lua         # Font size/style commands
│               └── templates.lua     # Full document templates
├── lazy-lock.json                    # Plugin version lockfile (committed)
└── lazyvim.json                      # LazyVim extras
```

---

## Plugins & Language Support

| Language | LSP | Formatter | Extra |
|----------|-----|-----------|-------|
| C++ | clangd | clang-format | `lang.clangd` |
| Python | basedpyright | ruff | `lang.python` |
| LaTeX | texlab | — | `lang.tex` + vimtex |
| Rust | rust-analyzer | rustfmt | `lang.rust` |
| JSON | jsonls | prettier | `lang.json` |
| Markdown | — | prettier | `lang.markdown` |

### Other plugins
- **LuaSnip** — snippet engine with custom LaTeX/BibTeX snippets
- **leetcode.nvim** — solve LeetCode problems inside Neovim (C++ / Python3)
- **vimtex** — LaTeX compilation (latexmk), PDF viewing (Zathura), text objects
- **Catppuccin** — auto light/dark theme
- **cmake-tools** — CMake build integration
- **neovim-tips** — Neovim tips popup

---

## Keybindings

`<leader>` = Space

### Docs & Cheatsheet

| Key | Opens |
|-----|-------|
| `<leader>?` | Cheatsheet |
| `<leader>Dl` | LeetCode guide |
| `<leader>Ds` | LuaSnip guide |
| `<leader>Dp` | Python guide _(in .py files)_ |
| `<leader>Dt` | LaTeX guide _(in .tex files)_ |
| `<leader>Dc` | C++ workflow guide _(in .cpp/.c files)_ |

### C++ _(in .cpp/.c files)_

| Key | Action |
|-----|--------|
| `<leader>mx` | Select build type (Debug / Release / …) |
| `<leader>mg` | Configure project (CMake generate) |
| `<leader>mb` | Build selected target |
| `<leader>mr` | Run selected target |
| `<leader>md` | Debug selected target (DAP + codelldb) |
| `<leader>mc` | Clean build |
| `<leader>mt` | Select target |
| `<leader>mi` | CMake project info |
| `<leader>K`  | cppman: full cppreference docs for symbol under cursor |
| `<leader>ce` | Compiler Explorer (Godbolt) |
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue / start debugger |
| `<leader>du` | Toggle DAP UI |

### Python _(in .py files)_

| Key | Action |
|-----|--------|
| `<leader>rp` | Run current file |
| `<leader>ri` | Open Python REPL |
| `<leader>cv` | Select virtualenv |

### LeetCode

| Key | Action |
|-----|--------|
| `<leader>ll` | Switch language (C++ / Python3) |

### LaTeX (`<localleader>` = `\`)

| Key | Action |
|-----|--------|
| `\ll` | Start/stop compilation |
| `\lv` | View PDF in Zathura |
| `\lt` | Toggle table of contents |
| `\le` | Show errors |

### LuaSnip _(insert & select mode)_

| Key | Action |
|-----|--------|
| `<C-K>` | Expand snippet |
| `<C-L>` | Jump to next node |
| `<C-J>` | Jump to previous node |
| `<C-E>` | Cycle choices |

---

## Options

Set in `lua/config/options.lua`:
- `clipboard = "unnamedplus"` — yanks go to system clipboard
- `textwidth = 160` — line wrap guide at 160 characters

---

## Updating

```vim
:Lazy update      " update all plugins
:Lazy sync        " install missing + update + clean
:Mason            " manage language servers
```
