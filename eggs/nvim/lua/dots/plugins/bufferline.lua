-- [nfnl] Compiled from fnl/dots/plugins/bufferline.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("dots.prelude")
local autoload = _local_1_["autoload"]
local a = _local_1_["a"]
local utils = _local_1_["utils"]
local colors = _local_1_["colors"]
local bufferline = autoload("bufferline")
vim.cmd("hi link BufferLineTabSeparatorSelected BufferLineSeparatorSelected")
vim.cmd("hi link BufferLineTabSeparator BufferLineSeparator")
local function mk_active(fg)
  return {bg = colors.neutral_aqua, fg = fg, bold = false, italic = false}
end
local function mk_visible(fg)
  return {bg = colors.dark1, fg = fg, bold = false, italic = false}
end
local function setup()
  local selected = {bg = colors.neutral_aqua, fg = colors.bg_main, gui = "NONE"}
  local visible = {bg = colors.dark1, fg = colors.neutral_aqua}
  local function _2_(cnt, _lvl, _diagnostics_dict)
    return (" (" .. cnt .. ")")
  end
  return bufferline.setup({options = {diagnostics = "nvim_lsp", diagnostics_indicator = _2_, tab_size = 10, enforce_regular_tabs = false, show_buffer_close_icons = false, show_buffer_icons = false, show_close_icon = false, show_tab_indicators = false}, highlights = {fill = {bg = colors.bg_main, fg = colors.light0}, background = visible, buffer_visible = visible, buffer_selected = a.assoc(selected, "bold", false, "italic", false), modified = visible, modified_visible = visible, modified_selected = selected, hint = visible, hint_visible = visible, hint_selected = selected, info = visible, info_visible = visible, info_selected = selected, warning = visible, warning_visible = visible, warning_selected = selected, error = visible, error_visible = visible, error_selected = selected, duplicate = visible, duplicate_visible = visible, duplicate_selected = selected, diagnostic = mk_visible(colors.neutral_red), diagnostic_visible = mk_visible(colors.neutral_red), diagnostic_selected = mk_active(colors.faded_red), info_diagnostic = mk_visible(colors.neutral_blue), info_diagnostic_visible = mk_visible(colors.neutral_blue), info_diagnostic_selected = mk_active(colors.faded_blue), hint_diagnostic = mk_visible(colors.neutral_yellow), hint_diagnostic_visible = mk_visible(colors.neutral_yellow), hint_diagnostic_selected = mk_active(colors.faded_orange), warning_diagnostic = mk_visible(colors.neutral_orange), warning_diagnostic_visible = mk_visible(colors.neutral_orange), warning_diagnostic_selected = mk_active(colors.faded_orange), error_diagnostic = mk_visible(colors.neutral_red), error_diagnostic_visible = mk_visible(colors.neutral_red), error_diagnostic_selected = mk_active(colors.red), separator = visible, separator_visible = {bg = colors.red}, separator_selected = {bg = colors.red}, indicator_selected = {bg = colors.neutral_aqua, fg = colors.neutral_aqua, bold = false, italic = false}, tab_separator = {bg = colors.red}, tab_separator_selected = {bg = colors.neutral_aqua, fg = colors.neutral_aqua}, pick_selected = {bg = colors.bright_red, fg = colors.bright_red}, tab_selected = {bg = colors.bright_green, fg = colors.bright_green}, tab = {bg = colors.bright_yellow, fg = colors.bright_yellow}}})
end
return {utils.plugin("akinsho/nvim-bufferline.lua", {config = setup, tag = "v4.7.0"})}
