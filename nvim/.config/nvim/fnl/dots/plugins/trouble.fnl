(import-macros m :macros)
(m.al utils dots.utils)
(m.al colors dots.colors)
(m.al trouble trouble)

(fn setup []
  (trouble.setup
   {:icons false
    :auto_preview true
    :auto_close true
    :auto_open false
    :auto_jump ["lsp_definitions" "lsp_workspace_diagnostics" "lsp_type_definitions"]
    :indent_lines false
    :action_keys
      {:jump "o"
       :jump_close "<CR>"
       :close "<esc>"
       :cancel "q"
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
                     
