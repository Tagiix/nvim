#!/usr/bin/env lua
-- Converts the personal LuaSnip snippets (lua/plugins/luasnips/) into native
-- VSCode snippet files, for machines where only plain VSCode is available.
--
--   lua vscode/luasnip2vscode.lua            → writes latex-full / latex-light .code-snippets
--   lua vscode/luasnip2vscode.lua --index    → lists every snippet (to curate LIGHT below)
--
-- The snippet files are loaded with mocked LuaSnip constructors, so this follows
-- whatever the .lua files actually build. What VSCode cannot do is mapped as:
--   autosnippet / in_mathzone → normal Tab snippet, "(math)" in the description
--   choice node               → one snippet per choice: trig, trig2, trig3, …
--   visual selection          → ${TM_SELECTED_TEXT} (works through "Insert Snippet")
--   regex triggers            → a fixed set of concrete triggers (ENUM below)

local here = (arg[0]:match("^(.*)/[^/]*$") or ".")
local SRC = here .. "/../lua/plugins/luasnips/"
local FILES = {
  { "tex/templates.lua", "latex" },
  { "tex/structure.lua", "latex" },
  { "tex/math.lua", "latex" },
  { "tex/formatting.lua", "latex" },
  { "tex/floats.lua", "latex" },
  { "tex/fonts.lua", "latex" },
  { "tex/bibtex.lua", "latex" },
  { "bib.lua", "bibtex" },
}

-- Triggers that are pointless without auto-expansion (typing them + Tab is
-- slower than typing the character they produce).
local SKIP = { [";"] = true, [":"] = true, ["´"] = true, ["¨"] = true }

