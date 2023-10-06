(import-macros {: al} :macros)
(al a nfnl.core)
(al utils dots.utils)
(al colors dots.colors)
(al bufferline bufferline)

(fn setup []
  ; :h bufferline-lua-highlights
  (let [selected {:guibg colors.neutral_aqua :guifg colors.bg_main :gui "NONE"}
        visible  {:guibg colors.dark1        :guifg colors.neutral_aqua}]
   (bufferline.setup 
     {:options
      {:diagnostics "nvim_lsp"
       :diagnostics_indicator (fn [cnt lvl diagnostics-dict] (.. " (" cnt ")"))
       :show_buffer_close_icons false
       :show_buffer_icons false
       :show_close_icon false
       :show_tab_indicators false
       :enforce_regular_tabs false
       :tab_size 10}

       ; https://github.com/akinsho/nvim-bufferline.lua/blob/4ebab39af2376b850724dd29c29579c8e024abe6/lua/bufferline/config.lua#L74
      :highlights 
      {:fill {:guibg colors.bg_main :guifg colors.light0}
       :background visible
       :buffer_visible visible
       :buffer_selected selected
       :modified  visible   :modified_selected  selected   :modified_visible  visible  
       :info      visible   :info_selected      selected   :info_visible      visible  
       :warning   visible   :warning_selected   selected   :warning_visible   visible
       :error     visible   :error_selected     selected   :error_visible     visible
       :duplicate visible   :duplicate_selected selected   :duplicate_visible visible

       :diagnostic                  {:guibg colors.dark1        :guifg colors.neutral_red}
       :diagnostic_visible          {:guibg colors.dark1        :guifg colors.neutral_red}
       :diagnostic_selected         {:guibg colors.neutral_aqua :guifg colors.faded_redu}

       :info_diagnostic             {:guibg colors.dark1        :guifg colors.neutral_blue}
       :info_diagnostic_visible     {:guibg colors.dark1        :guifg colors.neutral_blue}
       :info_diagnostic_selected    {:guibg colors.neutral_aqua :guifg colors.faded_blue}

       :warning_diagnostic          {:guibg colors.dark1        :guifg colors.neutral_yellow}
       :warning_diagnostic_visible  {:guibg colors.dark1        :guifg colors.neutral_yellow}
       :warning_diagnostic_selected {:guibg colors.neutral_aqua :guifg colors.faded_yellow}

       :error_diagnostic            {:guibg colors.dark1        :guifg colors.neutral_red}
       :error_diagnostic_visible    {:guibg colors.dark1        :guifg colors.neutral_red}
       :error_diagnostic_selected   {:guibg colors.neutral_aqua :guifg colors.red}

       :separator visible
       :indicator_selected {:guibg colors.neutral_aqua :guifg colors.neutral_aqua}

        ; stuff I've never seen before :thonk:
       :pick_selected {:guibg colors.bright_red :guifg colors.bright_red}
       :tab_selected {:guibg colors.bright_green :guifg colors.bright_green}
       :tab {:guibg colors.bright_yellow :guifg colors.bright_yellow}}})))

[(utils.plugin :akinsho/nvim-bufferline.lua
               {:config setup :tag "v1.1.1"})]
