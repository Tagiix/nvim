# Neovim Cheatsheet  ·  `<leader>` = `Space`

> Press `q` or `<Esc>` to close this window · `j/k` or `<C-d>/<C-u>` to scroll

---

## Navigation & Files

| Key | Action |
|-----|--------|
| `<leader>ff` / `<leader><space>` | Find file |
| `<leader>fg` | Find file (git-tracked only) |
| `<leader>/`  | Live grep (search text in project) |
| `<leader>fr` | Recent files |
| `<leader>fb` / `<leader>,` | Browse open buffers |
| `<leader>fn` | New file |
| `<leader>e`  | File explorer (neo-tree) |
| `<leader>sb` | Search in current buffer |
| `<C-h/j/k/l>` | Move between windows |
| `H` / `L`   | Prev / next buffer |
| `gx`         | Open URL under cursor |

---

## Code / LSP

| Key | Action |
|-----|--------|
| `K`           | Hover docs |
| `gd`          | Go to definition |
| `gD`          | Go to declaration |
| `gr`          | References |
| `gI`          | Implementations |
| `gy`          | Type definition |
| `gpd`         | **Preview** definition (float, stay in place) |
| `gpr`         | **Preview** references |
| `gpi`         | **Preview** implementation |
| `gpt`         | **Preview** type definition |
| `gpq`         | Close all preview windows |
| `<leader>ca`  | Code action |
| `<leader>cr`  | Rename symbol |
| `<leader>cf`  | Format file / selection |
| `<leader>cd`  | Line diagnostic popup |
| `<leader>ss`  | Goto symbol (buffer) |
| `<leader>sS`  | Goto symbol (workspace) |
| `[d` / `]d`   | Prev / next diagnostic |
| `<leader>xx`  | All diagnostics (Trouble) |
| `<leader>xX`  | Buffer diagnostics |
| `<leader>cs`  | Document symbols (Trouble) |
| `<leader>cS`  | LSP references (Trouble) |
| `<leader>xq`  | Quickfix list |
| `<leader>xl`  | Location list |
| `]q` / `[q`   | Next / prev quickfix |

---

## Git

