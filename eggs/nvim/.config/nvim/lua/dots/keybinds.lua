-- [nfnl] Compiled from fnl/dots/keybinds.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("dots.prelude")
local autoload = _local_1_["autoload"]
local a = _local_1_["a"]
local str = _local_1_["str"]
local utils = _local_1_["utils"]
local wk = autoload("which-key")
local glance = autoload("glance")
local crates = autoload("crates")
local dap = autoload("dap")
local dapui = autoload("dapui")
vim.g.AutoPairsShortcutBackInsert = "<M-b>"
utils.keymap("n", "K", "<Nop>")
utils.keymap("v", "K", "<Nop>")
utils.keymap("i", "\8", "<C-w>")
utils.keymap("i", "<C-h>", "<C-w>")
utils.keymap("i", "<C-BS>", "<C-w>")
utils.keymap("n", "zt", "zt<c-y><c-y><c-y>")
utils.keymap("n", "zb", "zb<c-e><c-e><c-e>")
utils.keymap("n", "<space>c<space>", "<cmd>call nerdcommenter#Comment(\"m\", \"Toggle\")<CR>", {})
utils.keymap("v", "<space>c<space>", "<cmd>call nerdcommenter#Comment(\"x\", \"Toggle\")<CR>", {})
utils.keymap("n", "<C-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>")
utils.keymap("n", "<A-LeftMouse>", "<Esc><LeftMouse><cmd>lua vim.lsp.buf.hover()<CR>")
utils.keymap({"n", "v"}, "<space><space>c", "\"+y")
utils.keymap("n", "<a-s-j>", "<cmd>RustMoveItemDown<cr>j")
utils.keymap("n", "<a-s-k>", "<cmd>RustMoveItemUp<cr>k")
utils.keymap("n", "<Backspace>", "<cmd>HopChar2<CR>")
local function open_selection_zotero()
  local _, _0, sel = utils["get-selection"]()
  return vim.cmd(("silent !xdg-open zotero://select/items/@" .. str.join(sel)))
end
local function key_map(obj)
  local tbl_21_auto = {}
  local i_22_auto = 0
  for key, val in pairs(obj) do
    local val_23_auto = utils.prepend(key, val)
    if (nil ~= val_23_auto) then
      i_22_auto = (i_22_auto + 1)
      tbl_21_auto[i_22_auto] = val_23_auto
    else
    end
  end
  return tbl_21_auto
end
local function m(bind, desc)
  return {bind, desc = desc}
end
local function cmd(s, desc)
  return utils.prepend(("<cmd>" .. s .. "<cr>"), {desc = desc})
end
local function sel_cmd(s, desc)
  return utils.prepend(("<cmd>'<,'>" .. s .. "<cr>"), {desc = desc})
end
local function rebind(s, desc)
  return m(s, desc)
end
local function format()
  local function _3_(_241)
    return _241.server_capabilities.documentFormattingProvider
  end
  if a.some(_3_, vim.lsp.get_active_clients()) then
    return vim.lsp.buf.format({async = true})
  else
    return vim.cmd("Neoformat")
  end
end
local function open_rename()
  return vim.api.nvim_feedkeys((":IncRename " .. vim.fn.expand("<cword>")), "n", "")
end
local function toggle_lsp_lines()
  vim.diagnostic.config({virtual_lines = not vim.diagnostic.config().virtual_lines})
  return vim.diagnostic.config({virtual_text = not vim.diagnostic.config().virtual_lines})
end
local function toggle_lsp_lines_current()
  return vim.diagnostic.config({virtual_lines = {only_current_line = true}})
end
wk.setup({})
local function _5_()
  vim.o.spell = not vim.o.spell
  return nil
end
local function _6_()
  return vim.diagnostic.open_float({scope = "cursor"})
end
local function _7_()
  return vim.diagnostic.open_float({})
end
local function _8_()
  return glance.open("definitions")
end
local function _9_()
  return glance.open("references")
end
local function _10_()
  return glance.open("type_definitions")
end
local function _11_()
  return glance.open("implementations")
