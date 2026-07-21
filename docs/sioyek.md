# Sioyek — Cheatsheet

PDF viewer used for LaTeX SyncTeX (see `docs/latex.md`), but these are
Sioyek's own keybindings, used directly inside the PDF window (not Neovim).
All from the shipped defaults in `/etc/sioyek/keys.config` — edit
`~/.config/sioyek/keys_user.config` to override any of them.

> Vim-like modal design: most commands are a short letter sequence, several
> mirror Vim directly (`gg`, `G`, `n`/`N`, `` ` ``, marks).

---

## Navigation & Zoom

| Key | Action |
| --- | ------ |
| `gg` | Goto beginning of document (prefix with a number to jump to that page, e.g. `150gg`) |
| `G` / `<end>` | Goto end of document |
| `<home>` | Prompt for a page number to jump to |
| `^` / `$` | Goto left / right edge of page (ignoring white margins) |
| `zz` | Goto top-right of page (useful for two-column docs) |
| `<space>` / `<pagedown>` | Scroll down one screen |
| `<S-space>` / `<pageup>` | Scroll up one screen |
| `<C-pagedown>` / `<C-pageup>` | Next / previous page |
| `gc` / `gC` | Next / previous chapter |
| `<backspace>` | Back in view history |
| `<S-backspace>` | Forward in view history |
| `t` | Open table of contents |
| `+` / `-` | Zoom in / out |
| `=` | Fit to page width |
| `<f9>` | Fit to page width |
| `<f10>` | Fit to page width, ignoring margins |
| `r` / `R` | Rotate clockwise / counterclockwise |
| `o` | Open a file (dialog) |
| `O` | Open a previously-opened document (searchable list) |
| `<C-t>` | New Sioyek window |
| `<C-w>` | Close current window |

## Search

| Key | Action |
| --- | ------ |
| `/` or `<C-f>` | Search document (`/<110,135>text` searches only pages 110–135) |
| `c/` | Search current chapter |
| `n` / `N` | Next / previous search result (prefix with a number to skip ahead) |

## Bookmarks & Highlights

| Key | Action |
| --- | ------ |
| `b` | Add bookmark at current location |
| `db` | Delete bookmark |
| `gb` | Goto bookmarks (current document) |
| `gB` | Goto bookmarks (all documents) |
| `h` | Highlight selected text (prompts for a-z tag) |
| `dh` | Delete highlight (left-click it first) |
| `gh` / `gH` | Goto highlights (current doc / all docs) |
| `gnh` / `gNh` | Next / previous highlight |

## Marks & Portals

| Key | Action |
| --- | ------ |
| `m` then `<letter>` | Set mark at current location |
| `` ` `` then `<letter>` | Goto mark |
| `p` | Create/goto a portal (link between two locations, even across files) |
| `dp` | Delete nearest portal |
| `gp` / `<tab>` | Goto portal |
| `P` / `<S-tab>` | Edit portal destination |
| `<f12>` | Toggle portal helper window |

## SyncTeX (LaTeX integration — see `docs/latex.md`)

| Key | Action |
| --- | ------ |
| `<f4>` | Toggle synctex mode |
| Right-click (while synctex mode on) | Inverse search — jumps to the source line in Neovim |

Forward search (Neovim → PDF, `\lv` in vimtex) works regardless of synctex
mode; `<f4>` + right-click is only needed for the reverse direction.

## Misc

| Key | Action |
| --- | ------ |
| `<C-c>` | Copy selected text |
| `s` | Search selection using a configured search engine |
| `<f1>` | Toggle link highlighting |
| `<f8>` | Toggle dark mode |
| `<f11>` | Toggle fullscreen |
| `<f6>` | Toggle mouse-drag-to-pan mode |
| `f` | Open a link using the keyboard |
| `v` | Select text using the keyboard |
| `F` | Smart jump using the keyboard |
| `:` | Open command line |
| `q` | Quit |

---

## Tips

**Config files** — `/etc/sioyek/keys.config` and `/etc/sioyek/prefs.config`
are the shipped defaults (read-only, don't edit). User overrides go in
`~/.config/sioyek/keys_user.config` and `~/.config/sioyek/prefs_user.config`
(create if missing).

**Vimtex integration** — `\lv` in a `.tex` buffer opens/updates the PDF in
Sioyek at the compiled location. Inverse search is auto-configured by
vimtex; no changes needed to Sioyek's prefs for it to work with Neovim.
