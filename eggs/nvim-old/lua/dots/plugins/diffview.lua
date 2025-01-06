-- [nfnl] Compiled from fnl/dots/plugins/diffview.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("dots.prelude")
local autoload = _local_1_["autoload"]
local utils = _local_1_["utils"]
local cb = autoload("diffview.config")
local diffview = autoload("diffview")
local function _2_()
  return diffview.setup({file_panel = {width = 35, use_icons = false}, key_bindings = {view = {["<leader>dn"] = cb.diffview_callback("select_next_entry"), ["<leader>dp"] = cb.diffview_callback("select_prev_entry"), ["<leader>dd"] = cb.diffview_callback("toggle_files")}}, diff_binaries = false})
end
return {utils.plugin("sindrets/diffview.nvim", {cmd = {"DiffviewOpen", "DiffviewToggleFiles"}, config = _2_})}