-- Regex triggers → concrete triggers. Each entry: { prefix, captures, light }
local function matrices(sep, max, light_max, light_kinds)
  local out = {}
  for kind in ("bBpvV"):gmatch(".") do
    for rows = 1, max do
      for cols = 1, max do
        local light = light_kinds and light_kinds:find(kind, 1, true) and rows <= light_max and cols <= light_max
        out[#out + 1] = { kind .. rows .. sep .. cols, { kind, tostring(rows), tostring(cols) }, light or false }
      end
    end
  end
  return out
end

local ENUM = {
  ["([bBpvV])(%d+)x(%d+)"] = matrices("x", 4, 3, "bp"),
  ["([bBpvV])(%d+)h(%d+)"] = matrices("h", 3, 0, nil),
  ["([bBpvV])gn"] = (function()
    local out = {}
    for kind in ("bBpvV"):gmatch(".") do
      out[#out + 1] = { kind .. "gn", { kind }, false }
    end
    return out
  end)(),
  ["(%d?)cs"] = {
    { "cs", { "" }, true },
    { "2cs", { "2" }, false },
    { "3cs", { "3" }, true },
    { "4cs", { "4" }, false },
    { "5cs", { "5" }, false },
  },
}

-- Light version: per file, either true (everything) or a list of triggers.
local function words(str)
  local out = {}
  for word in str:gmatch("%S+") do
    out[#out + 1] = word
  end
  return out
end

local LIGHT = {
  ["tex/templates.lua"] = true,
  ["tex/structure.lua"] = words("doc pk tl aut dat bd mkt toc scn sbn ssn lge lsn lbe lfg lta rge rsn rfe rfg rta"),
  ["tex/math.lua"] = words([[
    mm nn aa gg sp en tx (%d?)cs ([bBpvV])(%d+)x(%d+)
    mc mb mk mr mf ff sq bx
    .a .b .c .D .d .e .G .g .h .i .k .L .l .m .n .O .o .Ph .ph .Pi .pi .Ps .ps .r .S .s .ta .Th .th .U .u .X .x .z
    dp ds bb db da dn dk vv ht til ovr und dr
    sm ss pp itn its itd df der pdr lm
    fy pt nb le ge ne app eq ip iff fa ex in cd tm pm dd cr qu qq rar to
    nun nit sbs sbq vc
  ]]),
  ["tex/formatting.lua"] = words("oo pf ps cc ll dd re ex ee tz enn tm foo cen url"),
  ["tex/floats.lua"] = words("tab cpt hn"),
  ["tex/fonts.lua"] = words("bf it em tt"),
  ["tex/bibtex.lua"] = words("ct tc tpc bib bisty"),
  ["bib.lua"] = words("art bks inp mis phd"),
}

---------------------------------------------------------------------------
-- Mock LuaSnip
---------------------------------------------------------------------------

local function node(kind, fields)
  fields._k = kind
  return fields
end

local function aslist(x)
  if x == nil then
    return {}
  end
  if x._k then
    return { x }
  end
  return x
end

local function astext(x)
  if type(x) == "table" then
    return table.concat(x, "\n")
  end
  return x
end

local M = {}
function M.t(x)
  return node("text", { s = astext(x) })
end
function M.i(pos, default)
  return node("insert", { pos = pos, default = default and astext(default) or nil })
end
function M.rep(pos)
  return node("mirror", { pos = pos })
end
function M.c(pos, choices)
  local list = {}
  for n, choice in ipairs(choices) do
    list[n] = aslist(choice)
  end
  return node("choice", { pos = pos, choices = list })
end
function M.sn(pos, nodes)
  return node("group", { pos = pos, nodes = aslist(nodes) })
end
function M.r(pos, _, nodes)
  nodes = aslist(type(nodes) == "table" and nodes or nil)
  if #nodes == 0 or (#nodes == 1 and nodes[1]._k == "insert") then
    return M.i(pos, nodes[1] and nodes[1].default)
  end
  return node("group", { pos = pos, nodes = nodes })
end
function M.d(pos, fn)
  return node("dynamic", { pos = pos, fn = fn })
end
function M.f(fn)
  return node("func", { fn = fn })
end
function M.fmta(str, nodes)
  nodes = aslist(nodes)
  local lines = {}
  for line in (str .. "\n"):gmatch("(.-)\n") do
    lines[#lines + 1] = line
  end
  if lines[1] and lines[1]:match("^%s*$") then
    table.remove(lines, 1)
  end
  if lines[#lines] and lines[#lines]:match("^%s*$") then
    table.remove(lines)
  end
  local indent
  for _, line in ipairs(lines) do
    if not line:match("^%s*$") then
      local n = #line:match("^%s*")
      indent = math.min(indent or n, n)
    end
  end
  for n, line in ipairs(lines) do
    lines[n] = line:match("^%s*$") and "" or line:sub((indent or 0) + 1)
  end
  local out, next_arg, text = {}, 1, table.concat(lines, "\n")
  local pos = 1
  while true do
    local a, b = text:find("<>", pos, true)
    if not a then
      break
    end
    out[#out + 1] = M.t(text:sub(pos, a - 1))
    out[#out + 1] = assert(nodes[next_arg], "fmta: not enough nodes")
    next_arg = next_arg + 1
    pos = b + 1
  end
  out[#out + 1] = M.t(text:sub(pos))
  assert(next_arg == #nodes + 1, "fmta: unused nodes")
  return out
end
function M.s(ctx, nodes, opts)
  if type(ctx) == "string" then
    ctx = { trig = ctx }
  end
  return {
    trig = ctx.trig,
    name = ctx.name or ctx.dscr or ctx.trig,
    regex = ctx.regTrig or false,
    auto = ctx.snippetType == "autosnippet",
    math = opts ~= nil and opts.condition ~= nil,
    nodes = aslist(nodes),
  }
end

local luasnip = {
  snippet = M.s,
  snippet_node = M.sn,
  text_node = M.t,
  insert_node = M.i,
  choice_node = M.c,
  dynamic_node = M.d,
  function_node = M.f,
  restore_node = M.r,
}

local DATE = { a = "CURRENT_DAY_NAME_SHORT", d = "CURRENT_DATE", b = "CURRENT_MONTH_NAME_SHORT", y = "CURRENT_YEAR_SHORT",
  Y = "CURRENT_YEAR", m = "CURRENT_MONTH", H = "CURRENT_HOUR", M = "CURRENT_MINUTE" }

local function load_snippets(path)
  local env = setmetatable({
    require = function(name)
      if name == "luasnip" then
        return luasnip
      end
      error("unexpected require: " .. name)
    end,
    -- evaluated at expansion time in VSCode, not at conversion time
    os = setmetatable({ date = function(fmt) return "\1" .. fmt .. "\1" end }, { __index = os }),
  }, {
    __index = function(_, k)
      local v = M[k]
      if v == nil then
        v = _G[k]
      end
      if v == nil then
        error("unknown global in snippet file: " .. tostring(k))
      end
      return v
    end,
  })
  return assert(loadfile(path, "t", env))()
end

---------------------------------------------------------------------------
-- Flatten a node tree into text / stop / mirror tokens
---------------------------------------------------------------------------

local function max_choices(nodes, acc)
  acc = acc or { max = 1, count = 0 }
  for _, n in ipairs(nodes) do
    if n._k == "choice" then
      acc.count = acc.count + 1
      acc.max = math.max(acc.max, #n.choices)
      for _, choice in ipairs(n.choices) do
        max_choices(choice, acc)
      end
    elseif n._k == "group" then
      max_choices(n.nodes, acc)
    end
  end
  return acc
end

local function key_of(prefix, pos)
  local key = { table.unpack(prefix) }
  key[#key + 1] = (pos == 0 and #prefix > 0) and 1e6 or pos
  return key
end

local function flatten(nodes, prefix, ctx, out)
  for _, n in ipairs(nodes) do
    if n._k == "text" then
      out[#out + 1] = { k = "text", s = n.s }
    elseif n._k == "insert" then
      out[#out + 1] = { k = "stop", key = key_of(prefix, n.pos), default = n.default }
    elseif n._k == "mirror" then
      out[#out + 1] = { k = "mirror", key = key_of(prefix, n.pos) }
    elseif n._k == "group" then
      flatten(n.nodes, key_of(prefix, n.pos), ctx, out)
    elseif n._k == "choice" then
      flatten(n.choices[math.min(ctx.choice, #n.choices)], key_of(prefix, n.pos), ctx, out)
    elseif n._k == "dynamic" then
      local res = aslist(n.fn({}, ctx.snip))
      if res._k == nil and #res == 1 and res[1]._k == "group" then
        res = res[1].nodes
      end
      if #res == 1 and res[1]._k == "insert" then
        -- the get_visual idiom
        out[#out + 1] = { k = "stop", key = key_of(prefix, n.pos), default = res[1].default, visual = true }
      else
        flatten(res, key_of(prefix, n.pos), ctx, out)
      end
    elseif n._k == "func" then
      local res = n.fn({}, ctx.snip)
      if res ~= nil then
        out[#out + 1] = { k = "text", s = astext(res) }
      end
    else
      error("unhandled node kind " .. tostring(n._k))
    end
  end
  return out
end

local function key_less(a, b)
  for n = 1, math.max(#a, #b) do
    if a[n] ~= b[n] then
      return (a[n] or -1) < (b[n] or -1)
    end
  end
  return false
end

local function esc(s, in_placeholder)
  s = s:gsub("\\", "\\\\"):gsub("%$", "\\$")
  if in_placeholder then
    s = s:gsub("}", "\\}")
  end
  return s
end

local warnings = {}
local function warn(msg)
  warnings[#warnings + 1] = msg
end

local function render(snippet, ctx)
  local tokens = flatten(snippet.nodes, {}, ctx, {})
  -- number the tab stops in jump order; a repeated insert index gets its own stop
  local seen, keys = {}, {}
  for _, tok in ipairs(tokens) do
    if tok.k == "stop" then
      local id = table.concat(tok.key, ".")
      if seen[id] then
        seen[id] = seen[id] + 1
        tok.key[#tok.key] = tok.key[#tok.key] + seen[id] * 0.001
        warn(("%s: insert index %s used twice, kept as separate stops"):format(ctx.prefix, id))
      else
        seen[id] = 0
      end
      keys[#keys + 1] = tok.key
    end
  end
  table.sort(keys, key_less)
  local number, next_number = {}, 1
  for _, key in ipairs(keys) do
    local id = table.concat(key, ".")
    if id == "0" then
      number[id] = 0
    else
      number[id] = next_number
      next_number = next_number + 1
    end
  end
  local parts = {}
  for _, tok in ipairs(tokens) do
    if tok.k == "text" then
      local text = esc(tok.s):gsub("\1(.-)\1", function(fmt)
        return (fmt:gsub("%%(%a)", function(code)
          return "${" .. assert(DATE[code], "unsupported os.date code %" .. code) .. "}"
        end))
      end)
      parts[#parts + 1] = text
    else
      local num = number[table.concat(tok.key, ".")]
      if not num then
        warn(("%s: mirror of a missing stop dropped"):format(ctx.prefix))
      elseif tok.k == "mirror" then
        parts[#parts + 1] = "${" .. num .. "}"
      elseif tok.visual then
        local default = tok.default and (":" .. esc(tok.default, true)) or ""
        parts[#parts + 1] = "${" .. num .. ":${TM_SELECTED_TEXT" .. default .. "}}"
      elseif tok.default then
        parts[#parts + 1] = "${" .. num .. ":" .. esc(tok.default, true) .. "}"
      else
        parts[#parts + 1] = "${" .. num .. "}"
      end
    end
  end
  return table.concat(parts)
end

---------------------------------------------------------------------------
-- Build the snippet list
---------------------------------------------------------------------------

local entries = {} -- { file, scope, base, prefix, description, body, light }

for _, spec in ipairs(FILES) do
  local file, scope = spec[1], spec[2]
  local light = LIGHT[file]
  local light_set = {}
  if type(light) == "table" then
    for _, trig in ipairs(light) do
      light_set[trig] = true
    end
  end
  for _, snippet in ipairs(load_snippets(SRC .. file)) do
    if SKIP[snippet.trig] then
      warn(("%s: skipped (needs auto-expansion)"):format(snippet.trig))
    else
      local base = snippet.trig:gsub("%[%.%]", ".")
      local expansions
      if snippet.regex and ENUM[snippet.trig] then
        expansions = ENUM[snippet.trig]
      elseif snippet.regex and base:find("[%%%(%[%*%+%?]") then
        error("regex trigger without an ENUM entry: " .. snippet.trig)
      else
        expansions = { { base, {}, nil } }
      end
      local info = max_choices(snippet.nodes)
      if info.count > 1 then
        warn(("%s: %d choice nodes, variants pair them up by position"):format(base, info.count))
      end
      for _, expansion in ipairs(expansions) do
        for choice = 1, info.max do
          local prefix = expansion[1] .. (choice > 1 and choice or "")
          local ctx = {
            choice = choice,
            prefix = prefix,
            snip = { captures = expansion[2], snippet = { env = { LS_SELECT_RAW = {} } } },
          }
          local description = snippet.name .. (snippet.math and " (math)" or "")
          if info.max > 1 then
            description = description .. (" [%d/%d]"):format(choice, info.max)
          end
          local is_light = expansion[3]
          if is_light == nil then
            is_light = light == true or light_set[base] or false
          else
            is_light = is_light and (light == true or light_set[snippet.trig] or false)
          end
          entries[#entries + 1] = {
            file = file,
            scope = scope,
            base = snippet.trig,
            prefix = prefix,
            description = description,
            body = render(snippet, ctx),
            light = is_light,
            auto = snippet.auto,
            math = snippet.math,
          }
        end
      end
    end
  end
end

if arg[1] == "--index" then
  local last
  for _, e in ipairs(entries) do
    if e.file ~= last then
      io.write("\n## ", e.file, "\n")
      last = e.file
    end
    io.write(e.prefix, "=", e.description, " | ")
  end
  io.write("\n")
  return
end

---------------------------------------------------------------------------
-- Write the .code-snippets files
---------------------------------------------------------------------------

local function json(s)
  return '"' .. s:gsub('[%c"\\]', function(ch)
    local map = { ['"'] = '\\"', ["\\"] = "\\\\", ["\n"] = "\\n", ["\t"] = "\\t" }
    return map[ch] or ("\\u%04x"):format(ch:byte())
  end) .. '"'
end

local function write(path, list)
  local used, items = {}, {}
  for _, e in ipairs(list) do
    local key = e.prefix .. " — " .. e.description
    while used[key] do
      key = key .. "'"
    end
    used[key] = true
    local lines = {}
    for line in (e.body .. "\n"):gmatch("(.-)\n") do
      lines[#lines + 1] = "      " .. json(line)
    end
    items[#items + 1] = ("  %s: {\n    \"scope\": %s,\n    \"prefix\": %s,\n    \"description\": %s,\n    \"body\": [\n%s\n    ]\n  }"):format(
      json(key), json(e.scope), json(e.prefix), json(e.description), table.concat(lines, ",\n"))
  end
  local fh = assert(io.open(path, "w"))
  fh:write("{\n", table.concat(items, ",\n"), "\n}\n")
  fh:close()
  print(("%-40s %d snippets"):format(path, #list))
end

local light = {}
for _, e in ipairs(entries) do
  if e.light then
    light[#light + 1] = e
  end
end
write(here .. "/latex-full.code-snippets", entries)
write(here .. "/latex-light.code-snippets", light)

-- Report
local by_prefix = {}
for _, e in ipairs(entries) do
  by_prefix[e.prefix] = by_prefix[e.prefix] or {}
  table.insert(by_prefix[e.prefix], e)
end
for prefix, list in pairs(by_prefix) do
  local bases = {}
  for _, e in ipairs(list) do
    bases[e.base] = true
  end
  local n = 0
  for _ in pairs(bases) do
    n = n + 1
  end
  if n > 1 then
    warn(("%s: choice variant collides with another trigger"):format(prefix))
  end
end
table.sort(warnings)
for _, w in ipairs(warnings) do
  io.stderr:write("note: ", w, "\n")
end
