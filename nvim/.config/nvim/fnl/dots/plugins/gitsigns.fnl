(import-macros m :macros)
(m.al utils dots.utils)
(m.al colors dots.colors)
(m.al gitsigns gitsigns)

(fn setup []
  (gitsigns.setup 
    {:signs {:add          {:text "▍"}
             :change       {:text "▍"}
             :delete       {:text "▍"}
             :topdelete    {:text "▍"}
             :changedelete {:text "▍"}}
;     :keymaps {:noremap true 
;               :buffer true}
     :current_line_blame false
     :update_debounce 100})

  (let [scrollbar-gitsigns (require "scrollbar.handlers.gitsigns")]
    (scrollbar-gitsigns.setup)))

[(utils.plugin
   :lewis6991/gitsigns.nvim
   {:dependencies [:vim-gruvbox8
                   :petertriho/nvim-scrollbar]
    :config setup})]
                                       

