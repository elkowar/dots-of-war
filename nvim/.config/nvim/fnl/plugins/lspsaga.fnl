(module plugins.lspsaga
  {autoload {utils utils
             colors colors

             saga lspsaga}})


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
                 {:fg colors.bright_aqua})


(utils.highlight "LspFloatWinNormal" {:bg colors.dark0_hard})
(utils.highlight "LspFloatWinBorder" {:bg colors.dark0_hard 
                                      :fg colors.dark0_hard})
(utils.highlight "TargetWord" {:fg colors.bright_aqua})
