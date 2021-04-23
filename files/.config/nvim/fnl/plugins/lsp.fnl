(module plugins.lsp
  {require {a aniseed.core
            fennel aniseed.fennel 
            nvim aniseed.nvim 
            lsp lspconfig 
            lsp-configs lspconfig.configs
            saga lspsaga 
            utils utils
            compe compe
            lsp_signature lsp_signature}
    require-macros [macros]})

(fn on_attach [client bufnr]
  (lsp_signature.on_attach)
  (if client.resolved_capabilities.document_highlight
    (do
      (utils.highlight "LspReferenceRead"  {:gui "underline"})
      (utils.highlight "LspReferenceText"  {:gui "underline"})
      (utils.highlight "LspReferenceWrite" {:gui "underline"})
      (vim.api.nvim_exec
         "augroup lsp_document_highlight
           autocmd! * <buffer> 
           autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight() 
           autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
         augroup END"
        false))))


(fn better_root_pattern [patterns except-patterns]
  "match path if one of the given patterns is matched, EXCEPT if one of the except-patterns is matched"
  (fn [path] 
    (when (not ((lsp.util.root_pattern except-patterns) path))
      ((lsp.util.root_pattern patterns) path))))


(local capabilities (vim.lsp.protocol.make_client_capabilities))
(set capabilities.textDocument.completion.completionItem.snippetSupport true)
(set capabilities.textDocument.completion.completionItem.resolveSupport
      { :properties ["documentation" "detail" "additionalTextEdits"]})

(fn init-lsp [lsp-name ?opts]
  "initialize a language server with defaults"
  (let [merged-opts (a.merge {:on_attach on_attach} (or ?opts {}))]
    ((. lsp lsp-name :setup) merged-opts)))
   

(init-lsp :rust_analyzer { :capabilities capabilities}) 
(init-lsp :tsserver      { :root_dir (lsp.util.root_pattern "package.json")})
(init-lsp :jsonls        { :commands { :Format [ #(vim.lsp.buf.range_formatting [] [0 0] [(vim.fn.line "$") 0])]}})
(init-lsp :denols        { :root_dir (better_root_pattern [".git"] ["package.json"])})
(init-lsp :hls           { :settings { :languageServerHaskell { :formattingProvider "stylish-haskell"}}})
(init-lsp :vimls)
(init-lsp :bashls)
(init-lsp :erlangls)
(init-lsp :yamlls)
(init-lsp :html)
(init-lsp :cssls)


;(lsp.vimls.setup { :on_attach on_attach})
  


(compe.setup 
  { :enabled true
    :autocomplete false
    :debug false 
    :min_length 1 
    :preselect "enable" 
    :throttle_time 80 
    :source_timeout 200 
    :incomplete_delay 400 
    :max_abbr_width 100 
    :max_kind_width 100 
    :max_menu_width 100 
    :documentation true 
    :source { :path true
              :buffer true 
              :calc true 
              :nvim_lsp true 
              :nvim_lua true 
              :vsnip false}})


(saga.init_lsp_saga 
  { :border_style 1
    :code_action_keys { :quit "<esc>" :exec "<CR>"} 
    :rename_action_keys { :quit "<esc>" :exec "<CR>"} 
    :finder_action_keys { :quit "<esc>"
                          :open "<CR>" 
                          :vsplit "v" 
                          :split "b" 
                          :scroll_up "<C-u>" 
                          :scroll_down "<C-d>"}})
 

(utils.highlight "LspSagaCodeActionTitle"    {:fg "#8ec07c"})
(utils.highlight "LspSagaBorderTitle"        {:fg "#8ec07c"})
(utils.highlight "LspSagaCodeActionContent"  {:fg "#8ec07c"})
(utils.highlight "LspSagaFinderSelection"    {:fg "#8ec07c"})
(utils.highlight "LspSagaDiagnosticHeader"   {:fg "#8ec07c"})
(utils.highlight "TargetWord"   {:fg "#8ec07c"})

(set nvim.o.signcolumn "yes")
