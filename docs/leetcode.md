# LeetCode.nvim — Full Guide

Plugin: `kawre/leetcode.nvim` · Config: `lua/plugins/leetcode.lua`

---

## First-time Setup — Authentication

The plugin needs your LeetCode session cookie. **You only do this once.**

1. Log in to [leetcode.com](https://leetcode.com) in your browser
2. Open **DevTools** → **Application** (Chrome) or **Storage** (Firefox)
3. Go to **Cookies** → `https://leetcode.com`
4. Find the cookie named `LEETCODE_SESSION` and copy its value
5. In Neovim, run:

```
:Leet cookie
```

Paste the cookie value when prompted. You're done — it persists across sessions.

> If your session expires (usually after ~2 weeks of inactivity), repeat step 4–5.

---

## Opening LeetCode

```
:Leet
```

This opens the **main menu** with tabs for: problems, daily challenge, your stats,
and currently open problem tabs.

---

## Core Workflow

### 1 — Browse problems

**All problems:**
```
:Leet list
```

**Top Interview 150 only** (curated study plan):
```
:LeetInterview
```
or press `<leader>li` from normal mode.

Both open the Telescope picker. You can:

- **Type** to filter by problem title or number
- Use the filter keys inside the picker:

| Key | Filter |
|-----|--------|
| `<C-d>` | Cycle difficulty (Easy / Medium / Hard) |
| `<C-s>` | Cycle status (Todo / Attempted / Done) |
| `<C-t>` | Filter by topic tag |

Press `<Enter>` on a problem to open it.

---

### 2 — Problem layout

When you open a problem, three panes appear:

```
┌──────────────────┬─────────────────────────────┐
│  Description     │   Solution editor            │
│  (left, 40%)     │   (your code goes here)      │
│                  ├─────────────────────────────┤
│                  │   Console / test output      │
│                  │   (bottom, opens on demand)  │
└──────────────────┴─────────────────────────────┘
```

Toggle the description pane:

```
:Leet desc
```

Toggle the console pane:

```
:Leet console
```

---

### 3 — Write your solution

Your cursor is in the solution editor. Write code normally — LSP, snippets,
and all your normal Neovim tools work here.

To reset the editor back to the problem's starter code:

```
:Leet reset
```

---

### 4 — Run test cases

```
:Leet run
```

Runs the default test cases provided by LeetCode. Output appears in the console.

**Inside the console pane:**

| Key | Action |
|-----|--------|
| `r` | Reset test case input |
| `U` | Use current test case as custom input |
| `H` | Focus test case input |
| `L` | Focus result output |
| `q` / `<Esc>` | Close console |

---

### 5 — Submit

```
:Leet submit
```

Submits your solution. The result (Accepted / Wrong Answer / TLE / etc.)
appears in the console with full details: runtime percentile, memory percentile,
failing test case if applicable.

---

## All Commands

| Command | Action |
|---------|--------|
| `:Leet` | Open main menu |
| `:Leet list` | All problems picker (Telescope) |
| `:LeetInterview` | Top Interview 150 picker |
| `:Leet daily` | Open today's daily challenge directly |
| `:Leet run` | Run test cases |
| `:Leet submit` | Submit solution |
| `:Leet desc` | Toggle description pane |
| `:Leet console` | Toggle console / test output pane |
| `:Leet info` | Show problem metadata (difficulty, tags, acceptance %) |
| `:Leet lang` | Change language for current problem |
| `:Leet tabs` | List all open problem tabs |
| `:Leet reset` | Reset editor to starter code |
| `:Leet last_submit` | Show the code from your last submission |
| `:Leet restore` | Restore your last submission into the editor |
| `:Leet yank` | Copy current solution to clipboard |
| `:Leet open` | Open current problem on leetcode.com in browser |
| `:Leet cookie` | Update session cookie (re-authenticate) |
| `:Leet cache update` | Refresh problem list cache (do this after new problems appear) |
| `:Leet stats` | Your global stats (solved count by difficulty) |

---

## Changing Language

```
:Leet lang
```

Opens a picker to select any supported language. The editor switches immediately,
with the correct starter code for that language.

**To set a default language** so every new problem opens in it, add to
`lua/plugins/leetcode.lua`:

```lua
opts = {
  lang = "cpp",   -- or "python3", "java", "rust", "go", etc.
},
```

---

## Daily Challenge

```
:Leet daily
```

Opens today's daily challenge directly, skipping the problem list.
Useful as a daily habit — run it when you open Neovim.

---

## Useful Configuration Options

All of these go inside `opts = { … }` in `lua/plugins/leetcode.lua`.

```lua
opts = {
  -- Default language for all new problems
  lang = "cpp",

  -- Auto-open console when entering a problem
  console = {
    open_on_enter = false,   -- set true to always show console on open
  },

  -- Description pane position and width
  description = {
    position = "left",       -- "left" | "right"
    width = "40%",
    show_stats = true,       -- show difficulty / acceptance % in description
  },

  -- Where solutions and cache are stored
  storage = {
    home  = vim.fn.stdpath("data")  .. "/leetcode",  -- your solutions
    cache = vim.fn.stdpath("cache") .. "/leetcode",
  },

  -- Inject code at the top of every solution (e.g. common headers)
  -- Key = language name as leetcode calls it
  injector = {
    ["cpp"] = {
      before = { "#include <bits/stdc++.h>", "using namespace std;" },
    },
    ["python3"] = {
      before = {
        "from typing import List, Optional, Dict, Tuple, Set, DefaultDict, Deque",
        "from collections import defaultdict, Counter, deque",
        "from heapq import heappush, heappop, heapify, nlargest, nsmallest",
        "from bisect import bisect_left, bisect_right, insort",
        "from math import inf, floor, ceil, sqrt, log2, gcd, comb",
        "from itertools import combinations, permutations, product, accumulate",
        "from functools import lru_cache, cache",
      },
    },
  },
},
```

> The `injector` option is especially useful for C++ competitive programming —
> it prepends `#include <bits/stdc++.h>` automatically so you never have to
> type it.

---

## Where Your Solutions Are Saved

Solutions are stored outside the config directory by default:

```
~/.local/share/nvim/leetcode/
└── <problem-number>-<problem-slug>/
    └── solution.<ext>
```

This means they survive config resets and are not tracked by your config git repo.
If you want to back them up, you can `git init` that folder separately or
change the storage path in opts.

---

## Tips

**Jump straight to a problem by number** — in `:Leet list`, type the number
(e.g. `42`) and it filters to "Trapping Rain Water" immediately.

**Restore after accidental reset** — if you reset your code and want it back,
`:Leet restore` brings back whatever you last submitted. If you never submitted,
the reset is permanent — use `u` (undo) instead while still in the editor.

**Test with custom input** — in the console, press `U` to replace the default
test case with whatever you type. Useful for edge cases LeetCode doesn't include.

**Open in browser for editorial** — `:Leet open` opens the problem on
leetcode.com directly so you can read the official editorial or discuss tab.

**Check your progress** — `:Leet stats` shows a summary of how many problems
you've solved at each difficulty level.

**Cache goes stale** — new problems are added to LeetCode regularly. If a
problem you know exists isn't showing up in `:Leet list`, run
`:Leet cache update` to refresh.
