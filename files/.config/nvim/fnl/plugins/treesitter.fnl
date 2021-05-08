(module plugins.treesitter
  {autoload {a aniseed.core}
   require {configs nvim-treesitter.configs}
   require-macros [macros]})

(configs.setup 
  {:ensure_installed "all" 
   :highlight {:enable true
               :disable ["fennel"]}

   :incremental_selection {:enable true
                           :keymaps {:init_selection    "gss"
                                     :node_incremental  "gsl"
                                     :node_decremental  "gsh"
                                     :scope_incremental "gsj"
                                     :scope_decremental "gsk"}}

   ; Might fuck with gitsigns
   :rainbow {:enable true
             :extended_mode true}
   :context_commentstring {:enable true}})

   ;:indent    {:enable true}
               ;:disable ["lua"]


