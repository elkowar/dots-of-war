(module plugins.lsp
  {require {a aniseed.core
            fennel aniseed.fennel 
            nvim aniseed.nvim 
            lsp lspconfig 
            lsp-configs lspconfig.configs
            utils utils
            colors colors}
    require-macros [macros]})



(pkg symbols-outline.nvim [symbols-outline (require "symbols-outline")]
  (symbols-outline.setup { :highlight_hovered_item true :show_guides true}))


; LSP config -------------------------------------------------------------------------------- <<<<<

(fn on_attach [client bufnr]
  (pkg lsp_signature.nvim [lsp_signature (require "lsp_signature")]
    (lsp_signature.on_attach))

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



(fn init-lsp [lsp-name ?opts]
  "initialize a language server with defaults"
  (let [merged-opts (a.merge {:on_attach on_attach} (or ?opts {}))]
    ((. lsp lsp-name :setup) merged-opts)))
   



(let [capabilities (vim.lsp.protocol.make_client_capabilities)]
  (set capabilities.textDocument.completion.completionItem.snippetSupport true)
  (set capabilities.textDocument.completion.completionItem.resolveSupport
        {:properties ["documentation" "detail" "additionalTextEdits"]})
  (lsp.rust_analyzer.setup 
    {:capabilities capabilities
     :on_attach (fn [...]
                  (on_attach ...)
                  (pkg rust-tools.nvim [rust-tools (require "rust-tools")]
                    (rust-tools.setup { :tools { :inlay_hints { :show_parameter_hints false}}})))}))

(init-lsp :tsserver      {:root_dir (lsp.util.root_pattern "package.json")})
(init-lsp :jsonls        {:commands {:Format [ #(vim.lsp.buf.range_formatting [] [0 0] [(vim.fn.line "$") 0])]}})
(init-lsp :denols        {:root_dir (better_root_pattern [".git"] ["package.json"])})
(init-lsp :hls           {:settings {:languageServerHaskell {:formattingProvider "stylish-haskell"}}})
(init-lsp :ocamllsp)
(init-lsp :vimls)
(init-lsp :bashls)
(init-lsp :erlangls)
(init-lsp :yamlls)
(init-lsp :html)
(init-lsp :cssls)


;(lsp.vimls.setup { :on_attach on_attach})
; >>>>>

; compe -------------------------------------------------------------------------------- <<<<<
(pkg nvim-compe [compe (require "compe")]
  (compe.setup 
   {:enabled true
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
    :source {:path true
              :buffer true 
              :calc true 
              :nvim_lsp true 
              :nvim_lua true 
              :vsnip false
              :conjure true}}))

; >>>>>

; LSP saga  -------------------------------------------------------------------------------- <<<<<
(pkg lspsaga.nvim [saga (require "lspsaga")]
  (saga.init_lsp_saga 
    {:border_style "single" ; single double round plus
     :code_action_prompt {:enable true
                          :sign true
                          :virtual_text false}
     :code_action_keys {:quit "<esc>" :exec "<CR>"} 
     :rename_action_keys {:quit "<esc>" :exec "<CR>"} 
     :finder_action_keys {:quit "<esc>"
                          :open "<CR>" 
                          :vsplit "v" 
                          :split "b" 
                          :scroll_up "<C-u>" 
                          :scroll_down "<C-d>"}})
   

  (utils.highlight ["LspFloatWinBorder"
                    "LspSagaHoverBorder"
                    "LspSagaRenameBorder"
                    "LspSagaSignatureHelpBorder"
                    "LspSagaCodeActionBorder"
                    "LspSagaDefPreviewBorder"
                    "LspSagaDiagnosticBorder"]
                   {:bg colors.dark0_hard :fg colors.dark0_hard})

  (utils.highlight ["LspSagaDiagnosticTruncateLine"
                    "LspSagaDocTruncateLine"
                    "LspSagaShTruncateLine"]
                   {:bg "NONE" :fg colors.dark0})

  (utils.highlight ["TargetWord"
                    "LspSagaCodeActionTitle"  
                    "LspSagaBorderTitle"      
                    "LspSagaCodeActionContent"
                    "LspSagaFinderSelection"  
                    "LspSagaDiagnosticHeader"] 
                   {:fg colors.bright_aqua}))


(utils.highlight "LspFloatWinNormal" {:bg colors.dark0_hard})
(utils.highlight "LspFloatWinBorder" {:bg colors.dark0_hard 
                                      :fg colors.dark0_hard})
(utils.highlight "TargetWord" {:fg colors.bright_aqua})
; >>>>>

; LSP trouble -------------------------------------------------------------------------------- <<<<<
(pkg lsp-trouble.nvim [trouble (require "trouble")]
  (trouble.setup
   {:icons false
    :auto_preview true
    :auto_close true
    :auto_open false
    :action_keys
      {:jump "o"
       :jump_close "<CR>"
       :close "<esc>"
       :cancel "q"
       :hover ["a" "K"]}})

  (utils.highlight "LspTroubleFoldIcon" {:bg "NONE" :fg colors.bright_orange})
  (utils.highlight "LspTroubleCount"    {:bg "NONE" :fg colors.bright_green})
  (utils.highlight "LspTroubleText"     {:bg "NONE" :fg colors.light0})

  (utils.highlight "LspTroubleSignError"       {:bg "NONE" :fg colors.bright_red})
  (utils.highlight "LspTroubleSignWarning"     {:bg "NONE" :fg colors.bright_yellow})
  (utils.highlight "LspTroubleSignInformation" {:bg "NONE" :fg colors.bright_aqua})
  (utils.highlight "LspTroubleSignHint"        {:bg "NONE" :fg colors.bright_blue}))

; >>>>>

; Empty template -------------------------------------------------------------------------------- <<<<<

; >>>>>

(set vim.o.signcolumn "yes")


 ; vim:foldmarker=<<<<<,>>>>>
