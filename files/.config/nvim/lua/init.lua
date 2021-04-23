local _0_0 = nil
do
  local name_0_ = "init"
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
    return {require("aniseed.core"), require("aniseed.fennel"), require("keybinds"), require("aniseed.nvim"), require("utils")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {["require-macros"] = {macros = true}, require = {a = "aniseed.core", fennel = "aniseed.fennel", kb = "keybinds", nvim = "aniseed.nvim", utils = "utils"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local fennel = _local_0_[2]
local kb = _local_0_[3]
local nvim = _local_0_[4]
local utils = _local_0_[5]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "init"
do local _ = ({nil, _0_0, {{nil}, nil, nil, nil}})[2] end
require("plugins.telescope")
require("plugins.lsp")
require("plugins.galaxyline")
local function _2_(x)
  return print(fennel.view(x))
end
pp = _2_
local colors = utils.colors()
local bufferline = require("bufferline")
do
  local selected = {gui = "", guibg = colors.neutral_aqua, guifg = colors.dark0}
  local visible = {gui = "", guibg = colors.dark1, guifg = colors.neutral_aqua}
  local function _3_(cnt, lvl, diagnostics_dict)
    return (" (" .. cnt .. ")")
  end
  bufferline.setup({highlights = {background = visible, buffer_selected = selected, buffer_visible = visible, error = {guifg = colors.bright_green}, error_selected = selected, error_visible = visible, fill = {guibg = colors.dark0, guifg = colors.light0}, indicator_selected = {guibg = colors.neutral_aqua, guifg = colors.neutral_aqua}, modified = visible, modified_selected = selected, modified_visible = visible, pick_selected = {guibg = colors.bright_red, guifg = colors.bright_red}, separator = visible, tab = {guibg = colors.bright_yellow, guifg = colors.bright_yellow}, tab_selected = {guibg = colors.bright_green, guifg = colors.bright_green}, warning = visible, warning_selected = selected, warning_visible = visible}, options = {diagnostics = "nvim_lsp", diagnostics_indicator = _3_, enforce_regular_tabs = false, show_buffer_close_icons = false, show_close_icon = false, show_tab_indicators = false, tab_size = 10}})
end
return utils.highlight("BufferLineInfoSelected", {bg = colors.neutral_aqua, fg = colors.dark0, gui = "NONE"})