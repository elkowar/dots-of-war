(module plugins.lsp
  {require {a aniseed.core
            fennel aniseed.fennel 
            nvim aniseed.nvim 
            lsp lspconfig 
            saga lspsaga 
            utils utils
            compe compe}


    require-macros [macros]})


(fn on_attach [client bufnr]
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


(lsp.rust_analyzer.setup { :on_attach on_attach })
(lsp.jsonls.setup { :on_attach on_attach })
(lsp.vimls.setup { :on_attach on_attach })
(lsp.tsserver.setup { :on_attach on_attach })
(lsp.bashls.setup { :on_attach on_attach })
(lsp.html.setup { :on_attach on_attach})

(lsp.denols.setup { :on_attach on_attach
    :root_dir (lsp.util.root_pattern ".git") })
(lsp.hls.setup { :on_attach on_attach }
    :settings { :languageServerHaskell { :formattingProvider "stylish-haskell" }})

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

(set nvim.o.signcolumn "yes")