| Key | Action |
|-----|--------|
| `<leader>gg` | Open Lazygit (only mapped once `lazygit` is installed) |
| `]h` / `[h`  | Next / prev hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghS` | Stage buffer |
| `<leader>ghR` | Reset buffer |
| `<leader>ghu` | Undo stage hunk |
| `<leader>ghp` | Preview hunk |
| `<leader>gb` / `<leader>ghb` | Blame line |
| `<leader>ghd` | Diff this file against index |
| `<leader>ghD` | Diff this file against last commit |
| `<leader>gs` | Git status (changed files) |
| `<leader>gd` | Git diff (all hunks) |
| `<leader>gD` | Git diff against origin |
| `<leader>gS` | Git stash list |
| `<leader>gl` | Git log |
| `<leader>gf` | History of current file |

> Hunk keys (`]h`, `<leader>gh…`) only exist in buffers inside a git repository.

---

## Buffers & Windows

| Key | Action |
|-----|--------|
| `<leader>bd` | Delete buffer |
| `<leader>bb` | Switch to other buffer |
| `<leader>bo` | Delete all other buffers |
| `<leader>\|` | Split vertical |
| `<leader>-`  | Split horizontal |
| `<leader>wd` | Delete window |
| `<C-/>`      | Toggle terminal |
| `<leader>ft` | Terminal (project root) |
| `<leader>fT` | Terminal (cwd) |

---

## Flash.nvim — Jump

| Key | Mode | Action |
|-----|------|--------|
| `s`  | n/v/o | Flash jump (type chars to label) |
| `S`  | n/v/o | Flash Treesitter (jump to node) |
| `r`  | o     | Remote Flash (select remote object) |
| `R`  | o/v   | Treesitter Search |
| `<C-s>` | c  | Toggle Flash in `/` search |

---

## Search  (`<leader>s…`)

| Key | Action |
|-----|--------|
| `<leader>sg` | Grep (project root) |
| `<leader>sG` | Grep (cwd) |
| `<leader>sb` | Search buffer lines |
| `<leader>sd` | Search diagnostics |
| `<leader>sh` | Search help tags |
| `<leader>sk` | Search keymaps |
| `<leader>sm` | Search marks |
| `<leader>snh` | Noice message history |
| `<leader>sr` | Search & replace (grug-far) |
| `<leader>sw` | Grep word under cursor / selection (project root) |
| `<leader>sW` | Grep word under cursor / selection (cwd) |

---

## Toggle Options  (`<leader>u…`)

| Key | Action |
|-----|--------|
| `<leader>uf` | Toggle auto-format (global) |
| `<leader>uF` | Toggle auto-format (buffer) |
| `<leader>us` | Toggle spelling |
| `<leader>uw` | Toggle word wrap |
| `<leader>ul` | Toggle line numbers |
| `<leader>uL` | Toggle relative numbers |
| `<leader>ud` | Toggle diagnostics |
| `<leader>uc` | Toggle conceal |
| `<leader>ub` | Toggle dark/light background |
| `<leader>uh` | Toggle inlay hints |
| `<leader>uT` | Toggle treesitter highlight |
| `<leader>un` | Dismiss all notifications |

---

## Completions  (nvim-cmp)

| Key | Action |
|-----|--------|
| `<C-n>` / `<C-p>` | Next / prev completion item |
| `<Tab>` | Accept Supermaven suggestion / jump to next snippet node |
| `<CR>` | Confirm selection |
| `<C-Space>` | Trigger completion |
| `<C-e>` | Abort completion |
| `<C-b>` / `<C-f>` | Scroll docs up / down |

---

## Folds

| Key | Action |
|-----|--------|
| `za` | Toggle fold |
| `zc` / `zo` | Close / open fold |
| `zC` / `zO` | Close / open all folds at cursor |
| `zM` | Close all folds |
| `zR` | Open all folds |
| `zj` / `zk` | Next / prev fold |

---

## Marks & Jumps

| Key | Action |
|-----|--------|
| `m{a-z}` | Set local mark |
| `'{a-z}` | Jump to mark (line start) |
| `` `{a-z} `` | Jump to mark (exact col) |
| `''` / ` `` ` | Jump to last jump position |
| `<C-o>` / `<C-i>` | Older / newer jump position |
| `g;` / `g,` | Prev / next change position |
| `<leader>sm` | Search marks |

---

## LuaSnip  (custom keybindings)

| Key | Mode | Action |
|-----|------|--------|
| `<C-K>` | i | Expand snippet |
| `<C-L>` | i, s | Jump forward (next node) |
| `<C-J>` | i, s | Jump backward (prev node) |
| `<C-E>` | i, s | Cycle through choices |

---

## Claude  (`<leader>a…`)

| Key | Action |
|-----|--------|
| `<leader>ac` | Toggle Claude pane |
| `<leader>af` | Focus Claude pane |
| `<leader>ab` | Add current buffer to Claude's context |
| `<leader>as` | Send selection to Claude (visual) |
| `<leader>aa` / `<leader>ad` | Accept / deny proposed diff |
| `<leader>an` | Tutor: where am I / next step |
| `<leader>ah` | Tutor: hint, no solution |
| `<leader>ak` | Tutor: check my current file |
| `<leader>aq` | Tutor: ask a question (n/v) |

> Tutor keys rely on the project's `CLAUDE.md` to define what a hint or a check is.

---

## Neovim Tips  (`<leader>nt…`)

| Key | Action |
|-----|--------|
| `<leader>nto` | Browse all tips |
| `<leader>ntr` | Random tip |
| `<leader>nta` | Add tip |
| `<leader>nte` | Edit tips file |
| `<leader>nth` | Plugin help |

---

## CMake Tools  (`<leader>m…`)

| Key | Action |
|-----|--------|
| `<leader>mg` | CMake Generate (configure) |
| `<leader>mb` | CMake Build |
| `<leader>mr` | CMake Run |
| `<leader>md` | CMake Debug |
| `<leader>mc` | CMake Clean |
| `<leader>mt` | CMake Select Target |
| `<leader>mx` | CMake Build Type (Debug / Release / …) |
| `<leader>mi` | CMake Info |

> Workflow: `<leader>mx` → choose Debug → `<leader>mg` → `<leader>mb` → `<leader>mr`

---

## C++ / DAP Debugging

| Key | Action |
|-----|--------|
| `<leader>md` | Launch debugger (cmake-tools, picks target auto) |
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue / start |
| `<leader>dO` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>du` | Toggle DAP UI |
| `<leader>dB` | Conditional breakpoint |
| `<leader>ce` | Compiler Explorer (Godbolt) |
| `<leader>cE` | Compiler Explorer (live mode) |
| `<leader>Dc` | Open C++ workflow guide |
| `<leader>K`  | cppman: cppreference docs for word under cursor |

