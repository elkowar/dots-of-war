(module plugins.gitsigns
  {autoload {utils utils
             colors colors
             gitsigns gitsigns}})

; https://github.com/lewis6991/gitsigns.nvim
(gitsigns.setup
  {:signs {:add {:text "▍"}
           :change {:text "▍"}
           :delete {:text "▍"}
           :topdelete {:text "▍"}
           :changedelete {:text "▍"}}
   :keymaps {:noremap true 
             :buffer true}
   :current_line_blame false
   :update_debounce 100})

(utils.highlight "GitSignsAdd"    {:bg "NONE" :fg colors.bright_aqua})
(utils.highlight "GitSignsDelete" {:bg "NONE" :fg colors.neutral_red})
(utils.highlight "GitSignsChange" {:bg "NONE" :fg colors.bright_blue})

; this no work, but https://github.com/lewis6991/gitsigns.nvim/blob/d89f88384567afc7a72b597e130008126fdb97f7/teal/gitsigns/highlight.tl#L19
; REEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
; (utils.highlight "GitSignsCurrentLineBlame" {:bg "NONE" :fg colors.dark0_soft})
