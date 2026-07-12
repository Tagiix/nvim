# Neovim Configuration

Personal Neovim config built on top of [LazyVim](https://lazyvim.github.io/).
LazyVim provides opinionated defaults for LSP, Treesitter, fuzzy finding, and
more — this config layers personal plugins and snippets on top of it.

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                          # Entry point — just bootstraps lazy.nvim
├── lua/
│   ├── config/
│   │   ├── options.lua               # Vim options (clipboard, textwidth, …)
│   │   ├── keymaps.lua               # Custom keybindings (LuaSnip navigation)
│   │   ├── autocmds.lua              # Auto-commands (empty — placeholder)
│   │   ├── lazy.lua                  # Lazy.nvim bootstrap + setup
│   │   └── secrets.lua              # ⚠ GITIGNORED — put API keys here
│   └── plugins/                      # One file per plugin (auto-loaded by lazy)
│       ├── colorscheme.lua           # Catppuccin theme + integration configs
│       ├── bufferline.lua            # Bufferline catppuccin highlight (redundant with colorscheme.lua)
│       ├── cmake-tools.lua           # CMake integration
│       ├── leetcode.lua              # LeetCode plugin (needs nvim-treesitter html)
│       ├── luasnips.lua              # LuaSnip engine + latex-snippets plugin
│       ├── mason.lua                 # LSP installer overrides
│       ├── neovim-tips.lua           # Daily/random Neovim tips popup
│       ├── example.lua               # Disabled reference file (if true then return {} end)
│       └── luasnips/                 # Custom LuaSnip snippet definitions
│           ├── bib.lua               # BibTeX entry snippets
│           └── tex/
│               ├── math.lua          # Math environment, Greek letters, operators, …
│               ├── structure.lua     # Document structure, sectioning, cross-refs
│               ├── formatting.lua    # Fonts, lists, theorem envs, …
│               ├── floats.lua        # Tables, figures, captions
│               ├── fonts.lua         # Font size/style commands
│               └── templates.lua     # Full document templates (if present)
├── neovim_tips/
│   └── user_tips.md                  # Your personal tips shown by neovim-tips plugin
├── plugins/                          # ⚠ ROOT-LEVEL (NOT loaded by lazy.nvim)
│   └── …                             # Dead code / old drafts — safe to ignore
├── lazy-lock.json                    # Plugin version lockfile (commit this)
├── lazyvim.json                      # LazyVim extras selection
└── stylua.toml                       # Lua formatter config
```

---

## Plugins

### Theme
**Catppuccin** (`lua/plugins/colorscheme.lua`) — auto-detects light/dark mode.
LSP diagnostics show as italic virtual text and undercurl underlines.
Integrates with bufferline, gitsigns, telescope, noice, and more.

### Snippets
**LuaSnip** (`lua/plugins/luasnips.lua`) with two sources:
- `evesdropper/luasnip-latex-snippets.nvim` — community LaTeX snippets
- `lua/plugins/luasnips/` — personal snippets (BibTeX + extended LaTeX math)

> **Note**: The personal snippets folder is defined but the loader is commented
> out in `luasnips.lua`. To activate them, uncomment the `require(...)` call
> documented in that file.

### LSP / Tooling
- **Mason** — auto-installs language servers and linters
- **cmake-tools** — CMake project integration (build, run, debug)

### Productivity
- **leetcode.nvim** — solve LeetCode problems inside Neovim
- **neovim-tips** — shows Neovim tips; your custom tips live in `neovim_tips/user_tips.md`

---

## Custom Keybindings

### LuaSnip (insert & select mode)
| Key | Action |
|-----|--------|
| `<C-K>` | Expand snippet |
| `<C-L>` | Jump to next snippet node |
| `<C-J>` | Jump to previous snippet node |
| `<C-E>` | Cycle through snippet choices |

### Neovim Tips (`<leader>nt…`)
| Key | Action |
|-----|--------|
| `<leader>nto` | Open tips browser |
| `<leader>nte` | Edit your tips file |
| `<leader>nta` | Add a new tip |
| `<leader>nth` | Open plugin help |
| `<leader>ntr` | Show a random tip |
| `<leader>ntp` | Open tips as PDF |

---

## Options

Set in `lua/config/options.lua`:
- `clipboard = "unnamedplus"` — yanks go to system clipboard automatically
- `textwidth = 160` — line wrap guide at 160 characters

---

## Secrets / API Keys

API keys (e.g. `GEMINI_API_KEY`) go in `lua/config/secrets.lua`, which is
gitignored. A template is provided. `options.lua` loads it with `pcall` so
Neovim won't error if the file is absent on a new machine.

---

## Updating Plugins

```
:Lazy update       — update all plugins
:Lazy sync         — install missing + update + clean
:Mason             — manage language servers
```

The `lazy-lock.json` file pins exact plugin versions. Commit it so that
`git clone + :Lazy restore` reproduces the exact same setup on a new machine.

---

## Adding a New Plugin

Create a file in `lua/plugins/your-plugin.lua`:

```lua
return {
  "author/plugin-name",
  opts = {
    -- options
  },
}
```

Lazy.nvim auto-discovers all `.lua` files in `lua/plugins/`.
