-- [nfnl] Compiled from fnl/dots/plugins/nvim-colorizer.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("dots.prelude")
local autoload = _local_1_["autoload"]
local utils = _local_1_["utils"]
local colorizer = autoload("colorizer")
local function _2_()
  return colorizer.setup({"*"}, {RGB = true, RRGGBB = true, names = true, RRGGBBAA = true, rgb_fn = true, hsl_fn = true, mode = "background"})
end
return {utils.plugin("norcalli/nvim-colorizer.lua", {event = "VeryLazy", lazy = true, config = _2_})}
