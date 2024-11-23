-- [nfnl] Compiled from fnl/dots/plugins/lsp.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("dots.prelude")
local autoload = _local_1_["autoload"]
local a = _local_1_["a"]
local utils = _local_1_["utils"]
local lsp = autoload("lspconfig")
local lsp_configs = autoload("lspconfig/configs")
local cmp_nvim_lsp = autoload("cmp_nvim_lsp")
local function setup()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {virtual_text = {prefix = "\226\151\134"}, severity_sort = true, signs = false, update_in_insert = false})
  local function on_attach(client, bufnr)
    if client.server_capabilities.documentHighlight then
      utils.highlight("LspReferenceRead", {gui = "underline"})
      utils.highlight("LspReferenceText", {gui = "underline"})
      utils.highlight("LspReferenceWrite", {gui = "underline"})
      return vim.api.nvim_exec("augroup lsp_document_highlight\n          autocmd! * <buffer> \n          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight() \n          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()\n          augroup END", false)
    else
      return nil
    end
  end
  local function better_root_pattern(patterns, except_patterns)
    local function _3_(path)
      if not lsp.util.root_pattern(except_patterns)(path) then
        return lsp.util.root_pattern(patterns)(path)
      else
        return nil
      end
    end
    return _3_
  end
  local default_capabilities
  do
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    default_capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  local function init_lsp(lsp_name, _3fopts)
    local merged_opts = a.merge({on_attach = on_attach, capabilities = default_capabilities}, (_3fopts or {}))
    return lsp[lsp_name].setup(merged_opts)
  end
  local function _5_()
    return vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line("$"), 0})
  end
  init_lsp("jsonls", {commands = {Format = {_5_}}})
  init_lsp("denols", {root_dir = better_root_pattern({".git"}, {"package.json"})})
  init_lsp("hls", {settings = {languageServerHaskell = {formattingProvider = "stylish-haskell"}}})
  init_lsp("ocamllsp")
  init_lsp("vimls")
  init_lsp("gopls")
  init_lsp("bashls")
  init_lsp("erlangls")
  init_lsp("yamlls")
  init_lsp("html")
  init_lsp("svelte")
  init_lsp("elmls")
  init_lsp("texlab")
  init_lsp("pyright")
  init_lsp("vls")
  init_lsp("perlls")
  init_lsp("powershell_es", {bundle_path = "/home/leon/powershell"})
  init_lsp("clangd")
  init_lsp("cssls", {filestypes = {"css", "scss", "less", "stylus"}, root_dir = lsp.util.root_pattern({"package.json", ".git"}), settings = {css = {validate = true}, less = {validate = true}, scss = {validate = true}}})
  local function _6_(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    return on_attach(client, bufnr)
  end
  lsp.tsserver.setup({root_dir = lsp.util.root_pattern("package.json"), on_attach = _6_})
  do
    local rustaceanvim = require("rustaceanvim")
    local rustaceanvim_config = require("rustaceanvim.config")
    local extension_path = "/home/leon/.vscode/extensions/vadimcn.vscode-lldb-1.6.8/"
    local codelldb_path = (extension_path .. "adapter/codelldb")
    local liblldb_path = (extension_path .. "lldb/lib/liblldb.so")
    local features = nil
    vim.g.rustaceanvim = {tools = {inlay_hints = {show_parameter_hints = false}, autoSetHints = false}, dap = {adapter = rustaceanvim_config.get_codelldb_adapter(codelldb_path, liblldb_path)}, server = {on_attach = on_attach, capabilities = default_capabilities, settings = {["rust-analyzer"] = {cargo = {loadOutDirsFromCheck = true, features = (features or "all"), noDefaultFeatures = (nil ~= features)}, procMacro = {enable = true}, diagnostics = {experimental = {enable = false}, enable = false}, checkOnSave = {overrideCommand = {"cargo", "clippy", "--workspace", "--message-format=json", "--all-targets", "--all-features"}}}}}}
  end
  if (true or not lsp.fennel_language_server) then
    lsp_configs["fennel_language_server"] = {default_config = {cmd = "/Users/leon/.cargo/bin/fennel-language-server", filetypes = {"fennel"}, single_file_support = true, root_dir = lsp.util.root_pattern({"fnl", "init.lua"}), settings = {fennel = {workspace = {library = vim.api.nvim_list_runtime_paths()}, diagnostics = {globals = {"vim"}}}}}}
  else
  end
  init_lsp("fennel_language_server", {root_dir = lsp.util.root_pattern({"fnl", "init.lua"}), settings = {fennel = {workspace = {library = vim.api.nvim_list_runtime_paths()}, diagnostics = {globals = {"vim", "comment"}}}}})
  --[[ (when (not lsp.prolog_lsp) (tset lsp-configs "prolog_lsp" {:default_config {:cmd ["swipl" "-g" "use_module(library(lsp_server))." "-g" "lsp_server:main" "-t" "halt" "--" "stdio"] :filetypes ["prolog"] :root_dir (fn [fname] (or (lsp.util.find_git_ancestor fname) (vim.loop.os_homedir))) :settings {}}})) (lsp.prolog_lsp.setup {}) ]]
  --[[ (let [ewwls-path "/home/leon/coding/projects/ls-eww/crates/ewwls/target/debug/ewwls"] (when (vim.fn.filereadable ewwls-path) (when (not lsp.ewwls) (set lsp-configs.ewwls {:default_config {:cmd [ewwls-path] :filetypes ["yuck"] :root_dir (fn [fname] (or (lsp.util.find_git_ancestor fname) (vim.loop.os_homedir))) :settings {}}})) (init-lsp "ewwls"))) ]]
  local autostart_semantic_highlighting = true
  local function refresh_semantic_highlighting()
    if autostart_semantic_highlighting then
      vim.lsp.buf_request(0, "textDocument/semanticTokens/full", {textDocument = vim.lsp.util.make_text_document_params()}, nil)
      return vim.NIL
    else
      return nil
    end
  end
  if not lsp.idris2_lsp then
    local function _9_(new_config, new_root_dir)
      new_config.cmd = {"idris2-lsp"}
      new_config.capabilities.workspace.semanticTokens = {refreshSupport = true}
      return nil
    end
    local function _10_(fname)
      local scandir = require("plenary.scandir")
      local function find_ipkg_ancestor(fname0)
        local function _11_(path)
          local res = scandir.scan_dir(path, {depth = 1, search_pattern = ".+%.ipkg"})
          if not vim.tbl_isempty(res) then
            return path
          else
            return nil
          end
        end
        return lsp.util.search_ancestors(fname0, _11_)
      end
      return ((find_ipkg_ancestor(fname) or lsp.util.find_git_ancestor(fname)) or vim.loop.os_homedir())
    end
    lsp_configs.idris2_lsp = {default_config = {cmd = {"idris2-lsp"}, filetypes = {"idris2"}, on_new_config = _9_, root_dir = _10_, settings = {}}}
  else
  end
  local function _14_(err, method, result, client_id, bufnr, config)
    local client = vim.lsp.get_client_by_id(client_id)
    local legend = client.server_capabilities.semanticTokensProvider.legend
    local token_types = legend.tokenTypes
    local data = result.data
    local ns = vim.api.nvim_create_namespace("nvim-lsp-semantic")
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, ( - 1))
    local tokens = {}
    local prev_line, prev_start = nil, 0
    for i = 1, #data, 5 do
      local delta_line = data[i]
      prev_line = ((prev_line and (prev_line + delta_line)) or delta_line)
      local delta_start = data[(i + 1)]
      prev_start = (((delta_line == 0) and (prev_start + delta_start)) or delta_start)
      local token_type = token_types[(data[(i + 3)] + 1)]
      vim.api.nvim_buf_add_highlight(bufnr, ns, ("LspSemantic_" .. token_type), prev_line, prev_start, (prev_start + data[(i + 2)]))
    end
    return nil
  end
  lsp.idris2_lsp.setup({on_attach = refresh_semantic_highlighting, autostart = true, handlers = {["workspace/semanticTokens/refresh"] = refresh_semantic_highlighting, ["textDocument/semanticTokens/full"] = _14_}})
  vim.cmd("highlight link LspSemantic_type Include")
  vim.cmd("highlight link LspSemantic_function Identifier")
  vim.cmd("highlight link LspSemantic_struct Number")
  vim.cmd("highlight LspSemantic_variable guifg=gray")
  vim.cmd("highlight link LspSemantic_keyword Structure")
  vim.opt.signcolumn = "yes"
  local function cleanup_markdown(contents)
    if (contents.kind == "markdown") then
      contents["value"] = string.gsub(contents.value, "%[([^%]]+)%]%(([^%)]+)%)", "[%1]")
    else
    end
    return contents
  end
  local previous_handler = vim.lsp.handlers["textDocument/hover"]
  local function _16_(a0, result, b, c)
    if not (result and result.contents) then
      return previous_handler(a0, result, b, c)
    else
      local new_contents = cleanup_markdown(result.contents)
      result["contents"] = new_contents
      return previous_handler(a0, result, b, c)
    end
  end
  vim.lsp.handlers["textDocument/hover"] = _16_
  return nil
end
local function _18_()
  return require("mason").setup()
end
return {utils.plugin("williamboman/mason.nvim", {config = _18_}), utils.plugin("williamboman/mason-lspconfig.nvim", {config = {ensure_installed = {"rust_analyzer"}}}), utils.plugin("neovim/nvim-lspconfig", {event = "VeryLazy", lazy = true, config = setup})}
