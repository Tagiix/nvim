-- Tutor keys on top of LazyVim's claudecode extra (<leader>ac, <leader>af, …).
-- Each key sends a short request to the Claude Code pane, naming the current
-- file and position. What "hint" / "check" / "where am I" mean is defined by
-- the project's own CLAUDE.md, so these work in any project that has one
-- (written for ~/code/python-ESL).

-- "(current file: `esl/cv.py`, line 12)" or "…, lines 12-30)" in visual mode
local function location()
  local file = vim.fn.expand("%:.")
  if file == "" or vim.bo.buftype ~= "" then
    return ""
  end
  local mode = vim.fn.mode()
  local from, to = vim.fn.line("."), vim.fn.line(".")
  if mode == "v" or mode == "V" or mode == "\22" then
    from, to = vim.fn.line("v"), vim.fn.line(".")
    if from > to then
      from, to = to, from
    end
  end
  local lines = from == to and ("line " .. from) or ("lines " .. from .. "-" .. to)
  return (" (current file: `%s`, %s)"):format(file, lines)
end

-- Send to the running pane, or start Claude with the request as its first prompt.
local function ask(request)
  local terminal = require("claudecode.terminal")
  if terminal.get_active_terminal_bufnr() then
    terminal.send_to_terminal(request, { focus = true })
  else
    terminal.open({}, vim.fn.shellescape(request))
  end
end

local function tutor(request)
  return function()
    ask(request .. location())
  end
end

return {
  "coder/claudecode.nvim",
  keys = {
    {
      "<leader>an",
      tutor("Tutor request: where am I. Find my current step in PLAN.md and tell me what is next."),
      desc = "Tutor: where am I / next step",
    },
    {
      "<leader>ah",
      tutor("Tutor request: hint. Give me one hint on my current step, without the solution."),
      desc = "Tutor: hint",
    },
    {
      "<leader>ak",
      tutor("Tutor request: check. Run my current file and compare it with the target of my current step."),
      desc = "Tutor: check my work",
    },
    {
      "<leader>aq",
      function()
        local where = location() -- before vim.ui.input leaves visual mode
        vim.ui.input({ prompt = "Ask Claude: " }, function(question)
          if question and question ~= "" then
            ask(question .. where)
          end
        end)
      end,
      mode = { "n", "v" },
      desc = "Tutor: ask a question",
    },
  },
}