---

## LeetCode

| Key / Command | Action |
|---------------|--------|
| `<leader>li` | Interview 150 picker |
| `<leader>lc` | Claude review of current solution (auto-saved) |
| `<leader>lh` | Claude hint — nudge without spoiling |
| `<leader>ll` | Switch language |
| `:Leet` | Open LeetCode |
| `:Leet list` | All problems picker |
| `:LeetInterview` | Top Interview 150 picker |
| `:LeetReview` | Claude critique (auto-saved next to solution) |
| `:LeetHint` | Claude hint without spoiling |
| `:Leet daily` | Today's daily challenge |
| `:Leet desc` | Toggle problem description |
| `:Leet run` | Run test cases |
| `:Leet submit` | Submit solution |
| `:Leet console` | Toggle console |
| `:Leet lang` | Change language |
| `:Leet info` | Problem info |

---

## Plugin Management

| Command | Action |
|---------|--------|
| `:Lazy` | Open plugin manager UI |
| `:Lazy sync` | Install + update + clean |
| `:Lazy update` | Update all plugins |
| `:Lazy restore` | Roll back to `lazy-lock.json` |
| `:Mason` | Open LSP installer |
| `:MasonUpdate` | Update all LSP servers |

---

## LaTeX Snippets — Math Mode  (autosnippets)

> These fire automatically while typing **inside a math zone** (vimtex detects it).

### Environments

| Trigger | Output |
|---------|--------|
| `mm` | `$…$` inline math |
| `nn` | `equation` / `equation*` |
| `aa` | `align` / `align*` |
| `gg` | `gather` / `gather*` |
| `sp` | `split` |
| `ml` | `multline` / `multline*` |
| `Ncs` | `cases` (N rows) |

### Math Fonts

| Trigger | Output |
|---------|--------|
| `mk` | `\mathbb{…}` |
| `mc` | `\mathcal{…}` |
| `mb` | `\mathbf{…}` |
| `mr` | `\mathrm{…}` |
| `mf` | `\mathfrak{…}` |
| `ms` | `\mathsf{…}` |

### Structures

| Trigger | Output |
|---------|--------|
| `ff` | `\frac` / `\dfrac` / `\tfrac` |
| `sq` | `\sqrt[n]{…}` |
| `bm` | `\binom` / `\dbinom` |
| `cf` | `\cfrac{…}{…}` |
| `bx` | `\boxed{…}` |
| `dp` | `\left( … \right)` |
| `ds` | `\left[ … \right]` |
| `db` | `\left\{ … \right\}` |
| `da` | `\left\lvert … \right\rvert` |
| `dn` | `\left\lVert … \right\rVert` |
| `dk` | `\left\langle … \right\rangle` |

### Greek Letters  (dot `.` prefix in math)

