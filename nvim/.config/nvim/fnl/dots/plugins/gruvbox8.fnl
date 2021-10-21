(module dots.plugins.gruvbox8
  {autoload {utils dots.utils
             colors dots.colors}})

(set vim.g.gruvbox_italics 0)
(set vim.g.gruvbox_italicise_strings 0)
(set vim.g.gruvbox_filetype_hi_groups 1)
(set vim.g.gruvbox_plugin_hi_groups 1)

(vim.cmd "colorscheme gruvbox8")

(utils.highlight :SignColumn {:bg colors.dark0})

;(utils.highlight :SignColumn {:bg (. (require :dots.colors) :dark0)}))}
;(utils.highlight :LspDiagnosticsUnderlineError {:gui "underline"}))}
