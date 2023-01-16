local _2afile_2a = "/home/leon/.config/nvim/fnl/dots/plugins/sneak.fnl"
local _2amodule_name_2a = "dots.plugins.sneak"
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
local utils = autoload("dots.utils")
do end (_2amodule_locals_2a)["utils"] = utils
vim.g["sneak#label"] = 1
utils.keymap({"n", "o"}, "<DEL>", "<Plug>Sneak_s", {noremap = false})
utils.keymap({"n", "o"}, "<S-DEL>", "<Plug>Sneak_S", {noremap = false})
return _2amodule_2a