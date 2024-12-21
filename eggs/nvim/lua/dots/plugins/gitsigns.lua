-- [nfnl] Compiled from fnl/dots/plugins/gitsigns.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local utils = autoload("dots.utils")
local gitsigns = autoload("gitsigns")
local function setup()
  gitsigns.setup({signs = {add = {text = "\226\150\141"}, change = {text = "\226\150\141"}, delete = {text = "\226\150\141"}, topdelete = {text = "\226\150\141"}, changedelete = {text = "\226\150\141"}}, update_debounce = 100, current_line_blame = false})
  local scrollbar_gitsigns = require("scrollbar.handlers.gitsigns")
  return scrollbar_gitsigns.setup()
end
return {utils.plugin("lewis6991/gitsigns.nvim", {dependencies = {"vim-gruvbox8", "petertriho/nvim-scrollbar"}, config = setup})}
