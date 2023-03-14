(module dots.plugins.gruvbox8
  {autoload {utils dots.utils
             colors dots.colors}
   require-macros [macros]})

(set vim.g.gruvbox_italics 0)
(set vim.g.gruvbox_italicise_strings 0)
(set vim.g.gruvbox_filetype_hi_groups 1)
(set vim.g.gruvbox_plugin_hi_groups 1)



(defn- setup-colors []
  (utils.highlight-add 
   ["GruvboxBlueSign" "GruvboxAquaSign" "GruvboxRedSign" "GruvboxYellowSign" "GruvboxGreenSign" "GruvboxOrangeSign" "GruvboxPurpleSign"] 
   {:bg "NONE"})

  ; hide empty line ~'s
  (utils.highlight :EndOfBuffer {:bg "NONE" :fg colors.bg_main})
  (utils.highlight :LineNr {:bg "NONE"})

  (utils.highlight-add :Pmenu          {:bg colors.bg_second})
  (utils.highlight-add :PmenuSel       {:bg colors.bright_aqua})
  (utils.highlight-add :PmenuSbar      {:bg colors.bg_second})
  (utils.highlight-add :PmenuThumb     {:bg colors.dark1})
  (utils.highlight-add :NormalFloat    {:bg colors.bg_second})
  (utils.highlight-add :SignColumn     {:bg colors.bg_main})

  (utils.highlight-add :FloatBorder    {:bg colors.bg_second})
  (utils.highlight-add :SpecialComment {:fg colors.dark4})

  (utils.highlight-add 
    [:LspDiagnosticsSignError :LspDiagnosticsSignWarning :LspDiagnosticsSignInformation :LspDiagnosticsSignHint] 
    {:bg "NONE"})

  (utils.highlight-add :DiagnosticError       {:fg colors.bright_red})
  (utils.highlight-add :DiagnosticWarning     {:fg colors.bright_orange})
  (utils.highlight-add :DiagnosticInformation {:fg colors.bright_aqua})
  (utils.highlight-add :DiagnosticHint        {:fg colors.bright_yellow}) 

  (utils.highlight-add :DiagnosticVirtualTextError       {:bg "#342828" :fg colors.bright_red})
  (utils.highlight-add :DiagnosticVirtualTextWarning     {:bg "#473027" :fg colors.bright_orange})
  (utils.highlight-add :DiagnosticVirtualTextWarning     {:bg "#3b2c28" :fg colors.bright_orange})
  (utils.highlight-add :DiagnosticVirtualTextInformation {:bg "#272d2f" :fg colors.bright_aqua})
  (utils.highlight-add :DiagnosticVirtualTextHint        {:bg "#272d2f" :fg colors.bright_yellow}) 

  (utils.highlight :LspDiagnosticsUnderlineError         {:gui "undercurl"})

  (vim.fn.sign_define :LspDiagnosticsSignError {:text "◆"})
  (vim.fn.sign_define :LspDiagnosticsSignWarning {:text "◆"})
  (vim.fn.sign_define :LspDiagnosticsSignHint {:text "◆"})
  (vim.fn.sign_define :LspDiagnosticsSignInformation {:text "◆"})


  (utils.highlight :StatusLine {:bg colors.dark1 :fg colors.light0})

  (vim.cmd "highlight link Function GruvboxGreen")
  (utils.highlight-add :Function {:gui "NONE"}))

