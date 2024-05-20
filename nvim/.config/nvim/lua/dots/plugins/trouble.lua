-- [nfnl] Compiled from fnl/dots/plugins/trouble.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("dots.prelude")
local autoload = _local_1_["autoload"]
local utils = _local_1_["utils"]
local colors = _local_1_["colors"]
local trouble = autoload("trouble")
local function setup()
  trouble.setup({auto_close = true, auto_jump = {"lsp_definitions", "lsp_workspace_diagnostics", "lsp_type_definitions"}, action_keys = {jump = "<CR>", jump_close = "o", close = {"<esc>", "q"}, cancel = "q", preview = "p", toggle_preview = "P", toggle_mode = "m", hover = {"a", "K"}}, icons = false, auto_open = false, multiline = false, auto_preview = false, indent_lines = false})
  utils.highlight("TroubleFoldIcon", {bg = "NONE", fg = colors.bright_orange})
  utils.highlight("TroubleCount", {bg = "NONE", fg = colors.bright_green})
  utils.highlight("TroubleText", {bg = "NONE", fg = colors.light0})
  utils.highlight("TroubleSignError", {bg = "NONE", fg = colors.bright_red})
  utils.highlight("TroubleSignWarning", {bg = "NONE", fg = colors.bright_yellow})
  utils.highlight("TroubleSignInformation", {bg = "NONE", fg = colors.bright_aqua})
  return utils.highlight("TroubleSignHint", {bg = "NONE", fg = colors.bright_blue})
end
return {utils.plugin("folke/trouble.nvim", {lazy = true, config = setup, cmd = {"Trouble", "TroubleClose", "TroubleRefresh", "TroubleToggle"}})}
