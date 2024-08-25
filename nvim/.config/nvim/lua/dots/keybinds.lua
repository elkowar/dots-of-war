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
local function cmd(s, desc)
  return {("<cmd>" .. s .. "<cr>"), desc}
end
local function sel_cmd(s, desc)
  return {("<cmd>'<,'>" .. s .. "<cr>"), desc}
end
local function rebind(s, desc)
  return {s, desc}
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
local function key(bind, desc)
  return {bind, desc = desc}
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
wk.add(key_map({["<leader>c"] = {name = "+comment out"}, ["<leader>e"] = {name = "+emmet"}, ["<leader>["] = cmd("HopWord", "Hop to a word"), ["<leader>h"] = cmd("bprevious", "previous buffer"), ["<leader>l"] = cmd("bnext", "next buffer"), ["<leader>o"] = cmd("Telescope live_grep", "Grep files"), ["<leader>P"] = cmd("Telescope frecency frecency default_text=:CWD:", "Frecency magic"), ["<leader>p"] = cmd("Telescope find_files", "Open file-browser"), ["<leader>:"] = cmd("Telescope commands", "Search command with fzf"), ["<leader>s"] = cmd("w", "Save file"), ["<leader>g"] = cmd("Neogit", "Git"), ["<leader>n"] = {require("persistence").load, "Load last session"}}))
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
wk.register({c = {name = "+comment out"}, e = {name = "+emmet"}, ["["] = cmd("HopWord", "Hop to a word"), h = cmd("bprevious", "previous buffer"), l = cmd("bnext", "next buffer"), o = cmd("Telescope live_grep", "Grep files"), P = cmd("Telescope frecency frecency default_text=:CWD:", "Frecency magic"), p = cmd("Telescope find_files", "Open file-browser"), [":"] = cmd("Telescope commands", "Search command with fzf"), s = cmd("w", "Save file"), g = cmd("Neogit", "Git"), n = {require("persistence").load, "Load last session"}, d = {name = "+Debugging", b = {dap.toggle_breakpoint, "toggle breakpoint"}, u = {dapui.toggle, "toggle dapui"}, c = {dap.step_into, "continue"}, r = {dap.repl.open, "open repl"}, s = {name = "+Step", o = {dap.step_over, "over"}, u = {dap.step_out, "out"}, i = {dap.step_into, "into"}}}, m = {name = "+Code actions", [";"] = {_5_, "Toggle spell checking"}, d = {vim.lsp.buf.hover, "Show documentation"}, o = cmd("SymbolsOutline", "Outline"), S = cmd("Telescope lsp_document_symbols", "Symbols in document"), s = cmd("Telescope lsp_dynamic_workspace_symbols", "Symbols in workspace"), T = {vim.lsp.buf.signature_help, "Show signature help"}, n = {open_rename, "Rename"}, v = cmd("CodeActionMenu", "Apply codeaction"), A = {_6_, "Cursor diagnostics"}, a = {_7_, "Line diagnostics"}, h = cmd("RustToggleInlayHints", "Toggle inlay hints"), r = cmd("Trouble lsp_references", "Show references"), E = cmd("Trouble document_diagnostics", "List diagnostics"), e = cmd("Trouble workspace_diagnostics", "Show diagnostics"), t = cmd("Trouble lsp_type_definitions", "Go to type-definition"), i = cmd("Trouble lsp_implementations", "Show implementation"), g = cmd("Trouble lsp_definitions", "Go to definition"), w = {toggle_lsp_lines, "Toggle LSP lines"}, W = {toggle_lsp_lines_current, "Toggle LSP line"}, f = {format, "format file"}, [","] = cmd("RustRunnables", "Run rust stuff"), x = {name = "+Glance", d = {_8_, "Definitions"}, r = {_9_, "References"}, t = {_10_, "Type definitions"}, i = {_11_, "Implementations"}}, c = {name = "+Crates", j = {crates.show_popup, "crates popup"}, f = {crates.show_features_popup, "crate features"}, v = {crates.show_versions_popup, "crate versions"}, d = {crates.show_dependencies_popup, "crate dependencies"}, h = {crates.open_documentation, "crate documentation"}}}, f = {name = "+folds", o = cmd("foldopen", "open fold"), n = cmd("foldclose", "close fold"), j = rebind("zj", "jump to next fold"), k = rebind("zk", "jump to previous fold")}, v = {name = "+view-and-layout", n = cmd("set relativenumber!", "toggle relative numbers"), m = cmd("set nonumber! norelativenumber", "toggle numbers"), g = cmd("ZenMode", "toggle zen mode"), i = cmd("IndentGuidesToggle", "toggle indent guides"), w = cmd("set wrap! linebreak!", "toggle linewrapping")}, b = {name = "+buffers", b = cmd(":Telescope buffers", "select open buffer"), c = cmd(":Bdelete!", "close open buffer"), w = cmd(":Bwipeout!", "wipeout open buffer")}}, {prefix = "<leader>"})
wk.add(key_map({["<tab>"] = {hidden = true}, gss = {desc = "init selection"}, z = {group = "folds"}, zc = key("<cmd>foldclose<cr>", "close fold"), zo = key("<cmd>foldopen<cr>", "open fold")}))
wk.add(key_map({["<tab>"] = {hidden = true, mode = "i"}}))
wk.add(utils.prepend(key_map({["<leader>s"] = sel_cmd("VSSplit", "keep selection visible in split"), ["<leader>z"] = {open_selection_zotero, "open in zotero"}, gs = {group = "+Selection"}, gsj = {desc = "increment selection"}, gsk = {desc = "decrement selection"}, gsl = {desc = "increment node"}, gsh = {desc = "decrement node"}}), {mode = "v"}))
vim.o.timeoutlen = 200
return nil
