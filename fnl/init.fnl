(module init 
  {require {a aniseed.core
            fennel aniseed.fennel 
            nvim aniseed.nvim 
            kb keybinds 
            utils utils}
    require-macros [macros]})

(require "plugins.telescope")
(require "plugins.lsp")
(require "plugins.galaxyline")


(global pp 
  (fn [x] 
    (print (fennel.view x))))

;(set nvim.g.conjure#client#fennel#aniseed#aniseed_module_prefix "aniseed.")



(local colors (utils.colors))
(local bufferline (require "bufferline"))

; :h bufferline-lua-highlights
(let [selected { :guibg colors.neutral_aqua :guifg colors.dark0 :gui ""}
      visible  { :guibg colors.dark1 :guifg colors.neutral_aqua :gui ""}]
  (bufferline.setup 
    { :options
      { :diagnostics "nvim_lsp"
        :diagnostics_indicator (fn [cnt lvl diagnostics-dict] (.. " (" cnt ")"))
        :show_buffer_close_icons false
        :show_close_icon false
        :show_tab_indicators false
        :enforce_regular_tabs false
        :tab_size 10}

      :highlights 
      { :fill { :guibg colors.dark0 :guifg colors.light0}
        :background visible
        :buffer_visible visible
        :buffer_selected selected
        :modified visible
        :modified_visible visible
        :modified_selected selected
        :error visible
        :error_selected selected
        :error_visible visible
        :warning visible
        :warning_selected selected
        :warning_visible visible
        :separator visible
        :indicator_selected {:guibg colors.neutral_aqua :guifg colors.neutral_aqua}}}))

