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
    return {require("aniseed.core"), require("aniseed.fennel"), require("aniseed.nvim"), require("utils")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {["require-macros"] = {macros = true}, require = {a = "aniseed.core", fennel = "aniseed.fennel", nvim = "aniseed.nvim", utils = "utils"}}
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
local _2amodule_2a = _0_0
local _2amodule_name_2a = "keybinds"
do local _ = ({nil, _0_0, {{nil}, nil, nil, nil}})[2] end
utils.keymap("n", "<leader>", ":<c-u>WhichKey '<Space>'<CR>")
utils.keymap("v", "<leader>", ":<c-u>WhichKeyVisual '<Space>'<CR>")
utils.keymap("i", "<C-Space>", "compe#complete()", {expr = true})
utils.keymap("i", "<esc>", "compe#close('<esc>')", {expr = true})
local function le(s)
  return (":call luaeval(\"" .. s .. "\")")
end
nvim.g.which_key_map = {}
nvim.command("call which_key#register('<Space>', \"g:which_key_map\")")
nvim.g.which_key_map = {[":"] = {":Commands", "Search command with fzf"}, ["["] = {"<Plug>(YoinkPostPasteSwapBack)", "Swap last paste backwards"}, ["]"] = {"<Plug>(YoinkPostPasteSwapForward)", "Swap last paste backwards"}, b = {b = {":Buffers", "select open buffer"}, c = {":bdelete!", "close open buffer"}, name = "+buffers", w = {":bwipeout!", "wipeout open buffer"}}, c = {name = "+comment_out"}, e = {name = "+emmet"}, f = {j = {"zj", "jump to next fold"}, k = {"zk", "jump to previous fold"}, n = {":foldclose", "close fold"}, name = "+folds", o = {":foldopen", "open fold"}}, h = {":bprevious", "previous buffer"}, l = {":bnext", "next buffer"}, m = {A = {":Lspsaga show_line_diagnostics", "Line diagnostics"}, E = {":Telescope lsp_workspace_diagnostics", "List diagnostics"}, S = {":Telescope lsp_document_symbols", "symbols in document"}, a = {":Lspsaga show_cursor_diagnostics", "Cursor diagnostics"}, b = {":Lspsaga lsp_finder", "find stuff"}, d = {":Lspsaga hover_doc", "show documentation"}, e = {le("vim.lsp.diagnostic.goto_next()"), "Jump to the next error"}, f = {le("vim.lsp.buf.formatting()"), "format file"}, g = {le("vim.lsp.buf.definition()"), "go to definition"}, i = {le("vim.lsp.buf.implementation()"), "show implementation"}, n = {":Lspsaga rename", "rename"}, name = "+Code-actions", o = {":SymbolsOutline", "Outline"}, r = {":Telescope lsp_references", "show references"}, s = {":Telescope lsp_dynamic_workspace_symbols", "symbols in workspace"}, t = {":Lspsaga signature_help", "Show signature help"}, v = {":Lspsaga code_action", "apply codeaction"}, x = {":Lspsaga preview_definition", "Preview definition"}}, o = {":Telescope live_grep", "Grep files"}, p = {":Telescope file_browser", "Open file-browser"}, s = "which_key_ignore", v = {g = {":Goyo | set linebreak", "toggle focus mode"}, i = {":IndentGuidesToggle", "toggle indent guides"}, m = {":set nonumber! norelativenumber", "toggle numbers"}, n = {":set relativenumber!", "toggle relative numbers"}, name = "+view-and-layout"}, z = {c = {"foldclose", "close fold"}, name = "+folds", o = {"foldopen", "open fold"}}}
nvim.o.timeoutlen = 200
return nvim.command("autocmd! VimEnter * :unmap <space>ig\n   autocmd! FileType which_key")