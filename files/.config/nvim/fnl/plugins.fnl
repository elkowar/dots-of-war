(module plugins
  {require {utils utils
            a aniseed.core
            packer packer}
   require-macros [macros]})

(defn safe-require-plugin-config [name]
  (xpcall 
    #(require name) 
    #(a.println (.. "Error sourcing " name ":\n" (fennel.traceback $1)))))

(defn- use [...]
  "Iterates through the arguments as pairs and calls packer's  function for
  each of them. Works around Fennel not liking mixed associative and sequential
  tables as well."
  (let [pkgs [...]]
    (packer.startup
      (fn [use]
        (each-pair [name opts pkgs]
          (-?> (. opts :mod) (safe-require-plugin-config))
          (use (a.assoc opts 1 name)))))))


(use
  :nvim-telescope/telescope.nvim {:mod "plugins.telescope"
                                  :requires [:nvim-lua/popup.nvim :nvim-lua/plenary.nvim]}

  :p00f/nvim-ts-rainbow {}
  :romgrk/nvim-treesitter-context {}
  :JoosepAlviste/nvim-ts-context-commentstring {}
  :nvim-treesitter/nvim-treesitter {:run ":TSUpdate"}
  
  ; :code-biscuits/nvim-biscuits {} ; show opening line after closing curly

  :folke/which-key.nvim {}

  :pwntester/octo.nvim {}

  ; json query stuff
  :gennaro-tedesco/nvim-jqx {:ft ["json"]}

  :Olical/aniseed {}; :tag "v3.16.0"}
  
  ; general purpose lua wrappers for nvim stuff
  :norcalli/nvim.lua {}

  :glepnir/galaxyline.nvim {:mod "plugins.galaxyline"}
  :akinsho/nvim-bufferline.lua {:mod "plugins.bufferline"}

  :sindrets/diffview.nvim {:mod "plugins.diffview"}
  :tweekmonster/startuptime.vim {:cmd ["StartupTime"]}
  :tpope/vim-repeat {}

  :junegunn/goyo.vim {:cmd "Goyo"}
  
  :lewis6991/gitsigns.nvim {:mod "plugins.gitsigns"}

  :gruvbox-community/gruvbox {}

  :tpope/vim-fugitive {}
  :preservim/nerdcommenter {}
  :godlygeek/tabular {}               ; :Tab /regex can align code on occurrences of the given regex. I.e. :Tab /= aligns all = signs in a block.
  :tpope/vim-surround {}
  :christoomey/vim-tmux-navigator {}  ; good integration with tmux pane switching
  :nathanaelkane/vim-indent-guides {} ; Can be toggled using <leader>ig (intent-guides)

  ; <C-n> to select current word. <C-n> to select next occurrence.
  ; with multiple lines selected in Visual mode, <C-n> to insert cursor in each line. I not i to insert in Visual-mode.
  :terryma/vim-multiple-cursors {}
  :mg979/vim-visual-multi {}
  :hauleth/sad.vim {}          ; Use siw instead of ciw. when using . afterwards, will find the next occurrence of the changed word and change it too
  :wellle/targets.vim {}       ; more text objects. IE: cin (change in next parens). generally better handling of surrounding objects.
  :unblevable/quick-scope {}   ; highlight targets when pressing f<character>

  :iamcco/markdown-preview.nvim {:run vim.fn.mkdp#util#install}

  ; code-related ----------------------------------------- <<<

  :folke/lsp-trouble.nvim {}
  :simrat39/symbols-outline.nvim {}
  :neovim/nvim-lspconfig {}
  :hrsh7th/nvim-compe {}
  :glepnir/lspsaga.nvim {}


  :Olical/conjure {}
  :tami5/compe-conjure {}

  :machakann/vim-highlightedyank {}
  :ciaranm/detectindent {}
  :pechorin/any-jump.vim {}
  :justinmk/vim-sneak {}
  :psliwka/vim-smoothie {}
  :editorconfig/editorconfig-vim {}
  :honza/vim-snippets {}
  :tommcdo/vim-exchange {}
  :kien/rainbow_parentheses.vim {}

  :bhurlow/vim-parinfer {:ft ["fennel" "carp" "lisp" "elisp"]}

  :bduggan/vim-raku {:ft ["raku"]}
  :LnL7/vim-nix {:ft ["nix"]}

  :kevinoid/vim-jsonc {}

  :ap/vim-css-color {}
  :pangloss/vim-javascript {} ; syntax highlighting JS
  :ianks/vim-tsx {}
  :leafgarland/typescript-vim {}
  :sheerun/vim-polyglot {}    ; Syntax highlighting for most languages
  :HerringtonDarkholme/yats.vim {} ; typescript syntax highlighting
  :mxw/vim-jsx {}
  ;:mattn/emmet-vim {}

  :purescript-contrib/purescript-vim {}


  :derekelkins/agda-vim {:ft ["agda"]}
  :neovimhaskell/haskell-vim { :ft ["haskell"]}

  :rust-lang/rust.vim {:ft ["rust"]
                       :requires ["mattn/webapi-vim"]}
  :simrat39/rust-tools.nvim {:ft ["rust"]}
  :ray-x/lsp_signature.nvim {}

  :bakpakin/fennel.vim {}
  :tjdevries/nlua.nvim {})
; >>>


; vim:foldmarker=<<<,>>>


