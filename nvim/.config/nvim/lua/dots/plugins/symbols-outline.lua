local _2afile_2a = "/home/leon/.config/nvim/fnl/dots/plugins/symbols-outline.fnl"
local _2amodule_name_2a = "dots.plugins.symbols-outline"
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
local symbols_outline = require("symbols-outline")
do end (_2amodule_locals_2a)["symbols-outline"] = symbols_outline
symbols_outline.setup({highlight_hovered_item = true, show_guides = true})
return _2amodule_2a