return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    -- Default language for new problems. Switch per-problem with :Leet lang
    lang = "cpp",

    -- Code injected automatically at the top of every solution file.
    injector = {
      ["cpp"] = {
        before = { "#include <bits/stdc++.h>", "using namespace std;" },
      },
      ["python3"] = {
        imports = function()
          return {
            "from typing import List, Optional, Dict, Tuple, Set, DefaultDict, Deque",
            "from collections import defaultdict, Counter, deque",
            "from heapq import heappush, heappop, heapify, nlargest, nsmallest",
            "from bisect import bisect_left, bisect_right, insort",
            "from math import inf, floor, ceil, sqrt, log2, gcd, comb",
            "from itertools import combinations, permutations, product, accumulate",
            "from functools import lru_cache, cache",
          }
        end,
      },
    },

    description = {
      position = "left",
      width = "40%",
      show_stats = true,
    },
  },
  config = function(_, opts)
    require("leetcode").setup(opts)

    -- Top Interview 150 problem slugs (LeetCode study plan)
    local interview_150_slugs = {
      -- Array / String
      "merge-sorted-array", "remove-element", "remove-duplicates-from-sorted-array",
      "remove-duplicates-from-sorted-array-ii", "majority-element", "rotate-array",
      "best-time-to-buy-and-sell-stock", "best-time-to-buy-and-sell-stock-ii",
      "jump-game", "jump-game-ii", "h-index", "insert-delete-getrandom-o1",
      "product-of-array-except-self", "gas-station", "candy", "trapping-rain-water",
      "roman-to-integer", "integer-to-roman", "length-of-last-word",
      "longest-common-prefix", "reverse-words-in-a-string", "zigzag-conversion",
      "find-the-index-of-the-first-occurrence-in-a-string", "text-justification",
      -- Two Pointers
      "valid-palindrome", "is-subsequence", "two-sum-ii-input-array-is-sorted",
      "container-with-most-water", "3sum",
      -- Sliding Window
      "minimum-size-subarray-sum", "longest-substring-without-repeating-characters",
      "substring-with-concatenation-of-all-words", "minimum-window-substring",
      -- Matrix
      "valid-sudoku", "spiral-matrix", "rotate-image", "set-matrix-zeroes", "game-of-life",
      -- Hashmap
      "ransom-note", "isomorphic-strings", "word-pattern", "valid-anagram",
      "group-anagrams", "two-sum", "happy-number", "contains-duplicate-ii",
      "longest-consecutive-sequence",
      -- Intervals
      "summary-ranges", "merge-intervals", "insert-interval",
      "minimum-number-of-arrows-to-burst-balloons",
      -- Stack
      "valid-parentheses", "simplify-path", "min-stack",
      "evaluate-reverse-polish-notation", "basic-calculator",
      -- Linked List
      "linked-list-cycle", "add-two-numbers", "merge-two-sorted-lists",
      "copy-list-with-random-pointer", "reverse-linked-list-ii", "reverse-nodes-in-k-group",
      "remove-nth-node-from-end-of-list", "remove-duplicates-from-sorted-list-ii",
      "rotate-list", "partition-list", "lru-cache",
      -- Binary Tree General
      "maximum-depth-of-binary-tree", "same-tree", "invert-binary-tree",
      "symmetric-tree", "construct-binary-tree-from-preorder-and-inorder-traversal",
      "construct-binary-tree-from-inorder-and-postorder-traversal",
      "populating-next-right-pointers-in-each-node-ii", "flatten-binary-tree-to-linked-list",
      "path-sum", "sum-root-to-leaf-numbers", "binary-tree-maximum-path-sum",
      "binary-tree-right-side-view", "average-of-levels-in-binary-tree",
      "binary-tree-level-order-traversal", "binary-tree-zigzag-level-order-traversal",
      "count-complete-tree-nodes",
      -- Binary Tree BST
      "minimum-absolute-difference-in-bst", "kth-smallest-element-in-a-bst",
      "validate-binary-search-tree",
      -- Graph General
      "number-of-islands", "surrounded-regions", "clone-graph",
      "evaluate-division", "course-schedule", "course-schedule-ii",
      -- Graph BFS
      "snakes-and-ladders", "minimum-genetic-mutation", "word-ladder",
      -- Trie
      "implement-trie-prefix-tree", "design-add-and-search-words-data-structure",
      "word-search-ii",
      -- Backtracking
      "letter-combinations-of-a-phone-number", "combinations", "permutations",
      "combination-sum", "n-queens-ii", "generate-parentheses", "word-search",
      -- Divide & Conquer
      "convert-sorted-array-to-binary-search-tree", "sort-list",
      "construct-quad-tree", "merge-k-sorted-lists",
      -- Kadane's Algorithm
      "maximum-subarray", "maximum-sum-circular-subarray",
      -- Binary Search
      "search-insert-position", "search-a-2d-matrix", "find-peak-element",
      "search-in-rotated-sorted-array",
      "find-first-and-last-position-of-element-in-sorted-array",
      "find-minimum-in-rotated-sorted-array", "median-of-two-sorted-arrays",
      -- Heap
      "kth-largest-element-in-an-array", "ipo", "find-k-pairs-with-smallest-sums",
      "find-median-from-data-stream",
      -- Bit Manipulation
      "add-binary", "reverse-bits", "number-of-1-bits", "single-number",
      "single-number-ii", "bitwise-and-of-numbers-range",
      -- Math
      "palindrome-number", "plus-one", "factorial-trailing-zeroes",
      "sqrtx", "powx-n", "max-points-on-a-line",
      -- 1D DP
      "climbing-stairs", "house-robber", "word-break", "coin-change",
      "longest-increasing-subsequence",
      -- Multidimensional DP
      "triangle", "minimum-path-sum", "unique-paths-ii",
      "longest-palindromic-substring", "interleaving-string", "edit-distance",
      "best-time-to-buy-and-sell-stock-iii", "best-time-to-buy-and-sell-stock-iv",
      "maximal-square",
    }

    local slugs_set = {}
    for _, slug in ipairs(interview_150_slugs) do
      slugs_set[slug] = true
    end

    vim.api.nvim_create_user_command("LeetInterview", function()
      require("leetcode.utils").auth_guard()
      local all = require("leetcode.cache.problemlist").get()
      local filtered = vim.tbl_filter(function(q)
        return slugs_set[q.title_slug] == true
      end, all)
      require("leetcode.picker").question(filtered, {})
    end, { desc = "LeetCode: Top Interview 150" })

    vim.keymap.set("n", "<leader>li", "<cmd>LeetInterview<cr>", { desc = "LeetCode: Interview 150" })

    vim.api.nvim_create_user_command("LeetReview", function()
      -- Find current question by matching the active tabpage
      local tabs = require("leetcode.utils").question_tabs()
      local tabp = vim.api.nvim_get_current_tabpage()
      local curr = nil
      for _, t in ipairs(tabs) do
        if t.tabpage == tabp then curr = t.question; break end
      end
      if not curr then
        vim.notify("Not in a LeetCode problem", vim.log.levels.ERROR)
        return
      end
      if not (curr.bufnr and vim.api.nvim_buf_is_valid(curr.bufnr)) then
        vim.notify("Solution buffer not found", vim.log.levels.ERROR)
        return
      end
      if not (curr.q and curr.q.content) then
        vim.notify("Problem data not loaded yet", vim.log.levels.ERROR)
        return
      end

      local code = table.concat(vim.api.nvim_buf_get_lines(curr.bufnr, 0, -1, false), "\n")
      local q = curr.q

      -- Strip HTML from description
      local desc = q.content
        :gsub("<[^>]+>", "")
        :gsub("&nbsp;", " "):gsub("&lt;", "<"):gsub("&gt;", ">")
        :gsub("&amp;", "&"):gsub("&#39;", "'"):gsub("&quot;", '"')
        :gsub("\n\n+", "\n\n"):gsub("^\n+", ""):gsub("\n+$", "")

      local prompt = table.concat({
        ("LeetCode #%s — %s (%s)"):format(q.frontend_id, q.title, q.difficulty),
        "",
        "Problem:",
        desc,
        "",
        ("My %s solution:"):format(curr.lang),
        "```" .. curr.lang,
        code,
        "```",
        "",
        "Criticize this solution: correctness, edge cases, time/space complexity, and any concrete improvements.",
      }, "\n")

      -- Open a float to stream the response into
      local buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].filetype = "markdown"
      vim.bo[buf].bufhidden = "wipe"
      local width = math.floor(vim.o.columns * 0.75)
      local height = math.floor(vim.o.lines * 0.8)
      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = (" Claude Review — %s "):format(q.title),
        title_pos = "center",
      })
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
      vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Asking Claude, please wait…" })

      local output = {}
      vim.fn.jobstart({ "claude", "-p", prompt }, {
        on_stdout = function(_, data)
          if not data then return end
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(buf) then return end
            for _, line in ipairs(data) do
              table.insert(output, line)
            end
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
            if vim.api.nvim_win_is_valid(win) then
              vim.api.nvim_win_set_cursor(win, { math.max(1, #output), 0 })
            end
          end)
        end,
        on_exit = function(_, code_exit)
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(buf) then return end
            if code_exit ~= 0 then
              vim.notify("Claude exited with code " .. code_exit, vim.log.levels.WARN)
            end
          end)
        end,
      })
    end, { desc = "LeetCode: Claude Code Review" })

    vim.keymap.set("n", "<leader>lc", "<cmd>LeetReview<cr>", { desc = "LeetCode: Claude Review" })

    -- nui.nvim floats don't recalculate percentage-based positions on resize.
    -- update() re-runs update_layout_config which detects the container size
    -- change and recomputes row/col/width/height from the stored "50%" strings.
    vim.api.nvim_create_autocmd("VimResized", {
      callback = vim.schedule_wrap(function()
        if not _Lc_state then return end
        for _, q in ipairs(_Lc_state.questions or {}) do
          if q.console and q.console.visible then
            pcall(function() q.console:update() end)
          end
        end
        vim.cmd("redraw!")
      end),
    })
  end,
}
