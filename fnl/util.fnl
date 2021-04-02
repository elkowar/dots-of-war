(module util
  {require {a aniseed.core
            nvim aniseed.nvim}
   require-macros [macros]})
  
(defn noremap [mode from to]
  "Sets a mapping with {:noremap true :silent true}."
  (nvim.set_keymap mode from to {:noremap true :silent true}))

(defn mapexpr [mode from to]
  "Sets a mapping with {:noremap true :silent true :expr true}."
  (nvim.set_keymap mode from to {:noremap true :silent true :expr true}))