(defn setup-telescope-theme []
  (def prompt "blacker")
  (if
    (= prompt "bright")
    (let [promptbg "#689d6a"]
      (utils.highlight-add :TelescopePromptBorder {:bg promptbg :fg promptbg})
      (utils.highlight-add :TelescopePromptNormal {:bg promptbg :fg colors.bg_main})
      (utils.highlight-add :TelescopePromptTitle  {:bg promptbg :fg colors.dark1}))

    (= prompt "dark")
    (let [promptbg "#252525"]
      (utils.highlight-add :TelescopePromptBorder {:bg promptbg :fg promptbg})
      (utils.highlight-add :TelescopePromptNormal {:bg promptbg :fg colors.light2})
      (utils.highlight-add :TelescopePromptPrefix {:bg promptbg :fg colors.neutral_aqua})
      (utils.highlight-add :TelescopePromptTitle  {:bg colors.neutral_blue :fg colors.dark1}))

    (= prompt "black")
    (let [promptbg "#212526"]
      (utils.highlight-add :TelescopePromptBorder {:bg promptbg :fg promptbg})
      (utils.highlight-add :TelescopePromptNormal {:bg promptbg :fg colors.light2})
      (utils.highlight-add :TelescopePromptPrefix {:bg promptbg :fg colors.neutral_aqua})
      (utils.highlight-add :TelescopePromptTitle  {:bg colors.neutral_green :fg colors.dark1}))

    (= prompt "blacker")
    (let [promptbg "#1f2324"]
      (utils.highlight-add :TelescopePromptBorder {:bg promptbg :fg promptbg})
      (utils.highlight-add :TelescopePromptNormal {:bg promptbg :fg colors.light2})
      (utils.highlight-add :TelescopePromptPrefix {:bg promptbg :fg colors.neutral_aqua})
      (utils.highlight-add :TelescopePromptTitle  {:bg colors.neutral_blue :fg colors.dark1})))

  (def side "darker")
  (if
    (= side "brighter")
    (let [previewbg "#1f2324"]
      (utils.highlight-add :TelescopePreviewNormal {:bg previewbg})
      (utils.highlight-add :TelescopePreviewBorder {:bg previewbg :fg previewbg}))

    (= side "darker")
    (let [previewbg "#1a1e1f"]
      (utils.highlight-add :TelescopePreviewNormal {:bg previewbg})
      (utils.highlight-add :TelescopePreviewBorder {:bg previewbg :fg previewbg})))

  (utils.highlight-add :TelescopeBorder       {:bg colors.bg_second :fg colors.bg_second})
  (utils.highlight-add :TelescopeNormal       {:bg colors.bg_second})
  (utils.highlight-add :TelescopePreviewTitle {:bg colors.neutral_green :fg colors.dark1})
  (utils.highlight-add :TelescopeResultsTitle {:bg colors.neutral_aqua  :fg colors.dark1})

  (utils.highlight-add :TelescopeSelection    {:bg colors.neutral_aqua :fg colors.dark1}))

(defn- setup-noice-theme []
  (utils.highlight-add :NoicePopupmenu {:bg colors.bg_second})
  (utils.highlight-add :NoiceCmdline {:bg "#1f2324"})
  (utils.highlight-add :NoiceCmdlinePopup {:bg "#1f2324"})
  (utils.highlight-add :NoiceCmdlinePrompt {:bg "#1f2324"})
  (utils.highlight-add :NoiceCmdlinePopupBorder {:fg colors.bright_aqua})
  (utils.highlight-add :NoiceCmdlineIcon {:fg colors.bright_aqua}))

(vim.api.nvim_create_autocmd "ColorScheme" {:pattern "*" :callback setup-colors})
(setup-colors)
(vim.api.nvim_create_autocmd "ColorScheme" {:pattern "*" :callback setup-telescope-theme})
(setup-telescope-theme)
(vim.api.nvim_create_autocmd "ColorScheme" {:pattern "*" :callback setup-noice-theme})
(setup-noice-theme)

(vim.api.nvim_create_autocmd
  "ColorScheme"
  {:pattern "*"
   :callback
   (fn []
     (utils.highlight-add "GitSignsAdd" {:gui "NONE" :bg "NONE" :fg colors.bright_aqua})
     (utils.highlight-add "GitSignsDelete" {:gui "NONE" :bg "NONE" :fg colors.neutral_red})
     (utils.highlight-add "GitSignsChange" {:gui "NONE" :bg "NONE" :fg colors.bright_blue})
     (utils.highlight-add "ScrollbarGitAdd" {:gui "NONE" :bg "NONE" :fg colors.bright_aqua})
     (utils.highlight-add "ScrollbarGitDelete" {:gui "NONE" :bg "NONE" :fg colors.neutral_red})
     (utils.highlight-add "ScrollbarGitChange" {:gui "NONE" :bg "NONE" :fg colors.bright_blue}))})
               





(if (= "epix" (vim.fn.hostname))
  (vim.cmd "colorscheme gruvbox8_hard")
  (vim.cmd "colorscheme gruvbox8"))

