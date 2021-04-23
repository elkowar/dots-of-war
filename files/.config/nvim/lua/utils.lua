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
    return {require("aniseed.core"), require("aniseed.nvim")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {["require-macros"] = {macros = true}, require = {a = "aniseed.core", nvim = "aniseed.nvim"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local nvim = _local_0_[2]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "utils"
do local _ = ({nil, _0_0, {{nil}, nil, nil, nil}})[2] end
local noremap = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function noremap0(mode, from, to)
      return nvim.set_keymap(mode, from, to, {noremap = true, silent = true})
    end
    v_0_0 = noremap0
    _0_0["noremap"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["noremap"] = v_0_
  noremap = v_0_
end
local mapexpr = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function mapexpr0(mode, from, to)
      return nvim.set_keymap(mode, from, to, {expr = true, noremap = true, silent = true})
    end
    v_0_0 = mapexpr0
    _0_0["mapexpr"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["mapexpr"] = v_0_
  mapexpr = v_0_
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