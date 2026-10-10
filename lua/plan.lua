-- Offline view of a project's PLAN.md: the first unticked "- [ ]" box is the
-- current step. show() floats it, done() ticks it, hint() reveals that step's
-- hints from HINTS.md one level at a time. No Claude involved.
-- (Written for ~/code/python-ESL; works in any project with a PLAN.md.)
local M = {}

local TODO, DONE = "^%s*%- %[ %]", "^%s*%- %[[xX]%]"

local plan_path

local function plan_buf()
  local path = vim.fs.find("PLAN.md", { upward = true, path = vim.fn.getcwd() })[1]
  plan_path = path
  if not path then
    vim.notify("No PLAN.md in " .. vim.fn.getcwd() .. " or above", vim.log.levels.WARN)
    return
  end
  local buf = vim.fn.bufadd(path)
  vim.fn.bufload(buf)
  return buf
end

-- Line number of the current step, plus how many boxes are ticked / in total.
local function current(lines)
  local first, done, total = nil, 0, 0
  for i, line in ipairs(lines) do
    if line:match(DONE) then
      done, total = done + 1, total + 1
    elseif line:match(TODO) then
      first, total = first or i, total + 1
    end
  end
  return first, done, total
end

-- A step runs until a blank line, the next box or a heading.
local function step_end(lines, from)
  local to = from
  while lines[to + 1] and lines[to + 1] ~= "" and not lines[to + 1]:match("^%s*%- %[") and not lines[to + 1]:match("^#") do
    to = to + 1
  end
  return to
end

function M.show()
  local buf = plan_buf()
  if not buf then
    return
  end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local at, done, total = current(lines)
  if not at then
    vim.notify(("PLAN.md: all %d steps done"):format(total))
    return
  end

  local from = at -- the stage is the "## " section around the step
  while from > 1 and not lines[from]:match("^## ") do
    from = from - 1
  end
  local to = at
  while lines[to + 1] and not lines[to + 1]:match("^## ") do
    to = to + 1
  end

  local out = { lines[from], "", ("Step %d of %d · PLAN.md line %d"):format(done + 1, total, at), "" }
  vim.list_extend(out, vim.list_slice(lines, at, step_end(lines, at)))
  -- the stage's "Notes: …" line and "**nvim …" paragraphs
  local keep = false
  for i = from + 1, to do
    if lines[i]:match("^Notes:") or lines[i]:match("^%*%*nvim") then
      keep = true
      out[#out + 1] = ""
    elseif lines[i] == "" then
      keep = false
    end
    if keep then
      out[#out + 1] = lines[i]
    end
  end

  vim.lsp.util.open_floating_preview(out, "markdown", {
    border = "rounded",
    title = " Where am I ",
    title_pos = "center",
    max_width = math.min(92, vim.o.columns - 4),
    wrap = true,
    focus_id = "plan",
  })
end

function M.done()
  local buf = plan_buf()
  if not buf then
    return
  end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local at = current(lines)
  if not at then
    vim.notify("PLAN.md: nothing left to tick")
    return
  end
  local step = table.concat(vim.list_slice(lines, at, step_end(lines, at)), "\n")
  if vim.fn.confirm("Tick this step as done?\n\n" .. step, "&Yes\n&No", 2) ~= 1 then
    return
  end
  vim.api.nvim_buf_set_lines(buf, at - 1, at, false, { (lines[at]:gsub("%[ %]", "[x]", 1)) })
  vim.api.nvim_buf_call(buf, function()
    vim.cmd("silent update")
  end)
  M.show()
end

-- HINTS.md sits next to PLAN.md: a "## 1.3" heading per step, then a numbered
-- list, one item per level. Returns the items of one step as lists of lines.
local function read_hints(path, step)
  local levels, inside = {}, false
  for line in io.lines(path) do
    local heading = line:match("^## (.+)$")
    if heading then
      inside = vim.trim(heading) == step
    elseif inside and line:match("^%d+%. ") then
      levels[#levels + 1] = { line }
    elseif inside and #levels > 0 and line ~= "" and not line:match("^%-%-%-") then
      table.insert(levels[#levels], line)
    end
  end
  return levels
end

local shown = {} -- step -> levels revealed so far, for this nvim session

function M.hint()
  local buf = plan_buf()
  if not buf then
    return
  end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local at = current(lines)
  local step = at and lines[at]:match("%*%*(%d+%.%d+)")
  if not step then
    vim.notify("PLAN.md: the current step has no number to look hints up by", vim.log.levels.WARN)
    return
  end
  local path = vim.fs.joinpath(vim.fs.dirname(plan_path), "HINTS.md")
  local levels = vim.uv.fs_stat(path) and read_hints(path, step) or {}
  if #levels == 0 then
    vim.notify(("No hints written for step %s (<leader>aH asks Claude)"):format(step), vim.log.levels.WARN)
    return
  end

  shown[step] = math.min((shown[step] or 0) + 1, #levels)
  local out = { ("## Step %s · hint %d of %d"):format(step, shown[step], #levels), "" }
  for i = 1, shown[step] do
    vim.list_extend(out, levels[i])
    out[#out + 1] = ""
  end
  out[#out + 1] = shown[step] < #levels and "_`<leader>ah` again for the next level._"
    or "_Last hint. `<leader>aH` asks Claude to look at your code._"

  vim.lsp.util.open_floating_preview(out, "markdown", {
    border = "rounded",
    title = " Hint ",
    title_pos = "center",
    max_width = math.min(92, vim.o.columns - 4),
    wrap = true,
  })
end

return M
