(module dots.plugins.gitsigns
  {autoload {utils dots.utils
             colors dots.colors
             gitsigns gitsigns}})

; https://github.com/lewis6991/gitsigns.nvim
(gitsigns.setup 
  {:signs {:add          {:text "▍"}
           :change       {:text "▍"}
           :delete       {:text "▍"}
           :topdelete    {:text "▍"}
           :changedelete {:text "▍"}}
   :keymaps {:noremap true 
             :buffer true}
   :current_line_blame false
   :update_debounce 100})


(vim.cmd
  (..
    "
    augroup gitsignsHighlight
    autocmd ColorScheme * :hi! GitSignsAdd    gui='NONE' guibg='NONE' guifg='" colors.bright_aqua "'
    autocmd ColorScheme * :hi! GitSignsDelete gui='NONE' guibg='NONE' guifg='" colors.neutral_red "'
    autocmd ColorScheme * :hi! GitSignsChange gui='NONE' guibg='NONE' guifg='" colors.bright_blue "'
    augroup END
    "))
;(utils.highlight :GitSignsAdd    {:bg "NONE" :fg colors.bright_aqua})
;(utils.highlight :GitSignsDelete {:bg "NONE" :fg colors.neutral_red})
;(utils.highlight :GitSignsChange {:bg "NONE" :fg colors.bright_blue})

;(print "This is right before setting and then printing the highlight group")
;(vim.cmd "highlight GitSignsAdd guibg='NONE' guifg='#ff2200'")
;(vim.cmd "highlight GitSignsAdd")

; this no work, but https://github.com/lewis6991/gitsigns.nvim/blob/d89f88384567afc7a72b597e130008126fdb97f7/teal/gitsigns/highlight.tl#L19
; REEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
; (utils.highlight "GitSignsCurrentLineBlame" {:bg "NONE" :fg colors.dark0_soft})
