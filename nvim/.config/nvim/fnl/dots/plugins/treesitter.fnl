(import-macros m :macros)
(m.al utils dots.utils)
(m.al a nfnl.core)

(fn setup [])

(fn setup1 []
  (local configs (require :nvim-treesitter.configs))
  (configs.setup 
    {:ensure_installed ["rust" "fennel" "commonlisp" "vim" "regex" "lua" "bash" "markdown" "markdown_inline"]
    ; :ensure_installed "maintained" 
     :highlight {:enable false
                 :disable ["fennel" "rust" "haskell"]}

     :incremental_selection {:enable false
                             :keymaps {:init_selection    "gss"
                                       :node_incremental  "gsl"
                                       :node_decremental  "gsh"
                                       :scope_incremental "gsj"
                                       :scope_decremental "gsk"}}
     :textsubjects {:enable true
                    :disable ["noice"]
                    :prev_selection ","
                    :keymaps {"." "textsubjects-smart"}}

     ; Might fuck with gitsigns
     ;:rainbow {:enable true}
               ;:extended_mode true}
     :context_commentstring {:enable true :disable ["rust" "fennel"]}

     :playground
     {:enable false
      :disable ["fennel"]
      :updatetime 25 ; Debounced time for highlighting nodes in the playground from source code
      :persist_queries false ; Whether the query persists across vim sessions
      :keybindings
      {:toggle_query_editor "o"
       :toggle_hl_groups "i"
       :toggle_injected_languages "t"
       :toggle_anonymous_nodes "a"
       :toggle_language_display "I"
       :focus_language "f"
       :unfocus_language "F"
       :update "R"
       :goto_node "<cr>"
       :show_help "?"}}}))

[(utils.plugin :nvim-treesitter/nvim-treesitter
               {:config setup 
                :lazy true
                :event ["VeryLazy"]
                :build ":TSUpdate"})
 (utils.plugin :RRethy/nvim-treesitter-textsubjects
               {:dependencies [:nvim-treesitter/nvim-treesitter]
                :lazy true
                :event ["VeryLazy"]})
 (utils.plugin :JoosepAlviste/nvim-ts-context-commentstring
               {:event ["VeryLazy"]
                :lazy true
                :dependencies [:nvim-treesitter/nvim-treesitter]})
 (utils.plugin :nvim-treesitter/playground
               {:event ["VeryLazy"]
                :lazy true
                :dependencies [:nvim-treesitter/nvim-treesitter]})]
