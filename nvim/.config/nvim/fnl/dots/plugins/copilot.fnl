(import-macros {: al} :macros)
(al copilot copilot) 
(al utils dots.utils)

(fn setup []
  (copilot.setup 
    {:panel {:enabled false}
     :suggestion {:enabled true
                  :auto_trigger :true
                  :keymap {:accept "<tab>"
                           :next "<C-l><C-n>"}}}))

 ;:github/copilot.vim {:cmd ["Copilot"]}
;[(utils.plugin :zbirenbaum/copilot.lua
;               {:cmd "Copilot"
;                :event "InsertEnter"
;                :config setup}}))
[]
