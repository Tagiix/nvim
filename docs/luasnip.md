# LuaSnip — Guide

Plugin: `L3MON4D3/LuaSnip` · Config: `lua/plugins/luasnips.lua`
Your snippets: `lua/plugins/luasnips/`

---

## How It Works

You type a **trigger** word, press `<C-K>` to expand it, then navigate between
**tab stops** with `<C-L>` (forward) and `<C-J>` (backward).

Some snippets are **autosnippets** — they expand the moment you finish typing
the trigger, no keypress needed. Most of your math snippets are autosnippets.

---

## Navigation Keys  (your config)

| Key | Mode | Action |
|-----|------|--------|
| `<C-K>` | insert | Expand snippet at cursor |
| `<C-L>` | insert, select | Jump to **next** node |
| `<C-J>` | insert, select | Jump to **previous** node |
| `<C-E>` | insert, select | Cycle through **choices** (choice nodes) |

---

## Your Snippet Files

Loaded automatically for the matching filetype:

| File | Filetype | What's inside |
|------|----------|--------------|
| `luasnips/bib.lua` | `.bib` | BibTeX entry templates (article, book, …) |
| `luasnips/tex/bibtex.lua` | `.tex` | Citation commands (\cite, \citet, \citep, …) |
| `luasnips/tex/structure.lua` | `.tex` | Sections, labels, \ref, \pageref |
| `luasnips/tex/formatting.lua` | `.tex` | Theorem/proof/lemma envs, lists, fonts |
| `luasnips/tex/floats.lua` | `.tex` | Figures, tables, captions |
| `luasnips/tex/fonts.lua` | `.tex` | Font sizes (\tiny … \Huge) and styles |
| `luasnips/tex/math.lua` | `.tex` | Math envs, Greek letters, operators, matrices |
| `luasnips/tex/templates.lua` | `.tex` | Full document templates |

---

## Node Types — What You'll See in the Files

### `t( )` — Text node
Static text that is inserted as-is.

```lua
t("\\frac{")
```

### `i( )` — Insert node
A tab stop where you type something.
The number is the jump order; `i(0)` is the final cursor position.

```lua
i(1, "numerator")   -- tab stop 1, placeholder text "numerator"
i(2)                -- tab stop 2, no placeholder
```

### `c( )` — Choice node
Presents multiple alternatives. You cycle through them with `<C-E>`.

```lua
c(1, {
  { t("\\frac{"),   i(1), t("}{"), i(2), t("}") },   -- choice 1
  { t("\\dfrac{"),  i(1), t("}{"), i(2), t("}") },   -- choice 2
})
```

### `d( )` — Dynamic node
Generates nodes at expansion time by calling a function.
Used everywhere in your files for visual selection support:

```lua
d(1, get_visual)
```

### `f( )` — Function node
Computes its text by calling a function.
Used in your files to capture regex groups:

```lua
f(function(_, snip) return snip.captures[1] end)
```

### `sn( )` — Snippet node
A nested snippet — a group of nodes treated as one unit.

### `rep( )` — Repeat node
Mirrors the content of another node.

```lua
rep(1)   -- always shows whatever was typed in i(1)
```

---

## Visual Selection  (`get_visual`)

Many of your snippets support **visual selection mode**: select text in visual
mode, then type the trigger to wrap the selection.

```lua
local get_visual = function(args, parent, default_text)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1, default_text))
  end
end
```

**How to use it:**
1. Select text with `v` or `V`
2. Type the snippet trigger (e.g. `ovr` for overline)
3. Expand — the selected text becomes the node content

The helper `v(pos, default)` in your files is a shorthand for `d(pos, get_visual)`.

---

## Math Zone Condition

Your math autosnippets only fire **inside a math environment**.
This is detected by vimtex:

```lua
local in_mathzone = function()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
```

A snippet with `{condition = in_mathzone}` won't expand in normal text.
**vimtex must be loaded** for this to work — see `lua/plugins/vimtex.lua.bak`
(currently disabled; enable it by renaming to `vimtex.lua`).

---

## Writing a New Snippet

Open the relevant file (e.g. `lua/plugins/luasnips/tex/math.lua`) and add a
new entry to the returned table.

### Simple example — a text expansion

```lua
s({ trig = "RR", name = "Real numbers" },
  { t("\\mathbb{R}") }
),
```

### With a tab stop

```lua
s({ trig = "abs", name = "Absolute value" },
  {
    t("\\left\\lvert "), i(1), t(" \\right\\rvert")
  }
),
```

### Autosnippet (fires immediately on typing)

```lua
s({ trig = "->", name = "Arrow", snippetType = "autosnippet" },
  { t("\\to") },
  { condition = in_mathzone }
),
```

### With visual selection

```lua
s({ trig = "ul", name = "Underline" },
  { t("\\underline{"), d(1, get_visual), t("}") },
  { condition = in_mathzone }
),
```

### With regex trigger (capture group)

The `f(function(_, snip) return snip.captures[1] end)` pattern re-inserts
whatever character preceded the trigger, so the autosnippet doesn't consume it.
Your Greek letter snippets use this:

```lua
s({ trig = "[.]a", name = "Alpha", snippetType = "autosnippet", regTrig = true },
  {
    f(function(_, snip) return snip.captures[1] end),  -- re-insert the char before "."
    t("\\alpha")
  },
  { condition = in_mathzone }
),
```

### With choices (`<C-E>` to cycle)

```lua
s({ trig = "lim", name = "Limit" },
  {
    c(1, {
      { t("\\lim_{"), i(1), t(" \\to "), i(2), t("}") },
      { i(1, "\\lim") },
    })
  },
  { condition = in_mathzone }
),
```

---

## After Adding a Snippet

Snippets are loaded at startup. To reload without restarting:

```
:source %          (if you're editing the snippet file)
```

Or restart Neovim. There's no hot-reload — this is a LuaSnip limitation.

---

## Viewing All Loaded Snippets

```
:lua require("luasnip").get_snippets()
```

Or use the LuaSnip log to see what loaded:

```
:LuaSnipListAvailable
```

---

## Tips

**Snippet didn't fire?** Check three things:
1. Are you in the right filetype? (`:set ft?` to check)
2. For math snippets — is vimtex running? (`:VimtexStatus`)
3. Did you enable autosnippets? (`opts = { enable_autosnippets = true }` — already set)

**Choice node disappeared?** Once you jump past a choice node with `<C-L>`,
you can't go back to cycle choices. Jump back with `<C-J>` first.

**Trigger conflicts with evesdropper?** If a trigger expands to the wrong
snippet, press `<C-L>` immediately after expanding — if there are multiple
matches, LuaSnip queues them and `<C-L>` cycles to the next one.

**Adding snippets for a new filetype** — create a new file:
`lua/plugins/luasnips/yourfiletype.lua`
The from_lua loader picks it up automatically by filename.
