(module plugins.emmet)

(set vim.g.user_emmet_mode "n")
(set vim.g.user_emmet_leader_key "<leader>e")
(set vim.g.user_emmet_settings {:javascript.jsx {:extends "jsx"} 
                                :typescript.jsx {:extends "jsx"}})

