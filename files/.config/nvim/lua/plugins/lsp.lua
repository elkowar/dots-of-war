local _0_0 = nil
do
  local name_0_ = "plugins.lsp"
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
    return {require("aniseed.core"), require("compe"), require("aniseed.fennel"), require("lspconfig"), require("lspconfig.configs"), require("lsp_signature"), require("aniseed.nvim"), require("lspsaga"), require("symbols-outline"), require("trouble"), require("utils")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {["require-macros"] = {macros = true}, require = {["lsp-configs"] = "lspconfig.configs", ["symbols-outline"] = "symbols-outline", a = "aniseed.core", compe = "compe", fennel = "aniseed.fennel", lsp = "lspconfig", lsp_signature = "lsp_signature", nvim = "aniseed.nvim", saga = "lspsaga", trouble = "trouble", utils = "utils"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local trouble = _local_0_[10]
local utils = _local_0_[11]
local compe = _local_0_[2]
local fennel = _local_0_[3]
local lsp = _local_0_[4]
local lsp_configs = _local_0_[5]
local lsp_signature = _local_0_[6]
local nvim = _local_0_[7]
local saga = _local_0_[8]
local symbols_outline = _local_0_[9]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "plugins.lsp"
do local _ = ({nil, _0_0, {{nil}, nil, nil, nil}})[2] end
local colors = utils.colors()
local function on_attach(client, bufnr)
  lsp_signature.on_attach()
  if client.resolved_capabilities.document_highlight then
    utils.highlight("LspReferenceRead", {gui = "underline"})
    utils.highlight("LspReferenceText", {gui = "underline"})
    utils.highlight("LspReferenceWrite", {gui = "underline"})
    return vim.api.nvim_exec("augroup lsp_document_highlight\n           autocmd! * <buffer> \n           autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight() \n           autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()\n         augroup END", false)
  end
end
local function better_root_pattern(patterns, except_patterns)
  local function _2_(path)
    if not lsp.util.root_pattern(except_patterns)(path) then
      return lsp.util.root_pattern(patterns)(path)
    end
  end
  return _2_
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {properties = {"documentation", "detail", "additionalTextEdits"}}
local function init_lsp(lsp_name, _3fopts)
  local merged_opts = a.merge({on_attach = on_attach}, (_3fopts or {}))
  return lsp[lsp_name].setup(merged_opts)
end
init_lsp("rust_analyzer", {capabilities = capabilities})
init_lsp("tsserver", {root_dir = lsp.util.root_pattern("package.json")})
local function _2_()
  return vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line("$"), 0})
end
init_lsp("jsonls", {commands = {Format = {_2_}}})
init_lsp("denols", {root_dir = better_root_pattern({".git"}, {"package.json"})})
init_lsp("hls", {settings = {languageServerHaskell = {formattingProvider = "stylish-haskell"}}})
init_lsp("vimls")
init_lsp("bashls")
init_lsp("erlangls")
init_lsp("yamlls")
init_lsp("html")
init_lsp("cssls")
symbols_outline.setup({highlight_hovered_item = true, show_guides = true})
compe.setup({autocomplete = false, debug = false, documentation = true, enabled = true, incomplete_delay = 400, max_abbr_width = 100, max_kind_width = 100, max_menu_width = 100, min_length = 1, preselect = "enable", source = {buffer = true, calc = true, nvim_lsp = true, nvim_lua = true, path = true, vsnip = false}, source_timeout = 200, throttle_time = 80})
saga.init_lsp_saga({border_style = 1, code_action_keys = {exec = "<CR>", quit = "<esc>"}, finder_action_keys = {open = "<CR>", quit = "<esc>", scroll_down = "<C-d>", scroll_up = "<C-u>", split = "b", vsplit = "v"}, rename_action_keys = {exec = "<CR>", quit = "<esc>"}})
utils.highlight("LspSagaCodeActionTitle", {fg = colors.bright_aqua})
utils.highlight("LspSagaBorderTitle", {fg = colors.bright_aqua})
utils.highlight("LspSagaCodeActionContent", {fg = colors.bright_aqua})
utils.highlight("LspSagaFinderSelection", {fg = colors.bright_aqua})
utils.highlight("LspSagaDiagnosticHeader", {fg = colors.bright_aqua})
utils.highlight("TargetWord", {fg = colors.bright_aqua})
utils.highlight("LspTroubleFoldIcon", {bg = "NONE", fg = colors.bright_orange})
utils.highlight("LspTroubleCount", {bg = "NONE", fg = colors.bright_green})
utils.highlight("LspTroubleText", {bg = "NONE", fg = colors.light0})
utils.highlight("LspTroubleSignError", {bg = "NONE", fg = colors.bright_red})
utils.highlight("LspTroubleSignWarning", {bg = "NONE", fg = colors.bright_yellow})
utils.highlight("LspTroubleSignInformation", {bg = "NONE", fg = colors.bright_aqua})
utils.highlight("LspTroubleSignHint", {bg = "NONE", fg = colors.bright_blue})
vim.o.signcolumn = "yes"
return trouble.setup({auto_close = true, auto_open = false, auto_preview = true, icons = false})