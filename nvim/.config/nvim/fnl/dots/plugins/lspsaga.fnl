(module dots.plugins.lspsaga
  {autoload {utils dots.utils
             colors dots.colors}

   require {saga lspsaga}
   require-macros [macros]})

(saga.init_lsp_saga 
  {:border_style "single" ; single double round plus
   :code_action_lightbulb {:enable true
                           :sign false
                           :virtual_text false}
   :code_action_keys {:quit "<esc>" :exec "<CR>"} 
   :rename_action_quit "<esc>"
   :finder_action_keys {:quit "<esc>"
                        :open "<CR>" 
                        :vsplit "v" 
                        :split "b" 
                        :scroll_up "<C-u>" 
                        :scroll_down "<C-d>"}})

(defer
  (do
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
                     {:fg colors.bright_aqua :bg colors.dark0_hard})


    (utils.highlight "LspFloatWinNormal" {:bg colors.dark0_hard})
    (utils.highlight "LspFloatWinBorder" {:bg colors.dark0_hard 
                                          :fg colors.dark0_hard})
    (utils.highlight "TargetWord" {:fg colors.bright_aqua})))
