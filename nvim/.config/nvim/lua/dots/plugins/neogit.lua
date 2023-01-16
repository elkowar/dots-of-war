local _2afile_2a = "/home/leon/.config/nvim/fnl/dots/plugins/neogit.fnl"
local _2amodule_name_2a = "dots.plugins.neogit"
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
local a, neogit = autoload("aniseed.core"), autoload("neogit")
do end (_2amodule_locals_2a)["a"] = a
_2amodule_locals_2a["neogit"] = neogit
neogit.setup({integrations = {diffview = true}})
return _2amodule_2a