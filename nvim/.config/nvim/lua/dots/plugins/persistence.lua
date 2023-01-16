local _2afile_2a = "/home/leon/.config/nvim/fnl/dots/plugins/persistence.fnl"
local _2amodule_name_2a = "dots.plugins.persistence"
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
local persistence = autoload("persistence")
do end (_2amodule_locals_2a)["persistence"] = persistence
persistence.setup({dir = vim.fn.expand((vim.fn.stdpath("cache") .. "/sessions/"))})
return _2amodule_2a