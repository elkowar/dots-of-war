local _0_0 = nil
do
  local name_0_ = "keybinds"
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
    return {require("aniseed.core"), require("aniseed.fennel"), require("aniseed.nvim"), require("utils"), require("which-key")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {["require-macros"] = {macros = true}, require = {a = "aniseed.core", fennel = "aniseed.fennel", nvim = "aniseed.nvim", utils = "utils", wk = "which-key"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local fennel = _local_0_[2]
local nvim = _local_0_[3]
local utils = _local_0_[4]
local wk = _local_0_[5]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "keybinds"
do local _ = ({nil, _0_0, {{nil}, nil, nil, nil}})[2] end
utils.keymap("i", "<C-Space>", "compe#complete()", {expr = true})
utils.keymap("i", "<esc>", "compe#close('<esc>')", {expr = true})
wk.setup({})
local function cmd(s, desc)
  return {("<cmd>" .. s .. "<cr>"), desc}
end
local function le(s, desc)
  return cmd(("call luaeval(\"" .. s .. "\")"), desc)
end
local function rebind(s, desc)
  return {s, desc}
end
wk.register({[":"] = cmd("Telescope commands", "Search command with fzf"), b = {b = cmd("Buffers", "select open buffer"), c = cmd("bdelete!", "close open buffer"), name = "+buffers", w = cmd("bwipeout!", "wipeout open buffer")}, c = {name = "+comment out"}, e = {name = "+emmet"}, f = {j = rebind("zj", "jump to next fold"), k = rebind("zk", "jump to previous fold"), n = cmd("foldclose", "close fold"), name = "+folds", o = cmd("foldopen", "open fold")}, h = cmd("bprevious", "previous buffer"), l = cmd("bnext", "next buffer"), m = {A = cmd("Lspsaga show_line_diagnostics", "Line diagnostics"), E = cmd("Telescope lsp_workspace_diagnostics", "List diagnostics"), S = cmd("Telescope lsp_document_symbols", "Symbols in document"), a = cmd("Lspsaga show_cursor_diagnostics", "Cursor diagnostics"), b = cmd("Lspsaga lsp_finder", "Find stuff"), d = cmd("Lspsaga hover_doc", "Show documentation"), e = cmd("LspTroubleOpen", "Show diagnostics"), f = le("vim.lsp.buf.formatting()", "format file"), g = le("vim.lsp.buf.definition()", "Go to definition"), i = le("vim.lsp.buf.implementation()", "Show implementation"), n = cmd("Lspsaga rename", "Rename"), name = "+Code actions", o = cmd("SymbolsOutline", "Outline"), r = cmd("Telescope lsp_references", "Show references"), s = cmd("Telescope lsp_dynamic_workspace_symbols", "Symbols in workspace"), t = cmd("Lspsaga signature_help", "Show signature help"), v = cmd("Lspsaga code_action", "Apply codeaction"), x = cmd("Lspsaga preview_definition", "Preview definition")}, o = cmd("Telescope live_grep", "Grep files"), p = cmd("Telescope file_browser", "Open file-browser"), v = {g = cmd("Goyo | set linebreak", "toggle focus mode"), i = cmd("IndentGuidesToggle", "toggle indent guides"), m = cmd("set nonumber! norelativenumber", "toggle numbers"), n = cmd("set relativenumber!", "toggle relative numbers"), name = "+view-and-layout"}}, {prefix = "<leader>"})
wk.register({["<tab>"] = "which_key_ignore", z = {c = cmd("foldclose", "close fold"), name = "+folds", o = cmd("foldopen", "open fold")}})
nvim.o.timeoutlen = 200
return nil