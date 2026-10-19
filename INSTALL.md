# System packages for this Neovim config (Arch)

Everything installed outside Neovim lives here, so a new machine misses
nothing. Plugins and language servers are not listed: `lazy.nvim` and Mason
install those on first launch.

Packages marked *checked* were confirmed installed on the Surface on
2026-10-19; the rest come from `README.md` and were not re-checked.

## Core (needed by LazyVim and this config)

```bash
sudo pacman -S neovim git ripgrep fd unzip nodejs npm tree-sitter-cli wl-clipboard
sudo pacman -S ttf-jetbrains-mono-nerd     # or any Nerd Font; set it in the terminal
sudo pacman -S lazygit                     # <leader>gg
```

*checked.* `wl-clipboard` is for the system clipboard under Wayland
(`clipboard = "unnamedplus"`); X11 would need `xclip` instead.

## Python / ESL project

```bash
sudo pacman -S python python-pip           # the project venv is built from this
sudo pacman -S poppler                     # pdftotext, for searching the ESL book
```

*checked.* Then follow the setup in `~/code/python-ESL/README.md`
(venv, `pip install -r requirements.txt`, `python data/fetch.py`).
pyright, ruff and debugpy are installed by Mason, not pacman.

## C++

```bash
sudo pacman -S clang cmake ninja
```

*checked.* `ccache` (rebuild speed-up) is listed in `README.md` but was not
installed on this machine: `sudo pacman -S ccache` if you want it.

## LaTeX

```bash
sudo pacman -S texlive-binextra texlive-latex zathura
```

*checked.* `vimtex` views PDFs in zathura. `README.md` also mentions the AUR
package `sioyek-git`; it was not installed on this machine.

## Optional, AUR

```bash
paru -S cppman-git && cppman -c            # <leader>K cppreference docs; cache takes ~5 min
```

Not installed on this machine, unchecked.

## Claude Code

The `<leader>a…` keys drive the `claude` CLI, which must be on `PATH`
(*checked*: the `claude-code` package).
