(module dots.plugins.gruvbox8
  {autoload {utils dots.utils
             colors dots.colors}
   require-macros [macros]})

(set vim.g.gruvbox_italics 0)
(set vim.g.gruvbox_italicise_strings 0)
(set vim.g.gruvbox_filetype_hi_groups 1)
(set vim.g.gruvbox_plugin_hi_groups 1)

(if (= "epix" (vim.fn.hostname))
  (vim.cmd "colorscheme gruvbox8_hard")
  (vim.cmd "colorscheme gruvbox8"))

(defer
  (if (= "epix" (vim.fn.hostname))
    (utils.highlight :SignColumn {:bg colors.dark0_hard})
    (utils.highlight :SignColumn {:bg colors.dark0})))



;(utils.highlight :SignColumn {:bg (. (require :dots.colors) :dark0)}))}
;(utils.highlight :LspDiagnosticsUnderlineError {:gui "underline"}))}
