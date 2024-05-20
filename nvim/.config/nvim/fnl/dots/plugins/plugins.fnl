;(local {: autolod} (require :nfnl.module))


(macro setup [name opts]
  `((. (require ,name) :setup) ,opts))

(macro plugin [name ?opts]
  (if (= nil ?opts)
    name
    (do (tset ?opts 1 name) ?opts)))

[(plugin :Olical/aniseed)
 (plugin :Olical/nfnl)
 (plugin :nvim-lua/plenary.nvim)
 (plugin :norcalli/nvim.lua)
 (plugin :kyazdani42/nvim-web-devicons)
 (plugin :folke/which-key.nvim)
 (plugin :ckipp01/nvim-jenkinsfile-linter
         {:dependencies ["nvim-lua/plenary.nvim"]})
 (plugin :psliwka/vim-smoothie)
 (plugin :nathanaelkane/vim-indent-guides
         {:cmd ["IndentGuidesToggle"]})
 (plugin :luukvbaal/stabilize.nvim {:config true})
 (plugin :stevearc/dressing.nvim {:config true})
 (plugin :tweekmonster/startuptime.vim {:cmd ["StartupTime"]})
 (plugin :moll/vim-bbye {:lazy true :cmd [:Bdelete :Bwipeout]})
 (plugin :petertriho/nvim-scrollbar
         {:event "VeryLazy"
          :lazy true
          :config true})
 (plugin :TimUntersberger/neogit
         {:opts {:integrations {:diffview true}}
          :cmd ["Neogit"]})
 (plugin :folke/persistence.nvim
         {:opts {:dir (vim.fn.expand (.. (vim.fn.stdpath "cache") "/sessions/"))}})

 (plugin "https://git.sr.ht/~whynothugo/lsp_lines.nvim"
         {:config #(do (setup :lsp_lines)
                    (vim.diagnostic.config {:virtual_lines false}))})

 ; editing and movement <<<
 (plugin :jiangmiao/auto-pairs)
 (plugin :tpope/vim-repeat)
 (plugin :preservim/nerdcommenter
         {:event "VeryLazy"
          :lazy true
          :priority 1000})
 (plugin :godlygeek/tabular
         {:cmd ["Tabularize"]})
 (plugin :tpope/vim-surround)
 (plugin :hauleth/sad.vim)
 (plugin :wellle/targets.vim) ; more text objects. IE: cin (change in next parens). generally better handling of surrounding objects.
 (plugin :mg979/vim-visual-multi
         {:lazy true :event "VeryLazy"})
 (plugin :tommcdo/vim-exchange) 
 (plugin :phaazon/hop.nvim
         {:lazy true
          :event "VeryLazy"
          :opts {:keys "jfkdls;amvieurow"}})
 ; >>>

 ; debugger <<<
 ;(plugin :rcarriga/nvim-dap-ui
         ;{:lazy true
          ;:config true
          ;:dependencies [:mfussenegger/nvim-dap
                         ;:nvim-neotest/nvim-nio]})
                         
 (plugin :mfussenegger/nvim-dap
         {:lazy true})
 (plugin :nvim-telescope/telescope-dap.nvim
         {:lazy true
          :dependencies [:nvim-telescope/telescope.nvim
                         :mfussenegger/nvim-dap]})
                                                   
 ; >>>
                                                   
 ; git stuff  <<<
 (plugin :ldelossa/gh.nvim
         {:lazy true
          :config #(do ((. (require "litee.lib") :setup))
                       ((. (require "litee.gh") :setup)))
          :dependencies [:ldelossa/litee.nvim]})
 (plugin :pwntester/octo.nvim
         {:lazy true
          :dependencies [:nvim-lua/plenary.nvim
                         :nvim-telescope/telescope.nvim
                         :kyazdani42/nvim-web-devicons]
                       :config true})

 (plugin :ruanyl/vim-gh-line)
 (plugin :rhysd/conflict-marker.vim)
 (plugin :tpope/vim-fugitive
         {:lazy true :event "VeryLazy"})
 ; >>>

 ; lsp <<<
 (plugin :ray-x/lsp_signature.nvim
         {:event :BufEnter})
 (plugin :weilbith/nvim-code-action-menu
         {:cmd "CodeActionMenu"
          :config #(set vim.g.code_action_menu_show_details false)})
 (plugin :dnlhc/glance.nvim
         {:lazy true :config true})

 (plugin :smjonas/inc-rename.nvim
         {:opts {:input_buffer_type "dressing"}})
 ; >>>

 ; cmp <<<
 ; >>>

 ; code-related ----------------------------------------- <<<

 (plugin :monkoose/nvlime
         {:ft ["lisp"] :dependencies [:monkoose/parsley]})

 (plugin :tpope/vim-sleuth)
 (plugin :editorconfig/editorconfig-vim)
 (plugin :sbdchd/neoformat)
 (plugin :elkowar/antifennel-nvim
         {:config #(set vim.g.antifennel_executable "/home/leon/tmp/antifennel/antifennel")})
 (plugin :Olical/conjure {:ft ["fennel"]})
 (plugin :eraserhd/parinfer-rust {:build "cargo build --release"})
 (plugin :kmonad/kmonad-vim)
 (plugin :elkowar/yuck.vim {:ft ["yuck"]})
 (plugin :cespare/vim-toml {:ft ["toml"]})
 (plugin :bduggan/vim-raku {:ft ["raku"]})
 (plugin :LnL7/vim-nix {:ft ["nix"]})
 (plugin :kevinoid/vim-jsonc {})
 (plugin :pangloss/vim-javascript {:ft ["javascript"]}) ; syntax highlighting JS
 (plugin :ianks/vim-tsx {:ft ["typescript-react"]})
 (plugin :leafgarland/typescript-vim {:ft ["typescript" "typescript-react" "javascript"]})
 (plugin :HerringtonDarkholme/yats.vim {}) ; typescript syntax highlighting
 (plugin :mxw/vim-jsx {})
 (plugin :purescript-contrib/purescript-vim {:ft ["purescript"]})
 (plugin :derekelkins/agda-vim {:ft ["agda"]})
 (plugin :neovimhaskell/haskell-vim { :ft ["haskell"]})
 (plugin :monkoose/nvlime
         {:ft ["lisp"]
          :dependencies ["monkoose/parsley"]
          :config #(set vim.g.vlime_overlay "slimv")})


 (plugin :rust-lang/rust.vim
         {:ft ["rust"]
          :dependencies ["mattn/webapi-vim"]
          :config #(do (set vim.g.rustfmt_fail_silently 1))})

 (plugin :Saecki/crates.nvim
         {:dependencies ["nvim-lua/plenary.nvim"]
          ;:event ["BufRead Cargo.toml"]
          ;:lazy true
          :opts {:disable_invalid_feature_diagnostic true
                 :enable_update_available_warning false}})
                                
 ; temporarily using this fork that merges a few fixes, until simrat is back
 (plugin :mrcjkb/rustaceanvim {:version "^4" :ft ["rust" "toml"]})
 ;(plugin :MunifTanjim/rust-tools.nvim
         ;{:ft ["rust" "toml"]
          ;:dependencies ["nvim-lua/popup.nvim" "nvim-lua/plenary.nvim"]})
 ;(plugin :simrat39/rust-tools.nvim
         ;{:ft ["rust" "toml"]
          ;:dependencies ["nvim-lua/popup.nvim" "nvim-lua/plenary.nvim"]})


 (plugin :qnighy/lalrpop.vim {})
 (plugin :edwinb/idris2-vim {:ft ["idris2"]})
 (plugin :vmchale/ats-vim {:ft ["ats" "dats" "sats"]})
 (plugin :bakpakin/fennel.vim {:ft ["fennel"]})
 (plugin :evanleck/vim-svelte {})]


; >>>

; vim:foldmarker=<<<,>>>


