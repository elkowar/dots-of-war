(local utils (require :dots.utils))

 ;:github/copilot.vim {:cmd ["Copilot"]}
[(utils.plugin
   :zbirenbaum/copilot.lua
   {:cmd "Copilot"
    :event "InsertEnter"
    :opts {:panel {:enabled false}
           :suggestion {:enabled true
                        :auto_trigger :true
                        :keymap {:accept "<tab>"
                                 :next "<C-l><C-n>"}}}})]