| Trigger | | Trigger | |
|---------|--|---------|--|
| `.a` | α | `.b` | β |
| `.g` / `.G` | γ / Γ | `.d` / `.D` | δ / Δ |
| `.e` | ε | `.th` / `.Th` | θ / Θ |
| `.l` / `.L` | λ / Λ | `.m` | μ |
| `.ph` / `.Ph` | φ / Φ | `.pi` / `.Pi` | π / Π |
| `.s` / `.S` | σ / Σ | `.O` / `.o` | Ω / ω |
| `.r` | ρ | `.z` | ζ |

### Subscripts / Superscripts / Matrices

| Trigger | Output |
|---------|--------|
| `;` | `_` short subscript |
| `:` | `_{…}` subscript |
| `´` | `^` short superscript |
| `¨` | `^{…}` superscript |
| `[bBpvV]NxM` | N×M matrix (e.g. `b3x2`) |
| `[bBpvV]gn` | Generic symbolic matrix |
| `vv` | `\vv{…}` / `\vec{…}` |

---

## LaTeX Snippets — Document Structure  (.tex files)

| Trigger | Output |
|---------|--------|
| `doc` | `\documentclass{…}` |
| `pk` | `\usepackage{…}` |
| `bd` | `\begin{document}…\end{document}` |
| `scn` | `\section` / `\section*` |
| `sbn` | `\subsection` / `\subsection*` |
| `ssn` | `\subsubsection` |
| `chr` | `\chapter` |
| `toc` | `\tableofcontents` |
| `mkt` | `\maketitle` |
| `tl` / `aut` / `dat` | `\title` / `\author` / `\date` |

### Labels & Cross-references

| Trigger | Type |
|---------|------|
| `lsn` / `rsn` | Section label / ref |
| `lbe` / `rfe` | Equation label / ref |
| `lbt` / `rft` | Theorem label / ref |
| `lfg` / `rfg` | Figure label / ref |
| `lta` / `rta` | Table label / ref |
| `pge` | `\pageref{…}` |

---

## LaTeX Snippets — Citations  (.tex files)

| Trigger | Output |
|---------|--------|
| `ct` | `\cite{…}` / `\cite[text]{…}` |
| `tc` | `\citet{…}` (textual citation) |
| `tpc` | `\citep{…}` (parenthetical) |
| `cf` | `\fullcite{…}` |
| `ctn` | `\nocite{…}` |
| `auc` | `\citeauthor{…}` |
| `yec` | `\citeyear{…}` |
| `bib` | `\bibliography{…}` |

---

## LaTeX Snippets — Formatting  (.tex files)

| Trigger | Output |
|---------|--------|
| `oo` | `theorem` environment |
| `pf` | `proof` environment |
| `ps` | `proposition` environment |
| `ll` | `lemma` environment |
| `dd` | `definition` environment |
| `ee` | `example` environment |
| `tz` | `itemize` list |
| `enn` | `enumerate` (arabic) |
| `enI` / `eni` | enumerate (Roman / roman) |
| `enA` / `ena` | enumerate (Alpha / alpha) |
| `tm` | `\item` |
| `bf` | `\textbf{…}` / `\bfseries` |
| `it` | `\textit{…}` / `\itshape` |
| `em` | `\emph{…}` |
| `foo` | `\footnote{…}` |

---

## BibTeX Entry Snippets  (.bib files)

| Trigger | Entry type |
|---------|-----------|
| `art` | `@article` |
| `bks` | `@book` |
| `bkl` | `@booklet` |
| `inp` | `@inproceedings` |
| `inc` | `@incollection` |
| `ibk` | `@inbook` |
| `phd` | `@phdthesis` |
| `mst` | `@masterthesis` |
| `tec` | `@techreport` |
| `mis` | `@misc` |
| `unp` | `@unpublished` |
| `abv` | `@string` abbreviation |

---

## LaTeX Templates  (.tex files)

| Trigger | Template |
|---------|---------|
| `phy-art` | Physics article (2-col, natbib, siunitx, pgfplots…) |
| `math-notes` | Math lecture notes (inputs pream.tex) |
| `writing` | 2-sided writing article (EB Garamond) |
| `min-math` | Minimal math article |
| `bib` | Bibliography block (`\bibliography{bibliography}`) |
