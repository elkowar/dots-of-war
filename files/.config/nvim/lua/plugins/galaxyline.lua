local _0_0 = nil
do
  local name_0_ = "plugins.galaxyline"
  local module_0_ = nil
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  module_0_["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _1_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _1_()
    return {require("aniseed.core"), require("aniseed.fennel"), require("galaxyline"), require("galaxyline.condition"), require("galaxyline.provider_diagnostic"), require("galaxyline.provider_fileinfo"), require("galaxyline.provider_vcs"), require("aniseed.nvim"), require("utils")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {["require-macros"] = {macros = true}, require = {["gl-condition"] = "galaxyline.condition", ["gl-diagnostic"] = "galaxyline.provider_diagnostic", ["gl-fileinfo"] = "galaxyline.provider_fileinfo", ["gl-vcs"] = "galaxyline.provider_vcs", a = "aniseed.core", fennel = "aniseed.fennel", galaxyline = "galaxyline", nvim = "aniseed.nvim", utils = "utils"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local fennel = _local_0_[2]
local galaxyline = _local_0_[3]
local gl_condition = _local_0_[4]
local gl_diagnostic = _local_0_[5]
local gl_fileinfo = _local_0_[6]
local gl_vcs = _local_0_[7]
local nvim = _local_0_[8]
local utils = _local_0_[9]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "plugins.galaxyline"
do local _ = ({nil, _0_0, {{nil}, nil, nil, nil}})[2] end
local colors = utils.colors()
local modes = {R = {colors = {bg = colors.neutral_aqua, fg = colors.dark0}, text = "REPLACE"}, Rv = {colors = {bg = colors.neutral_aqua, fg = colors.dark0}, text = "VIRTUAL"}, S = {colors = {bg = colors.neutral_aqua, fg = colors.dark0}, text = "SELECT"}, V = {colors = {bg = colors.neutral_blue, fg = colors.dark0}, text = "VISUAL LINE"}, ["\22"] = {colors = {bg = colors.neutral_blue, fg = colors.dark0}, text = "VISUAL BLOCK"}, ["r?"] = {colors = {bg = colors.neutral_aqua, fg = colors.dark0}, text = "CONFIRM"}, c = {colors = {bg = colors.neutral_aqua, fg = colors.dark0}, text = "CMD"}, ce = {colors = {bg = colors.neutral_aqua, fg = colors.dark0}, text = "NORMEX"}, cv = {colors = {bg = colors.neutral_aqua, fg = colors.dark0}, text = "EX"}, i = {colors = {bg = colors.neutral_yellow, fg = colors.dark0}, text = "INSERT"}, ic = {colors = {bg = colors.neutral_aqua, fg = colors.dark0}, text = "INSCOMP"}, n = {colors = {bg = colors.neutral_aqua, fg = colors.dark0}, text = "NORMAL"}, no = {colors = {bg = colors.neutral_aqua, fg = colors.dark0}, text = "OP-PENDING"}, r = {colors = {bg = colors.neutral_aqua, fg = colors.dark0}, text = "HIT-ENTER"}, s = {colors = {bg = colors.neutral_aqua, fg = colors.dark0}, text = "SELECT"}, t = {colors = {bg = colors.neutral_aqua, fg = colors.dark0}, text = "TERM"}, v = {colors = {bg = colors.neutral_blue, fg = colors.dark0}, text = "VISUAL"}}
local function buf_empty_3f()
  return (1 == nvim.fn.empty(nvim.fn.expand("%:t")))
end
local function get_current_file_name()
  local file = nvim.fn.expand("%:t")
  if (1 == nvim.fn.empty(file)) then
    return ""
  elseif nvim.bo.readonly then
    return ("RO " .. file)
  elseif (nvim.bo.modifiable and nvim.bo.modified) then
    return (file .. " \239\129\128")
  else
    return file
  end
end
local function get_mode_data()
  return (modes[nvim.fn.mode()] or {colors = {bg = colors.neutral_orange, fg = colors.dark0}, text = nvim.fn.mode()})
end
local function vim_mode_provider()
  local modedata = get_mode_data()
  utils.highlight("GalaxyViMode", modedata.colors)
  return ("  " .. modedata.text .. " ")
end
utils.highlight("StatusLine", {bg = colors.dark1, fg = colors.light0})
galaxyline.short_line_list = {"dbui", "diff", "peekaboo", "undotree", "vista", "vista_markdown"}
local function _2_()
  return ""
end
galaxyline.section.left = {{ViMode = {provider = vim_mode_provider}}, {FileName = {highlight = {colors.light4, colors.dark1}, provider = get_current_file_name}}, {Space = {highlight = {colors.light0, colors.dark1}, provider = _2_}}}
local function make_lsp_diagnostic_provider(kind)
  local function _3_()
    local n = vim.lsp.diagnostic.get_count(0, kind)
    if (n == 0) then
      return ""
    else
      return (" " .. n .. " ")
    end
  end
  return _3_
end
local function git_branch_provider()
  local branch = gl_vcs.get_git_branch()
  if ("master" == branch) then
    return ""
  else
    return branch
  end
end
local function _3_()
  return nvim.bo.filetype
end
local function _4_()
  return (" " .. gl_fileinfo.line_column() .. " ")
end
galaxyline.section.right = {{GitBranch = {highlight = {colors.light4, colors.dark1}, provider = git_branch_provider}}, {FileType = {highlight = {colors.neutral_aqua, colors.dark1}, provider = _3_}}, {DiagnosticInfo = {highlight = {colors.dark1, colors.neutral_blue}, provider = make_lsp_diagnostic_provider("Info")}}, {DiagnosticWarn = {highlight = {colors.dark1, colors.neutral_yellow}, provider = make_lsp_diagnostic_provider("Warning"), separator = ""}}, {DiagnosticError = {highlight = {colors.dark1, colors.bright_red}, provider = make_lsp_diagnostic_provider("Error"), separator = ""}}, {LineInfo = {highlight = "GalaxyViMode", provider = _4_, separator = ""}}}
local function add_segment_defaults(data)
  return a.merge({highlight = {colors.light0, colors.dark1}, separator = " ", separator_highlight = "StatusLine"}, data)
end
local function map_gl_section(f, section)
  local tbl_0_ = {}
  for _, elem in ipairs(section) do
    local _5_
    do
      local tbl_0_0 = {}
      for k, v in pairs(elem) do
        local _6_0, _7_0 = k, f(v)
        if ((nil ~= _6_0) and (nil ~= _7_0)) then
          local k_0_ = _6_0
          local v_0_ = _7_0
          tbl_0_0[k_0_] = v_0_
        end
      end
      _5_ = tbl_0_0
    end
    tbl_0_[(#tbl_0_ + 1)] = _5_
  end
  return tbl_0_
end
galaxyline.section.left = map_gl_section(add_segment_defaults, galaxyline.section.left)
galaxyline.section.right = map_gl_section(add_segment_defaults, galaxyline.section.right)
return nil