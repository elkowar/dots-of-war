(local {: autoload} (require :nfnl.module))
(local utils (autoload :dots.utils))
(local colors (autoload :dots.colors))
(local trouble (autoload :trouble))

(fn setup []
  (trouble.setup
   {:icons false
    ; disabled due to https://github.com/folke/trouble.nvim/issues/125
    :auto_preview false
    :auto_close true
    :auto_open false
    :auto_jump ["lsp_definitions" "lsp_workspace_diagnostics" "lsp_type_definitions"]
    :indent_lines false
    :multiline false
    :action_keys
      {:jump "<CR>"
       :jump_close "o"
       :close ["<esc>" "q"]
       :cancel "q"
       :preview "p"
       :toggle_preview "P"
       :toggle_mode "m"
       :hover ["a" "K"]}})

  (utils.highlight "TroubleFoldIcon" {:bg "NONE" :fg colors.bright_orange})
  (utils.highlight "TroubleCount"    {:bg "NONE" :fg colors.bright_green})
  (utils.highlight "TroubleText"     {:bg "NONE" :fg colors.light0})

  (utils.highlight "TroubleSignError"       {:bg "NONE" :fg colors.bright_red})
  (utils.highlight "TroubleSignWarning"     {:bg "NONE" :fg colors.bright_yellow})
  (utils.highlight "TroubleSignInformation" {:bg "NONE" :fg colors.bright_aqua})
  (utils.highlight "TroubleSignHint"        {:bg "NONE" :fg colors.bright_blue}))

[(utils.plugin
   :folke/trouble.nvim
   {:lazy true 
    :config setup
    :cmd ["Trouble" "TroubleClose" "TroubleRefresh" "TroubleToggle"]})]
                     
