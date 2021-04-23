local _0_0 = nil
do
  local name_0_ = "utils"
  local module_0_ = nil
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  module_0_["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _1_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _1_()
    return {require("aniseed.core"), require("fun"), require("aniseed.nvim")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {["require-macros"] = {macros = true}, require = {a = "aniseed.core", fun = "fun", nvim = "aniseed.nvim"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local fun = _local_0_[2]
local nvim = _local_0_[3]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "utils"
do local _ = ({nil, _0_0, {{nil}, nil, nil, nil}})[2] end
local dbg = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function dbg0(x)
      a.pr(x)
      return x
    end
    v_0_0 = dbg0
    _0_0["dbg"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["dbg"] = v_0_
  dbg = v_0_
end
local contains_3f = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function contains_3f0(list, elem)
      local function _2_(_241)
        return (elem == _241)
      end
      return fun.any(_2_, list)
    end
    v_0_0 = contains_3f0
    _0_0["contains?"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["contains?"] = v_0_
  contains_3f = v_0_
end
local without_keys = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function without_keys0(keys, t)
      local function _2_(_241)
        return not contains_3f(keys, _241)
      end
      return fun.filter(_2_, t)
    end
    v_0_0 = without_keys0
    _0_0["without-keys"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["without-keys"] = v_0_
  without_keys = v_0_
end
local keymap = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function keymap0(mode, from, to, _3fopts)
      local full_opts = fun.tomap(without_keys({"buffer"}, a.merge({noremap = true, silent = true}, (_3fopts or {}))))
      if (_3fopts and (_3fopts).buffer) then
        return nvim.buf_set_keymap(0, mode, from, to, full_opts)
      else
        return nvim.set_keymap(mode, from, to, full_opts)
      end
    end
    v_0_0 = keymap0
    _0_0["keymap"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["keymap"] = v_0_
  keymap = v_0_
end
local del_keymap = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function del_keymap0(mode, from, _3fbuf_local)
      if _3fbuf_local then
        return nvim.buf_del_keymap(0, mode, from)
      else
        return nvim.del_keymap(mode, from)
      end
    end
    v_0_0 = del_keymap0
    _0_0["del-keymap"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["del-keymap"] = v_0_
  del_keymap = v_0_
end
local colors = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function colors0()
      return {bright_aqua = "#8ec07c", bright_blue = "#83a598", bright_green = "#b8bb26", bright_orange = "#fe8019", bright_purple = "#d3869b", bright_red = "#fb4934", bright_yellow = "#fabd2f", dark0 = "#282828", dark0_hard = "#1d2021", dark0_soft = "#32302f", dark1 = "#3c3836", dark2 = "#504945", dark3 = "#665c54", dark4 = "#7c6f64", faded_aqua = "#427b58", faded_blue = "#076678", faded_green = "#79740e", faded_orange = "#af3a03", faded_purple = "#8f3f71", faded_red = "#9d0006", faded_yellow = "#b57614", gray = "#928374", light0 = "#fbf1c7", light0_hard = "#f9f5d7", light0_soft = "#f2e5bc", light1 = "#ebdbb2", light2 = "#d5c4a1", light3 = "#bdae93", light4 = "#a89984", neutral_aqua = "#689d6a", neutral_blue = "#458588", neutral_green = "#98971a", neutral_orange = "#d65d0e", neutral_purple = "#b16286", neutral_red = "#cc241d", neutral_yellow = "#d79921"}
    end
    v_0_0 = colors0
    _0_0["colors"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["colors"] = v_0_
  colors = v_0_
end
local highlight = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function highlight0(group, colset)
      local default = {bg = "NONE", fg = "NONE", gui = "NONE"}
      local opts = a.merge(default, colset)
      return nvim.command(("hi! " .. group .. " guifg='" .. opts.fg .. "' guibg='" .. opts.bg .. "' gui='" .. opts.gui .. "'"))
    end
    v_0_0 = highlight0
    _0_0["highlight"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["highlight"] = v_0_
  highlight = v_0_
end
local comp = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function comp0(f, g)
      local function _2_(...)
        return f(g(...))
      end
      return _2_
    end
    v_0_0 = comp0
    _0_0["comp"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["comp"] = v_0_
  comp = v_0_
end
return nil