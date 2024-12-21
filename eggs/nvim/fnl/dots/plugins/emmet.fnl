(local utils (require :dots.utils))

(fn setup []
  (set vim.g.user_emmet_mode "n")
  (set vim.g.user_emmet_leader_key "<leader>e")
  (set vim.g.user_emmet_settings {:javascript.jsx {:extends "jsx"} 
                                  :typescript.jsx {:extends "jsx"}}))

[(utils.plugin
   :mattn/emmet-vim
   {:lazy true
    :config setup})]

 
