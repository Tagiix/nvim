# LaTeX in Neovim — Guide

Plugins: `lervag/vimtex` · `texlab` (LSP via Mason)
Config: `lua/plugins/vimtex.lua` · `lua/plugins/mason.lua`
Snippets: `lua/plugins/luasnips/tex/`

> All math snippets require **vimtex to be loaded** — they use `in_mathzone()`
> to avoid firing outside math environments. If a math snippet doesn't fire,
> run `:VimtexStatus` to verify vimtex is active.

---

## Setup

| Tool | Role |
| ---- | ---- |
| **vimtex** | Compilation (latexmk/lualatex), PDF viewing, motions, text objects, `in_mathzone` |
| **texlab** | LSP: completions, go-to-definition, hover, diagnostics |
| **LuaSnip** | All the snippets below |

### PDF viewer — Sioyek (install if missing)

```bash
yay -S sioyek-git   # AUR, not in the official repos
```

Sioyek supports **SyncTeX** — forward search (Neovim → PDF) and inverse search
(PDF → jump to line). Vimtex auto-configures inverse search for Sioyek, no
manual setup needed. Alternative: replace `"sioyek"` with `"evince"` or
`"okular"` in `lua/plugins/vimtex.lua`.

(Previously used Zathura — dropped after a mupdf 1.28.0 regression made it
hang at 100% CPU on some PDFs; see `~/hypr-dotfiles`'s CHANGELOG for details.)

---

## Vimtex Keymaps

`<localleader>` is `\` (backslash) by default.

### Compilation

| Key | Action |
| --- | ------ |
| `\ll` | Start/stop continuous compilation |
| `\lL` | Compile once |
| `\lx` | Cancel compilation |
| `\le` | Open error list |
| `\lo` | Show compiler output |
| `\lq` | Show quickfix / log |

### Viewing

| Key | Action |
| --- | ------ |
| `\lv` | Open PDF in Sioyek (forward search to cursor position) |

### Navigation

| Key | Action |
| --- | ------ |
| `\lt` | Toggle table of contents |
| `\li` | File info / included files |
| `\lg` | Status |

### Motions  (in `.tex` files)

| Key | Action |
| --- | ------ |
| `%` | Jump between `\begin` / `\end` |
| `]]` / `[[` | Next / previous `\end{}` |
| `]m` / `[m` | Next / previous environment start |
| `]n` / `[n` | Next / previous math zone |

### Text Objects  (use with `d`, `c`, `v`, `y`)

| Object | Description |
| ------ | ----------- |
| `ic` / `ac` | Inner / around LaTeX **command** (`\textbf{here}`) |
| `ie` / `ae` | Inner / around **environment** |
| `id` / `ad` | Inner / around **$ math $** |
| `ip` / `ap` | Inner / around **paragraph** |

---

## LSP Keymaps  (texlab)

| Key | Action |
| --- | ------ |
| `K` | Hover — show package/command docs |
| `gd` | Go to definition (labels, commands) |
| `gr` | Find all references to a label |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format / indent document |
| `<leader>cd` | Show diagnostics for current line |
| `[d` / `]d` | Jump to previous/next diagnostic |

---

## LuaSnip Keys (recap)

| Key | Action |
| --- | ------ |
| `<C-K>` (insert) | Expand snippet |
| `<C-L>` (insert/select) | Jump forward |
| `<C-J>` (insert/select) | Jump backward |
| `<C-E>` (insert/select) | Cycle choices |

Many snippets support **visual selection**: select text, then type the trigger.
The selected text becomes the first tab stop.

---

## Document Structure Snippets  (`.tex` — any zone)

### Preamble

| Trigger | Output |
| ------- | ------ |
| `doc` | `\documentclass[opts]{class}` |
| `pk` | `\usepackage[opts]{pkg}` |
| `tl` | `\title{}` |
| `aut` | `\author{}` |
| `dat` | `\date{}` |
| `td` | `\today` |
| `bd` | `\begin{document}…\end{document}` |
| `mkt` | `\maketitle` |
| `toc` | `\tableofcontents` |

### Sections  (choice node: with/without `*`, with TOC entry)

| Trigger | Output |
| ------- | ------ |
| `chr` | `\chapter{}` |
| `scn` | `\section{}` |
| `sbn` | `\subsection{}` |
| `ssn` | `\subsubsection{}` |
| `pr` | `\paragraph{}` |
| `sbp` | `\subparagraph{}` |
| `prt` | `\part{}` |

### Labels  (typed prefix, then key)

| Trigger | Label prefix |
| ------- | ------------ |
| `lge` | `\label{key}` (generic) |
| `lsn` | `\label{sec:…}` |
| `lsb` | `\label{sub:…}` |
| `lbe` | `\label{eq:…}` |
| `lbt` | `\label{thm:…}` |
| `lps` | `\label{prop:…}` |
| `lle` | `\label{lem:…}` |
| `lco` | `\label{cor:…}` |
| `lde` | `\label{def:…}` |
| `lfg` | `\label{fig:…}` |
| `lta` | `\label{tbl:…}` |

### References  (choice node: `\ref`, `\cref`, `\Cref`)

| Trigger | Reference |
| ------- | --------- |
| `rge` | generic |
| `rsn` | `sec:` |
| `rfe` | `eq:` (also `\eqref`) |
| `rft` | `thm:` |
| `rps` | `prop:` |
| `rle` | `lem:` |
| `rco` | `cor:` |
| `rde` | `def:` |
| `rfg` | `fig:` |
| `rta` | `tbl:` |

---

## Math Environment Snippets  (any zone)

| Trigger | Output |
| ------- | ------ |
| `mm` | `$…$` (inline, autosnippet) |
| `nn` | `equation*` / `equation` (choice) |
| `aa` | `align*` / `align` (choice) |
| `sp` | `split` |
| `gg` | `gather*` / `gather` (choice) |
| `ml` | `multline` / `multline*` (choice) |
| `fal` | `flalign*` / `flalign` (choice) |
| `en` | Generic `\begin{env}…\end{env}` |
| `fd` | Full function definition in `align*` |

---

## Math Snippets  (all autosnippet, math zone only)

### Greek Letters  (dot prefix, e.g. `.a` while in math)

| Trigger | Output | Trigger | Output |
| ------- | ------ | ------- | ------ |
| `.a` | `\alpha` | `.b` | `\beta` |
| `.c` | `\chi` | `.d` | `\delta` |
| `.D` | `\Delta` | `.e` | `\varepsilon` |
| `.g` | `\gamma` | `.G` | `\Gamma` |
| `.h` | `\eta` | `.i` | `\iota` |
| `.k` | `\kappa` | `.l` | `\lambda` |
| `.L` | `\Lambda` | `.m` | `\mu` |
| `.n` | `\nu` | `.o` | `\omega` |
| `.O` | `\Omega` | `.ph` | `\varphi` |
| `.Ph` | `\Phi` | `.pi` | `\pi` |
| `.Pi` | `\Pi` | `.ps` | `\psi` |
| `.Ps` | `\Psi` | `.r` | `\rho` |
| `.s` | `\sigma` | `.S` | `\Sigma` |
| `.ta` | `\tau` | `.th` | `\theta` |
| `.Th` | `\Theta` | `.u` | `\upsilon` |
| `.U` | `\Upsilon` | `.x` | `\xi` |
| `.X` | `\Xi` | `.z` | `\zeta` |

### Math Fonts  (autosnippet, visual selection)

| Trigger | Output |
| ------- | ------ |
| `mc` | `\mathcal{}` |
| `mr` | `\mathrm{}` |
| `mb` | `\mathbf{}` |
| `ms` | `\mathsf{}` |
| `mt` | `\mathtt{}` |
| `mn` | `\mathnormal{}` |
| `mi` | `\mathit{}` |
| `mf` | `\mathfrak{}` |
| `mk` | `\mathbb{}` (blackboard bold) |

### Fractions & Binomials

| Trigger | Output |
| ------- | ------ |
| `ff` | `\frac{}{}` / `\dfrac` / `\tfrac` (choice) |
| `cf` | `\cfrac` (continued fraction) |
| `bm` | `\binom{}{}` / `\dbinom` / `\tbinom` (choice) |
| `bx` | `\boxed{}` |

### Delimiters  (autosnippet, visual selection)

| Trigger | Output |
| ------- | ------ |
| `dp` | `\left( … \right)` |
| `ds` | `\left[ … \right]` |
| `bb` | `\{ … \}` |
| `db` | `\left\{ … \right\}` |
| `dk` | `\left\langle … \right\rangle` / `\langle … \rangle` |
| `da` | `\left\lvert … \right\rvert` / `\lvert … \rvert` |
| `dn` | `\left\lVert … \right\rVert` (norm) |
| `ce` | `\lceil … \rceil` / `\left\lceil` variant |
| `fl` | `\lfloor … \rfloor` / `\left\lfloor` variant |
| `big` | `\big` / `\Big` / `\bigg` / `\Bigg` (choice) |

### Decorations & Accents  (autosnippet, visual selection)

| Trigger | Output |
| ------- | ------ |
| `vv` | `\vv{}` / `\vec{}` (choice) |
| `ht` | `\hat{}` / `\widehat{}` (choice) |
| `til` | `\tilde{}` / `\widetilde{}` (choice) |
| `dr` | `\dot{}` / `\ddot{}` / `\dddot{}` / `\ddddot{}` (choice) |
| `rng` | `\mathring{}` |
| `ovr` | `\overline{}` |
| `und` | `\underline{}` |
| `ovb` | `\overbrace{}^{top}` |
| `unb` | `\underbrace{}_{bottom}` |
| `abv` | `\overset{above}{…}` |
| `bel` | `\underset{below}{…}` |

### Subscripts & Superscripts

| Trigger | Output |
| ------- | ------ |
| `;` | `_` (short subscript) |
| `:` | `_{…}` (subscript with braces) |
| `st` | `\substack{… \\ …}` |

### Operators & Functions

| Trigger | Output | Trigger | Output |
| ------- | ------ | ------- | ------ |
| `sq` | `\sqrt{}` | `ff` | `\frac{}{}` |
| `lm` | `\lim_{x\to y}` | `lif` | `\liminf` |
| `lsu` | `\limsup` | `lvf` | `\varliminf` |
| `lvu` | `\varlimsup` | `det` | `\det` |
| `dim` | `\dim` | `kr` | `\ker` |
| `hm` | `\hom` | `gc` | `\gcd` |
| `arg` | `\arg` | `deg` | `\deg` |
| `xm` | `\max` / `\max_{}` | `mu` | `\min` / `\min_{}` |
| `nf` | `\inf` / `\inf_{}` | `sr` | `\sup` / `\sup_{}` |
| `imp` | `\Im` | `rpa` | `\Re` |
| `fn` | `f : A \longrightarrow B` | `fd` | full function def in align |
| `lim` | `\limits` | `nli` | `\nolimits` |

### Trig & Hyperbolic

| Trigger | Output | Trigger | Output |
| ------- | ------ | ------- | ------ |
| `sin` | `\sin` | `cos` | `\cos` |
| `tan` | `\tan` | `cot` | `\cot` |
| `sec` | `\sec` | `cc` | `\csc` |
| `asin` | `\arcsin` | `acos` | `\arccos` |
| `atan` | `\arctan` | `acot` | `\arccot` |
| `sinh` | `\sinh` | `cosh` | `\cosh` |
| `tanh` | `\tanh` | `coth` | `\coth` |
| `xp` | `\exp` | `ln` | `\ln` |
| `lg` | `\log` | | |

### Calculus & Physics

| Trigger | Output |
| ------- | ------ |
| `nb` | `\nabla` |
| `pt` | `\partial` |
| `lap` | `\nabla^2` (Laplacian) |
| `div` | `\nabla\cdot\vv{}` (divergence) |
| `cur` | `\nabla\times\vv{}` (curl) |
| `hr` | `\hbar` |
| `hl` | `\hslash` |
| `ba` | `\bra{}` / `\bra*{}` (choice) |
| `kt` | `\ket{}` / `\ket*{}` (choice) |
| `bk` | `\braket{}{}` / `\braket*{}{}` (choice) |

### Relations & Logic

| Trigger | Output | Trigger | Output |
| ------- | ------ | ------- | ------ |
| `eq` | `\equiv` | `ne` | `\ne` |
| `le` | `\le` | `ge` | `\ge` |
| `app` | `\approx` | `cn` | `\cong` / `\ncong` |
| `re` | `\sim` / `\nsim` | `nr` | `\not` (negation) |
| `iff` | `\iff` | `ip` | `\implies` |
| `ib` | `\impliedby` | `fa` | `\forall` |
| `ex` | `\exists` | `nx` | `\nexists` |
| `lt` | `\lnot` | `lan` | `\land` |
| `lor` | `\lor` | `md` | `\Mod{}` |
| `opm` | `… \bmod …` | `mod` | full `≡ (mod n)` expression |

### Symbols & Constants

| Trigger | Output | Trigger | Output |
| ------- | ------ | ------- | ------ |
| `fy` | `\infty` | `pr` | `\prime` |
| `ll` | `\ell` | `pt` | `\partial` |
| `hr` | `\hbar` | `cm` | `\complement` |
| `ang` | `\angle` | `pm` | `\pm` |
| `mp` | `\mp` | `tm` | `\times` |
| `cd` | `\cdot` | `cir` | `\circ` |
| `opl` | `\oplus` | `omt` | `\otimes` |
| `dv` | `\mid` (divides) | `ndv` | `\centernot\mid` |
| `ha` | `\aleph` | `hb` | `\beth` |
| `hd` | `\daleth` | `hg` | `\gimel` |

### Ellipsis & Spacing

| Trigger | Output | Trigger | Output |
| ------- | ------ | ------- | ------ |
| `dd` | `\ldots` | `cr` | `\cdots` |
| `vd` | `\vdots` | `gd` | `\ddots` |
| `thp` | `\,` (thin) | `mdn` | `\:` (medium) |
| `tkp` | `\;` (thick) | `qu` | `\quad` |
| `qq` | `\qquad` | `hs` | `\hspace{}` |
| `tx` | `\text{}` | `itr` | `\intertext{}` |
| `dis` | `\displaystyle` | `ty` | `\textstyle` |

### Matrices  (autosnippet, math zone)

```
b2x3   →   \begin{bmatrix} (2 rows × 3 cols)
B3x3   →   \begin{Bmatrix}
p2x2   →   \begin{pmatrix}
v2x2   →   \begin{vmatrix}
V3x2   →   \begin{Vmatrix}
```

Pattern: `[bBpvV]<rows>x<cols>` — each cell is a tab stop.

```
b2h3   →   homogeneous matrix (A_{11} A_{12} … pattern)
bgn    →   generic matrix with subscript notation
```

### Cases

```
2cs    →   \begin{cases} with 2 rows   (any digit prefix)
3cs    →   \begin{cases} with 3 rows
```

---

## Theorem-Like Environments  (`.tex` — any zone)

| Trigger | Output |
| ------- | ------ |
| `oo` | `theorem` |
| `pf` | `proof` |
| `ps` | `proposition` |
| `cc` | `corollary` |
| `ll` | `lemma` |
| `dd` | `definition` |
| `re` | `remark` |
| `ex` | `exercise` |
| `ee` | `example` |
| `pn` | `principle` |

All support choice: unnamed, named (`[name]`). Support visual selection.

---

## Lists

| Trigger | Output |
| ------- | ------ |
| `tz` | `\begin{itemize}` (bullets) |
| `enn` | `\begin{enumerate}` with `(1)` labels |
| `enI` | enumerate with `(I)` (Roman) |
| `eni` | enumerate with `(i)` (roman) |
| `enA` | enumerate with `(A)` |
| `ena` | enumerate with `(a)` |
| `tm` | `\item` (add new item inside environment) |

---

## Text Formatting  (any zone)

| Trigger | Output |
| ------- | ------ |
| `url` | `\url{}` |
| `vrb` | `\verb=…=` |
| `foo` | `\footnote{}` |
| `mrg` | `\marginpar{}` |
| `ca` | `\cancel{}` |
| `cen` | `\begin{center}` |
| `fbo` | `\fbox{}` |
| `fco` | `\fcolorbox{border}{bg}{}` |
| `mul` | `\begin{multicols}{n}` |
| `pp` | paragraph break (`\bigskip`) |
| `npg` | `\newpage` |

---

## Floats & Tables

| Trigger | Output |
| ------- | ------ |
| `tab` | `table` + `tabular` environment |
| `rr` | `array` environment |
| `cpt` | `\caption{}` |
| `cof` | `\captionof{}{}` |
| `sbf` | `\subfloat[]{}` |
| `he` | `\\[len]` (custom row height) |
| `hn` | `\hline` |

---

## Citations  (`.tex` — any zone)

| Trigger | Output |
| ------- | ------ |
| `ct` | `\cite{}` / `\cite[text]{}` |
| `tc` | `\citet{}` (textual: "Author (Year)") |
| `tpc` | `\citep{}` (parenthetical: "(Author, Year)") |
| `tnc` | `\citealt{}` (no parentheses) |
| `cf` | `\fullcite{}` |
| `auc` | `\citeauthor{}` |
| `yec` | `\citeyear{}` / `\citeyearpar{}` |
| `ctn` | `\nocite{}` / `\nocite{*}` |
| `bib` | `\bibliography{}` |
| `bisty` | `\bibliographystyle{}` |

---

## BibTeX Entry Snippets  (`.bib` files)

| Trigger | Entry type |
| ------- | ---------- |
| `art` | `@article` |
| `bks` | `@book` |
| `inc` | `@incollection` |
| `inp` | `@inproceedings` |
| `ibk` | `@inbook` |
| `phd` | `@phdthesis` |
| `mst` | `@masterthesis` |
| `man` | `@manual` |
| `mis` | `@misc` |
| `tec` | `@techreport` |
| `unp` | `@unpublished` |
| `pcd` | `@proceedings` |
| `abv` | `@string` (abbreviation) |

---

## Recommended Additions

**Inkscape figure workflow** — `svg-inkscape` is a popular LaTeX package
for importing Inkscape figures with proper font rendering. The snippet `incsvg`
is already in your config for this.

**`latexindent`** — auto-formatter for LaTeX code, installable via
`sudo pacman -S texlive-binextra`. Add to Mason formatter chain if desired.

**`texlive-most`** — if compilation fails on missing packages:
```bash
sudo pacman -S texlive-most   # broad meta-package
```

---

## Tips

**Math snippet didn't fire?** Two things to check:
1. Are you inside a math environment? (`in_mathzone` only fires inside `$`, `equation`, `align`, etc.)
2. Is vimtex running? (`:VimtexStatus`)

**Forward search to PDF** — cursor in the `.tex` file → `\lv`. Sioyek opens
to the exact page and line. Requires SyncTeX (enabled by default with latexmk).

**Inverse search (PDF → Neovim)** — in Sioyek press `F4` to toggle synctex
mode, then right-click on the PDF. It opens Neovim at the corresponding
source line. (Sioyek's default binding — right-click alone does nothing until
synctex mode is toggled on; see `/etc/sioyek/keys.config`'s `toggle_synctex`.)

**Compilation errors** — `\le` opens the quickfix list of errors with file/line.
Press `Enter` on an error to jump to it.

**Large documents with `\include`** — vimtex handles multi-file projects.
Open any included `.tex` file and compile — it finds the root automatically
(or set `\g:vimtex_root_markers = {'.latexmain'}` in vimtex.lua).

**Snippet conflicts between custom and evesdropper** — if a trigger expands
to the wrong snippet, press `<C-L>` immediately to cycle to the next one.
Your custom snippets have visual selection support; evesdropper's may not.
