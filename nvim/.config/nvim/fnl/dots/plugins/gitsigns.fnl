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

(let [scrollbar-gitsigns (require "scrollbar.handlers.gitsigns")]
  (scrollbar-gitsigns.setup))

