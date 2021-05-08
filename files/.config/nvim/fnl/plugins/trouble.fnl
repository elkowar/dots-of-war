(module plugins.trouble
  {autoload {utils utils
             colors colors}
   require {trouble trouble}})

(trouble.setup
 {:icons false
  :auto_preview true
  :auto_close true
  :auto_open false
  :action_keys
    {:jump "o"
     :jump_close "<CR>"
     :close "<esc>"
     :cancel "q"
     :hover ["a" "K"]}})

(utils.highlight "LspTroubleFoldIcon" {:bg "NONE" :fg colors.bright_orange})
(utils.highlight "LspTroubleCount"    {:bg "NONE" :fg colors.bright_green})
(utils.highlight "LspTroubleText"     {:bg "NONE" :fg colors.light0})

(utils.highlight "LspTroubleSignError"       {:bg "NONE" :fg colors.bright_red})
(utils.highlight "LspTroubleSignWarning"     {:bg "NONE" :fg colors.bright_yellow})
(utils.highlight "LspTroubleSignInformation" {:bg "NONE" :fg colors.bright_aqua})
(utils.highlight "LspTroubleSignHint"        {:bg "NONE" :fg colors.bright_blue})
