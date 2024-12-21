-- [nfnl] Compiled from fnl/dots/plugins/telescope.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("dots.prelude")
local autoload = _local_1_["autoload"]
local utils = _local_1_["utils"]
local telescope = autoload("telescope")
local actions = autoload("telescope.actions")
local function setup()
  telescope.setup({defaults = {mappings = {i = {["<esc>"] = actions.close}}, file_ignore_patterns = {"Cargo.lock", ".*.snap", "docs/theme/.*", "node%_modules/.*", "target/.*"}}, extensions = {["ui-select"] = {require("telescope.themes").get_dropdown()}}})
  telescope.load_extension("dap")
  return utils.keymap("n", "<C-p>", ":Telescope find_files<CR>")
end
return {utils.plugin("nvim-telescope/telescope.nvim", {config = setup, cmd = {"Telescope"}, dependencies = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"}})}
