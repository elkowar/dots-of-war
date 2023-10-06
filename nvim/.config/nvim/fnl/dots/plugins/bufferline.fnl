(local {: autoload} (require :nfnl.module))
(local a (autoload :aniseed.core))
(local utils (autoload :dots.utils))
(local bufferline (autoload :bufferline))
(local colors (autoload :dots.colors))

(vim.cmd "hi link BufferLineTabSeparatorSelected BufferLineSeparatorSelected")
(vim.cmd "hi link BufferLineTabSeparator BufferLineSeparator")

(fn mk-active [fg]
  {:bg colors.neutral_aqua :fg fg :italic false :bold false})
(fn mk-visible [fg]
  {:bg colors.dark1 :fg fg :italic false :bold false})

(fn setup []
  ; :h bufferline-lua-highlights
  (let [selected {:bg colors.neutral_aqua :fg colors.bg_main :gui "NONE"}
        visible  {:bg colors.dark1        :fg colors.neutral_aqua}]
   (bufferline.setup 
     {:options
      {:diagnostics "nvim_lsp"
       :diagnostics_indicator (fn [cnt _lvl _diagnostics-dict] (.. " (" cnt ")"))
       :show_buffer_close_icons false
       :show_buffer_icons false
       :show_close_icon false
       :show_tab_indicators false
       :enforce_regular_tabs false
       :tab_size 10}

       ; https://github.com/akinsho/nvim-bufferline.lua/blob/4ebab39af2376b850724dd29c29579c8e024abe6/lua/bufferline/config.lua#L74
      :highlights 
      {:fill {:bg colors.bg_main :fg colors.light0}
       :background visible
       :buffer_visible visible
       :buffer_selected (a.assoc selected :bold false :italic false)
       :modified  visible   :modified_visible  visible   :modified_selected  selected
       :hint      visible   :hint_visible      visible   :hint_selected      selected
       :info      visible   :info_visible      visible   :info_selected      selected
       :warning   visible   :warning_visible   visible   :warning_selected   selected
       :error     visible   :error_visible     visible   :error_selected     selected
       :duplicate visible   :duplicate_visible visible   :duplicate_selected selected
       
       :diagnostic                  (mk-visible colors.neutral_red)
       :diagnostic_visible          (mk-visible colors.neutral_red)
       :diagnostic_selected         (mk-active colors.faded_red)

       :info_diagnostic             (mk-visible colors.neutral_blue)
       :info_diagnostic_visible     (mk-visible colors.neutral_blue)
       :info_diagnostic_selected    (mk-active colors.faded_blue)

       :hint_diagnostic             (mk-visible colors.neutral_yellow)
       :hint_diagnostic_visible     (mk-visible colors.neutral_yellow)
       :hint_diagnostic_selected    (mk-active colors.faded_orange)

       :warning_diagnostic          (mk-visible colors.neutral_orange)
       :warning_diagnostic_visible  (mk-visible colors.neutral_orange)
       :warning_diagnostic_selected (mk-active colors.faded_orange)

       :error_diagnostic            (mk-visible colors.neutral_red)
       :error_diagnostic_visible    (mk-visible colors.neutral_red)
       :error_diagnostic_selected   (mk-active colors.red)

       :separator visible
       :separator_visible {:bg colors.red}
       :separator_selected {:bg colors.red}
       :indicator_selected {:bg colors.neutral_aqua :fg colors.neutral_aqua :italic false :bold false}
       :tab_separator {:bg colors.red}
       :tab_separator_selected {:bg colors.neutral_aqua :fg colors.neutral_aqua}

        ; stuff I've never seen before :thonk:
       :pick_selected {:bg colors.bright_red :fg colors.bright_red}
       :tab_selected {:bg colors.bright_green :fg colors.bright_green}
       :tab {:bg colors.bright_yellow :fg colors.bright_yellow}}})))

[(utils.plugin :akinsho/nvim-bufferline.lua
               {:config setup :tag "v4.4.0"})]
