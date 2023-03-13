(module dots.plugins.bufferline
  {autoload {a aniseed.core
             nvim aniseed.nvim 
             utils dots.utils
             colors dots.colors
             bufferline bufferline}
   require-macros [macros]})

; :h bufferline-lua-highlights
(let [selected {:bg colors.neutral_aqua :fg colors.dark0}
      visible  {:bg colors.dark1        :fg colors.neutral_aqua}]
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
    {:fill {:bg colors.dark0 :fg colors.light0}
     :background visible
     :buffer_visible visible
     :buffer_selected selected
     :modified  visible   :modified_selected  selected   :modified_visible  visible  
     :info      visible   :info_selected      selected   :info_visible      visible  
     :warning   visible   :warning_selected   selected   :warning_visible   visible
     :error     visible   :error_selected     selected   :error_visible     visible
     :duplicate visible   :duplicate_selected selected   :duplicate_visible visible

     :diagnostic                  {:bg colors.dark1        :fg colors.neutral_red}
     :diagnostic_visible          {:bg colors.dark1        :fg colors.neutral_red}
     :diagnostic_selected         {:bg colors.neutral_aqua :fg colors.faded_red}

     :info_diagnostic             {:bg colors.dark1        :fg colors.neutral_blue}
     :info_diagnostic_visible     {:bg colors.dark1        :fg colors.neutral_blue}
     :info_diagnostic_selected    {:bg colors.neutral_aqua :fg colors.faded_blue}

     :warning_diagnostic          {:bg colors.dark1        :fg colors.neutral_yellow}
     :warning_diagnostic_visible  {:bg colors.dark1        :fg colors.neutral_yellow}
     :warning_diagnostic_selected {:bg colors.neutral_aqua :fg colors.faded_yellow}

     :error_diagnostic            {:bg colors.dark1        :fg colors.neutral_red}
     :error_diagnostic_visible    {:bg colors.dark1        :fg colors.neutral_red}
     :error_diagnostic_selected   {:bg colors.neutral_aqua :fg colors.red}

     :separator visible
     :indicator_selected {:bg colors.neutral_aqua :fg colors.neutral_aqua}

      ; stuff I've never seen before :thonk:
     :pick_selected {:bg colors.bright_red :fg colors.bright_red}
     :tab_selected {:bg colors.bright_green :fg colors.bright_green}
     :tab {:bg colors.bright_yellow :fg colors.bright_yellow}}}))
