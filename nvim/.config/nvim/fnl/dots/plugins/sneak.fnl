(module dots.plugins.sneak
  {autoload {utils dots.utils}})


(set vim.g.sneak#label 1)
(utils.keymap [:n :o] :<DEL>   "<Plug>Sneak_s" {:noremap false})
(utils.keymap [:n :o] :<S-DEL> "<Plug>Sneak_S" {:noremap false})
