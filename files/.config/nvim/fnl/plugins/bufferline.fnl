(module plugins.bufferline
  {require {a aniseed.core
            fennel aniseed.fennel 
            nvim aniseed.nvim 
            utils utils
            bufferline bufferline
            colors colors}})


; :h bufferline-lua-highlights
(let [selected {:guibg colors.neutral_aqua :guifg colors.dark0 :gui ""}
      visible  {:guibg colors.dark1 :guifg colors.neutral_aqua :gui ""}]
 (bufferline.setup 
   {:options
    {:diagnostics "nvim_lsp"
     :diagnostics_indicator (fn [cnt lvl diagnostics-dict] (.. " (" cnt ")"))
     :show_buffer_close_icons false
     :show_close_icon false
     :show_tab_indicators false
     :enforce_regular_tabs false
     :tab_size 10}

     ; https://github.com/akinsho/nvim-bufferline.lua/blob/4ebab39af2376b850724dd29c29579c8e024abe6/lua/bufferline/config.lua#L74
    :highlights 
    {:fill {:guibg colors.dark0 :guifg colors.light0}
     :background visible
     :buffer_visible visible
     :buffer_selected selected
     :modified visible
     :modified_visible visible
     :modified_selected selected
     :error visible
     :error_selected selected
     :error_visible selected
     :warning visible
     :warning_selected selected
     :warning_visible visible

     :duplicate visible
     :duplicate_visible visible
     :duplicate_selected selected

     :diagnostic          {:gui "" :guibg colors.dark1        :guifg colors.neutral_red}
     :diagnostic_visible  {:gui "" :guibg colors.dark1        :guifg colors.neutral_red}
     :diagnostic_selected {:gui "" :guibg colors.neutral_aqua :guifg colors.faded_red}

     :info_diagnostic          {:gui "" :guibg colors.dark1        :guifg colors.neutral_blue}
     :info_diagnostic_visible  {:gui "" :guibg colors.dark1        :guifg colors.neutral_blue}
     :info_diagnostic_selected {:gui "" :guibg colors.neutral_aqua :guifg colors.faded_blue}

     :warning_diagnostic          {:gui "" :guibg colors.dark1        :guifg colors.neutral_yellow}
     :warning_diagnostic_visible  {:gui "" :guibg colors.dark1        :guifg colors.neutral_yellow}
     :warning_diagnostic_selected {:gui "" :guibg colors.neutral_aqua :guifg colors.faded_yellow}

     :separator visible
     :indicator_selected {:guibg colors.neutral_aqua :guifg colors.neutral_aqua}

      ; stuff I've never seen before :thonk:
     :pick_selected {:guibg colors.bright_red :guifg colors.bright_red}
     :tab_selected {:guibg colors.bright_green :guifg colors.bright_green}
     :tab {:guibg colors.bright_yellow :guifg colors.bright_yellow}}}))


(utils.highlight :BufferLineInfoSelected {:bg colors.neutral_aqua :fg colors.dark0 :gui "NONE"})

