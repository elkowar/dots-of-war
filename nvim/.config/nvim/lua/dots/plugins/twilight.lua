local _2afile_2a = "/home/leon/.config/nvim/fnl/dots/plugins/twilight.fnl"
local _2amodule_name_2a = "dots.plugins.twilight"
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
local twilight = autoload("twilight")
do end (_2amodule_locals_2a)["twilight"] = twilight
twilight.setup()
return _2amodule_2a