end
wk.add(key_map({["<leader>c"] = {group = "+Crates"}, ["<leader>e"] = {group = "+emmet"}, ["<leader>["] = cmd("HopWord", "Hop to a word"), ["<leader>h"] = cmd("bprevious", "previous buffer"), ["<leader>l"] = cmd("bnext", "next buffer"), ["<leader>o"] = cmd("Telescope live_grep", "Grep files"), ["<leader>P"] = cmd("Telescope frecency frecency default_text=:CWD:", "Frecency magic"), ["<leader>p"] = cmd("Telescope find_files", "Open file-browser"), ["<leader>:"] = cmd("Telescope commands", "Search command with fzf"), ["<leader>s"] = cmd("w", "Save file"), ["<leader>g"] = cmd("Neogit", "Git"), ["<leader>n"] = m(require("persistence").load, "Load last session"), ["<leader>d"] = {group = "+Debugging"}, ["<leader>db"] = m(dap.toggle_breakpoint, "toggle breakpoint"), ["<leader>du"] = m(dapui.toggle, "toggle dapui"), ["<leader>dc"] = m(dap.step_into, "continue"), ["<leader>dr"] = m(dap.repl.open, "open repl"), ["<leader>ds"] = {group = "+Step"}, ["<leader>dso"] = m(dap.step_over, "over"), ["<leader>dsu"] = m(dap.step_out, "out"), ["<leader>dsi"] = m(dap.step_into, "into"), ["<leader>m"] = {group = "+Code actions"}, ["<leader>m;"] = m(_5_, "Toggle spell checking"), ["<leader>md"] = m(vim.lsp.buf.hover, "Show documentation"), ["<leader>mo"] = cmd("SymbolsOutline", "Outline"), ["<leader>mS"] = cmd("Telescope lsp_document_symbols", "Symbols in document"), ["<leader>ms"] = cmd("Telescope lsp_dynamic_workspace_symbols", "Symbols in workspace"), ["<leader>mT"] = m(vim.lsp.buf.signature_help, "Show signature help"), ["<leader>mn"] = m(open_rename, "Rename"), ["<leader>mv"] = cmd("CodeActionMenu", "Apply codeaction"), ["<leader>mA"] = m(_6_, "Cursor diagnostics"), ["<leader>ma"] = m(_7_, "Line diagnostics"), ["<leader>mh"] = cmd("RustToggleInlayHints", "Toggle inlay hints"), ["<leader>mr"] = cmd("Trouble lsp_references", "Show references"), ["<leader>mE"] = cmd("Trouble document_diagnostics", "List diagnostics"), ["<leader>me"] = cmd("Trouble workspace_diagnostics", "Show diagnostics"), ["<leader>mt"] = cmd("Trouble lsp_type_definitions", "Go to type-definition"), ["<leader>mi"] = cmd("Trouble lsp_implementations", "Show implementation"), ["<leader>mg"] = cmd("Trouble lsp_definitions", "Go to definition"), ["<leader>mw"] = m(toggle_lsp_lines, "Toggle LSP lines"), ["<leader>mW"] = m(toggle_lsp_lines_current, "Toggle LSP line"), ["<leader>mf"] = m(format, "format file"), ["<leader>m,"] = cmd("RustRunnables", "Run rust stuff"), ["<leader>mx"] = {group = "+Glance"}, ["<leader>mxd"] = m(_8_, "Definitions"), ["<leader>mxr"] = m(_9_, "References"), ["<leader>mxt"] = m(_10_, "Type definitions"), ["<leader>mxi"] = m(_11_, "Implementations"), ["<leader>mcj"] = m(crates.show_popup, "crates popup"), ["<leader>mcf"] = m(crates.show_features_popup, "crate features"), ["<leader>mcv"] = m(crates.show_versions_popup, "crate versions"), ["<leader>mcd"] = m(crates.show_dependencies_popup, "crate dependencies"), ["<leader>mch"] = m(crates.open_documentation, "crate documentation"), ["<leader>f"] = {group = "+folds"}, ["<leader>fo"] = cmd("foldopen", "open fold"), ["<leader>fn"] = cmd("foldclose", "close fold"), ["<leader>fj"] = rebind("zj", "jump to next fold"), ["<leader>fk"] = rebind("zk", "jump to previous fold"), ["<leader>v"] = {group = "+view-and-layout"}, ["<leader>vn"] = cmd("set relativenumber!", "toggle relative numbers"), ["<leader>vm"] = cmd("set nonumber! norelativenumber", "toggle numbers"), ["<leader>vg"] = cmd("ZenMode", "toggle zen mode"), ["<leader>vi"] = cmd("IndentGuidesToggle", "toggle indent guides"), ["<leader>vw"] = cmd("set wrap! linebreak!", "toggle linewrapping"), ["<leader>b"] = {group = "+buffers"}, ["<leader>bb"] = cmd(":Telescope buffers", "select open buffer"), ["<leader>bc"] = cmd(":Bdelete!", "close open buffer"), ["<leader>bw"] = cmd(":Bwipeout!", "wipeout open buffer")}))
wk.add(key_map({["<tab>"] = {hidden = true}, gss = {desc = "init selection"}, z = {group = "folds"}, zc = m("<cmd>foldclose<cr>", "close fold"), zo = m("<cmd>foldopen<cr>", "open fold")}))
wk.add(key_map({["<tab>"] = {hidden = true, mode = "i"}}))
wk.add(utils.prepend(key_map({["<leader>s"] = sel_cmd("VSSplit", "keep selection visible in split"), ["<leader>z"] = m(open_selection_zotero, "open in zotero"), gs = {group = "+Selection"}, gsj = {desc = "increment selection"}, gsk = {desc = "decrement selection"}, gsl = {desc = "increment node"}, gsh = {desc = "decrement node"}}), {mode = "v"}))
vim.o.timeoutlen = 200
return nil
