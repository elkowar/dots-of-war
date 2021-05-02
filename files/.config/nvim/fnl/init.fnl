(module init 
  {require {a aniseed.core
            fennel aniseed.fennel
            nvim aniseed.nvim
            str aniseed.string
            kb keybinds
            utils utils
            nvim-treesitter-configs nvim-treesitter.configs
            gitsigns gitsigns}
   require-macros [macros]})

(require "plugins.telescope")
(require "plugins.lsp")
(require "plugins.galaxyline")
(require "plugins.bufferline")

(def- colors utils.colors)

;(tset debug :traceback fennel.traceback)


(set vim.g.conjure#client#fennel#aniseed#aniseed_module_prefix "aniseed.")

; Colors  ------------------------------------------------------- foldstart

(utils.highlight-add 
 ["GruvboxBlueSign" "GruvboxAquaSign" "GruvboxRedSign" "GruvboxYellowSign" "GruvboxGreenSign" "GruvboxOrangeSign" "GruvboxPurpleSign"] 
 {:bg "NONE"})



; foldend 

; Treesitter  ------------------------------------------------------- foldstart

(nvim-treesitter-configs.setup 
  {:ensure_installed "all" 
   :highlight {:enable true
               :disable ["fennel"]}
   :indent    {:enable true
               :disable ["lua"]}

   :incremental_selection 
     {:enable true
      :keymaps {:init_selection    "gss"
                :node_incremental  "gsl"
                :node_decremental  "gsh"
                :scope_incremental "gsj"
                :scope_decremental "gsk"}}

   ; disabled due to it fucking with gitsigns.nvim
   ;:rainbow { :enable true
              ;:extended_mode true}

   :context_commentstring {:enable true}})

;(nvim-biscuits.setup {}
  ;{ :on_events ["InsertLeave" "CursorHoldI"]})

; foldend

; gitsigns.nvim ------------------------------------------------------- foldstart
; https://github.com/lewis6991/gitsigns.nvim
(gitsigns.setup
  {:signs {:add {:text "▍"}
           :change {:text "▍"}
           :delete {:text "▍"}
           :topdelete {:text "▍"}
           :changedelete {:text "▍"}}
   :keymaps {:noremap true 
             :buffer true}
   :current_line_blame true
   :update_debounce 100})

(utils.highlight "GitSignsAdd"    {:bg "NONE" :fg colors.bright_aqua})
(utils.highlight "GitSignsDelete" {:bg "NONE" :fg colors.neutral_red})
(utils.highlight "GitSignsChange" {:bg "NONE" :fg colors.bright_blue})

; foldend

; :: diffview  ------------------------------------------------------------------- foldstart

(let [diffview (require "diffview")
      cb (. (require "diffview.config") :diffview_callback)]
  (diffview.setup
   {:diff_binaries false
    :file_panel {:width 35 
                 :use_icons false}
    :key_bindings {:view {:<leader>dn (cb "select_next_entry")
                          :<leader>dp (cb "select_prev_entry")
                          :<leader>dd (cb "toggle_files")}}}))

; foldend

; :: and _ as space ------------------------------------------------------------------- foldstart
(var remapped-space nil)
(fn _G.RebindShit [newKey]
  (set remapped-space {:old (vim.fn.maparg :<Space> :i)
                       :cur newKey})
  (utils.keymap :i :<Space> newKey {:buffer true}))

(fn _G.UnbindSpaceStuff []
  (when (and remapped-space (~= remapped-space {}))
   (utils.del-keymap :i :<Space> true)
   (when (~= remapped-space.old "")
    (utils.keymap :i :<Space> remapped-space.old {:buffer true}))
   (set remapped-space nil)))
 


(nvim.command "autocmd! InsertLeave * :call v:lua.UnbindSpaceStuff()")
(utils.keymap :n "<Tab>j" ":call v:lua.RebindShit('_')<CR>")
(utils.keymap :n "<Tab>k" ":call v:lua.RebindShit('::')<CR>")
(utils.keymap :i "<Tab>j" "<space><C-o>:call v:lua.RebindShit('_')<CR>")
(utils.keymap :i "<Tab>k" "<space><C-o>:call v:lua.RebindShit('::')<CR>")
(utils.keymap :n "ö" "a")

; foldend


 ; vim:foldmarker=foldstart,foldend
