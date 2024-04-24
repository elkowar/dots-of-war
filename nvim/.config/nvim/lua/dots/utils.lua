-- [nfnl] Compiled from fnl/dots/utils.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("dots.prelude")
local autoload = _local_1_["autoload"]
local a = _local_1_["a"]
local str = _local_1_["str"]
local function plugin(name, _3fopts)
  if (nil == _3fopts) then
    return name
  else
    _3fopts[1] = name
    return _3fopts
  end
end
local function all(f)
  local function _3_(_241)
    return not f(_241)
  end
  return not a.some(_3_)
end
local function single_to_list(x)
  if a["table?"](x) then
    return x
  else
    return {x}
  end
end
local function contains_3f(list, elem)
  local function _5_(_241)
    return (elem == _241)
  end
  do local _ = a.some(_5_, list) end
  return false
end
local function filter_table(f, t)
  local tbl_14_auto = {}
  for k, v in pairs(t) do
    local k_15_auto, v_16_auto = nil, nil
    if f(k, v) then
      k_15_auto, v_16_auto = k, v
    else
      k_15_auto, v_16_auto = nil
    end
    if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
      tbl_14_auto[k_15_auto] = v_16_auto
    else
    end
  end
  return tbl_14_auto
end
local function split_last(s, sep)
  for i = #s, 1, -1 do
    local c = s:sub(i, i)
    if (sep == c) then
      local left = s:sub(1, (i - 1))
      local right = s:sub((i + 1))
      return { left, right }
    else
    end
  end
  return {s}
end
local function find_where(pred, xs)
  for _, x in ipairs(xs) do
    if pred(x) then
      return x
    else
    end
  end
  return nil
end
local function find_map(f, xs)
  for _, x in ipairs(xs) do
    local res = f(x)
    if (nil ~= res) then
      return res
    else
    end
  end
  return nil
end
local function keep_if(f, x)
  if f(x) then
    return x
  else
    return nil
  end
end
local function map_values(f, t)
  local tbl = {}
  for k, v in pairs(t) do
    tbl[k] = f(v)
  end
  return tbl
end
local function without_keys(keys, t)
  local function _12_(_241)
    return not contains_3f(keys, _241)
  end
  return filter_table(_12_, t)
end
local function keymap(modes, from, to, _3fopts)
  local full_opts = without_keys({"buffer"}, a.merge({noremap = true, silent = true}, (_3fopts or {})))
  for _, mode in ipairs(single_to_list(modes)) do
    local keymap_opts
    local _14_
    do
      local _13_ = _3fopts
      if (nil ~= _13_) then
        _14_ = (_13_).buffer
      else
        _14_ = _13_
      end
    end
    if _14_ then
      keymap_opts = a.assoc(full_opts, "buffer", 0)
    else
      keymap_opts = full_opts
    end
    vim.keymap.set(mode, from, to, keymap_opts)
  end
  return nil
end
local function del_keymap(mode, from, _3fbuf_local)
  local function _17_()
    if _3fbuf_local then
      return {buffer = 0}
    else
      return {}
    end
  end
  return vim.keymap.del(mode, from, _17_())
end
local function buffer_content(bufnr)
  return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
end
local function surround_if_present(a0, mid, b)
  if mid then
    return (a0 .. mid .. b)
  else
    return ""
  end
end
local function highlight(group_arg, colset)
  local default = {fg = "NONE", bg = "NONE", gui = "NONE"}
  local opts = a.merge(default, colset)
  for _, group in ipairs(single_to_list(group_arg)) do
    vim.cmd(("hi! " .. group .. " guifg='" .. opts.fg .. "' guibg='" .. opts.bg .. "' gui='" .. opts.gui .. "'"))
  end
  return nil
end
local function highlight_add(group_arg, colset)
  for _, group in ipairs(single_to_list(group_arg)) do
    vim.cmd(("hi! " .. group .. surround_if_present(" guibg='", colset.bg, "'") .. surround_if_present(" guifg='", colset.fg, "'") .. surround_if_present(" gui='", colset.gui, "'")))
  end
  return nil
end
local function shorten_path(path, seg_length, shorten_after)
  local segments = str.split(path, "/")
  if ((shorten_after > #path) or (2 > #segments)) then
    return path
  else
    local init = a.butlast(segments)
    local filename = a.last(segments)
    local shortened_segs
    local function _19_(_241)
      return string.sub(_241, 1, seg_length)
    end
    shortened_segs = a.map(_19_, init)
    return (str.join("/", shortened_segs) .. "/" .. filename)
  end
end
local function comp(f, g)
  local function _21_(...)
    return f(g(...))
  end
  return _21_
end
local function get_selection()
  local _let_22_ = vim.fn.getpos("'<")
  local _ = _let_22_[1]
  local s_start_line = _let_22_[2]
  local s_start_col = _let_22_[3]
  local _let_23_ = vim.fn.getpos("'>")
  local _0 = _let_23_[1]
  local s_end_line = _let_23_[2]
  local s_end_col = _let_23_[3]
  local n_lines = (1 + math.abs((s_end_line - s_start_line)))
  local lines = vim.api.nvim_buf_get_lines(0, (s_start_line - 1), s_end_line, false)
  if (nil == lines[1]) then
    return s_start_line, s_end_line, lines
  else
    lines[1] = string.sub(lines[1], s_start_col, -1)
    if (1 == n_lines) then
      lines[n_lines] = string.sub(lines[n_lines], 1, (1 + (s_end_col - s_start_col)))
    else
      lines[n_lines] = string.sub(lines[n_lines], 1, s_end_col)
    end
    return s_start_line, s_end_line, lines
  end
end
return {plugin = plugin, all = all, ["single-to-list"] = single_to_list, ["contains?"] = contains_3f, ["filter-table"] = filter_table, ["split-last"] = split_last, ["find-where"] = find_where, ["find-map"] = find_map, ["keep-if"] = keep_if, ["map-values"] = map_values, ["without-keys"] = without_keys, keymap = keymap, ["del-keymap"] = del_keymap, ["buffer-content"] = buffer_content, ["surround-if-present"] = surround_if_present, highlight = highlight, ["highlight-add"] = highlight_add, ["shorten-path"] = shorten_path, comp = comp, ["get-selection"] = get_selection}
