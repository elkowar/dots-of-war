(module dots.plugins.copilot
  {autoload {copilot copilot}
   require-macros [macros]})

(copilot.setup 
  {:panel {:enabled false}
   :suggestion {:enabled true
                :auto_trigger :true
                :keymap {:accept "<tab>"
                         :next "<C-l><C-n>"}}})
 
