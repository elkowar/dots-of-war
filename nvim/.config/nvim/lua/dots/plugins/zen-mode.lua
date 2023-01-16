local _2afile_2a = "/home/leon/.config/nvim/fnl/dots/plugins/zen-mode.fnl"
local _2amodule_name_2a = "dots.plugins"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local autoload = (require("aniseed.autoload")).autoload
local zen_mode = autoload("zen-mode")
do end (_2amodule_locals_2a)["zen-mode"] = zen_mode
zen_mode.setup({window = {options = {wrap = true}}})
return _2amodule_2a