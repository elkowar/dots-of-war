-- [nfnl] Compiled from fnl/dots/plugins/feline.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("dots.prelude")
local autoload = _local_1_["autoload"]
local utils = _local_1_["utils"]
local a = _local_1_["a"]
local str = _local_1_["str"]
local colors = _local_1_["colors"]
local feline = autoload("feline")
local function setup()
  vim.opt.termguicolors = true
  local modes = {n = {text = "NORMAL", color = colors.neutral_aqua}, i = {text = "INSERT", color = colors.neutral_yellow}, c = {text = "CMMAND", color = colors.neutral_aqua}, ce = {text = "NORMEX", color = colors.neutral_aqua}, cv = {text = "EX", color = colors.neutral_aqua}, ic = {text = "INSCOMP", color = colors.neutral_aqua}, no = {text = "OP-PENDING", color = colors.neutral_aqua}, r = {text = "HIT-ENTER", color = colors.neutral_aqua}, ["r?"] = {text = "CONFIRM", color = colors.neutral_aqua}, R = {text = "REPLACE", color = colors.neutral_aqua}, Rv = {text = "VIRTUAL", color = colors.neutral_aqua}, s = {text = "SELECT", color = colors.neutral_aqua}, S = {text = "SELECT", color = colors.neutral_aqua}, t = {text = "TERM", color = colors.neutral_aqua}, v = {text = "VISUAL", color = colors.neutral_blue}, V = {text = "VISUAL LINE", color = colors.neutral_blue}, ["\22"] = {text = "VISUAL BLOCK", color = colors.neutral_blue}}
  local bar_bg = colors.bg_main
  local horiz_separator_color = colors.light1
  local function or_empty(x)
    return (x or "")
  end
  local function spaces(x)
    if x then
      return (" " .. x .. " ")
    else
      return ""
    end
  end
  local function get_current_filepath()
    local file = utils["shorten-path"](vim.fn.bufname(), 30, 30)
    if a["empty?"](file) then
      return ""
    elseif vim.bo.readonly then
      return ("RO " .. file)
    elseif (vim.bo.modifiable and vim.bo.modified) then
      return (file .. " \226\151\143")
    else
      return (file .. " ")
    end
  end
  local function vim_mode_hl(use_as_fg_3f)
    local color = modes[vim.fn.mode()].color
    if use_as_fg_3f then
      return {bg = bar_bg, fg = color}
    else
      return {bg = color, fg = bar_bg}
    end
  end
  local function git_status_provider()
    local function _5_(_241)
      return ("master" ~= _241)
    end
    local function _7_()
      local t_6_ = vim.b
      if (nil ~= t_6_) then
        t_6_ = (t_6_).gitsigns_status_dict
      else
      end
      if (nil ~= t_6_) then
        t_6_ = (t_6_).head
      else
      end
      return t_6_
    end
    return or_empty(utils["keep-if"](_5_, _7_()))
  end
  local function vim_mode()
    return (" " .. (modes[vim.fn.mode()].text or vim.fn.mode) .. " ")
  end
  local function lsp_progress_provider()
    local msgs = vim.lsp.util.get_progress_messages()
    local s
    do
      local tbl_17_auto = {}
      local i_18_auto = #tbl_17_auto
      for _, msg in ipairs(msgs) do
        local val_19_auto
        if msg.message then
          val_19_auto = (msg.title .. " " .. msg.message)
        else
          val_19_auto = nil
        end
        if (nil ~= val_19_auto) then
          i_18_auto = (i_18_auto + 1)
          do end (tbl_17_auto)[i_18_auto] = val_19_auto
        else
        end
      end
      s = tbl_17_auto
    end
    return or_empty(str.join(" | ", s))
  end
  local function lsp_diagnostic_component(kind, color)
    local function _12_()
      return (0 ~= #vim.diagnostic.get(0, {severity = kind}))
    end
    local function _13_()
      return spaces(#vim.diagnostic.get(0, {severity = kind}))
    end
    return {enabled = _12_, provider = _13_, left_sep = "", right_sep = "", hl = {fg = bar_bg, bg = color}}
  end
  local function coordinates()
    local _let_14_ = vim.api.nvim_win_get_cursor(0)
    local line = _let_14_[1]
    local col = _let_14_[2]
    return (" " .. line .. ":" .. col .. " ")
  end
  local function inactive_separator_provider()
    if (vim.fn.winnr() ~= vim.fn.winnr("j")) then
      return string.rep("\226\148\128", vim.api.nvim_win_get_width(0))
    else
      return ""
    end
  end
  local components = {active = {}, inactive = {}}
  local function _16_()
    return vim_mode_hl(false)
  end
  local function _17_()
    return vim_mode_hl(true)
  end
  components.active[1] = {{provider = vim_mode, hl = _16_}, {provider = get_current_filepath, left_sep = " ", hl = {fg = colors.light4}}, {provider = git_status_provider, left_sep = " ", hl = _17_}}
  local function _18_()
    return (0 < #vim.lsp.buf_get_clients())
  end
  components.active[2] = {{provider = lsp_progress_provider, left_sep = " ", right_sep = " ", enabled = _18_}}
  local function _19_()
    return vim_mode_hl(true)
  end
  local function _20_()
    return vim_mode_hl(false)
  end
  components.active[3] = {{provider = vim.bo.filetype, right_sep = " ", hl = _19_}, lsp_diagnostic_component(vim.diagnostic.severity.INFO, colors.neutral_green), lsp_diagnostic_component(vim.diagnostic.severity.HINT, colors.neutral_aqua), lsp_diagnostic_component(vim.diagnostic.severity.WARN, colors.neutral_yellow), lsp_diagnostic_component(vim.diagnostic.severity.ERROR, colors.neutral_red), {provider = coordinates, hl = _20_}}
  components.inactive[1] = {{provider = inactive_separator_provider, hl = {bg = "NONE", fg = horiz_separator_color}}}
  utils["highlight-add"]("StatusLineNC", {bg = "NONE", fg = colors.light1})
  return feline.setup({theme = {fg = colors.light1, bg = colors.bg_main}, components = components})
end
return {utils.plugin("Famiu/feline.nvim", {config = setup})}
