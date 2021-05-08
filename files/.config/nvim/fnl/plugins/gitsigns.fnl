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
   :current_line_blame true
   :update_debounce 100})

(utils.highlight "GitSignsAdd"    {:bg "NONE" :fg colors.bright_aqua})
(utils.highlight "GitSignsDelete" {:bg "NONE" :fg colors.neutral_red})
(utils.highlight "GitSignsChange" {:bg "NONE" :fg colors.bright_blue})
