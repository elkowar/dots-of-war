if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')

  Plug 'Olical/aniseed', { 'tag': 'v3.16.0' }
  Plug 'bakpakin/fennel.vim'

  " general purpose lua wrappers for nvim stuff
  Plug 'norcalli/nvim.lua'

  Plug 'tweekmonster/startuptime.vim'
  Plug 'tpope/vim-repeat'

  Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
  "Plug 'osyo-manga/vim-over', {'on': 'OverCommandLine'} " Substitute preview

  Plug 'liuchengxu/vim-which-key'

  if has('nvim') || has('patch-8.0.902')
    Plug 'mhinz/vim-signify'
  else
    Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
  endif

  Plug 'tpope/vim-fugitive'

  Plug 'preservim/nerdcommenter'

  Plug 'vim-airline/vim-airline-themes'
  Plug 'vim-airline/vim-airline'

  " buffer line
  if has('nvim')
    "Plug 'romgrk/barbar.nvim'
  endif

  "Plug 'morhetz/gruvbox'
  Plug 'gruvbox-community/gruvbox'

  Plug 'godlygeek/tabular'               " :Tab /regex can align code on occurrences of the given regex. I.e. :Tab /= aligns all = signs in a block.
  Plug 'tpope/vim-surround'

  "Plug 'easymotion/vim-easymotion'       " press <leader>f [somekey] to have quick-movement to any occurrence of the key
  Plug 'christoomey/vim-tmux-navigator'  " good integration with tmux pane switching
  Plug 'nathanaelkane/vim-indent-guides' " Can be toggled using <leader>ig (intent-guides)

  " <C-n> to select current word. <C-n> to select next occurrence.
  " with multiple lines selected in Visual mode, <C-n> to insert cursor in each line. I not i to insert in Visual-mode.
  "Plug 'terryma/vim-multiple-cursors'
  Plug 'mg979/vim-visual-multi'
  Plug 'hauleth/sad.vim'          " Use siw instead of ciw. when using . afterwards, will find the next occurrence of the changed word and change it too
  Plug 'wellle/targets.vim'       " more text objects. IE: cin) (change in next parens). generally better handling of surrounding objects.
  "Plug 'haya14busa/incsearch.vim' " Show search result-highlights whilst typing the query

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy file opener, use: :FZF or :FZF! for fullscreen
  Plug 'junegunn/fzf.vim'

  Plug 'unblevable/quick-scope'   " highlight targets when pressing f<character>
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } } " :MarkdownPreview for live markdown preview

  "Plug 'jiangmiao/auto-pairs'

  Plug 'machakann/vim-highlightedyank'

  Plug 'ciaranm/detectindent'
  Plug 'pechorin/any-jump.vim'
  Plug 'justinmk/vim-sneak'
  Plug 'psliwka/vim-smoothie'

  Plug 'editorconfig/editorconfig-vim'


  Plug 'honza/vim-snippets'

  Plug 'liuchengxu/vista.vim'

  Plug 'antoinemadec/coc-fzf'

  Plug 'tommcdo/vim-exchange'

  if !has('nvim')
    Plug 'puremourning/vimspector'
  endif

  Plug 'svermeulen/vim-yoink'

  Plug 'Shougo/echodoc.vim'
  Plug 'kien/rainbow_parentheses.vim'

  Plug 'bhurlow/vim-parinfer'

  Plug 'Olical/conjure', {'tag': 'v4.17.0'}


  " Language Plugins ----------------------------------------------------- {{{

  Plug 'ziglang/zig.vim'
  Plug 'bduggan/vim-raku'
  Plug 'LnL7/vim-nix'

  Plug 'kevinoid/vim-jsonc'

  Plug 'ap/vim-css-color'
  Plug 'pangloss/vim-javascript' " syntax highlighting JS
  Plug 'ianks/vim-tsx'
  Plug 'leafgarland/typescript-vim'
  Plug 'sheerun/vim-polyglot'    " Syntax highlighting for most languages
  "Plug 'mattn/emmet-vim'

  Plug 'udalov/kotlin-vim'

  Plug 'purescript-contrib/purescript-vim'

  Plug 'HerringtonDarkholme/yats.vim' " typescript syntax highlighting
  Plug 'mxw/vim-jsx'

  "" Haskell
  Plug 'neovimhaskell/haskell-vim'
  Plug 'Twinside/vim-hoogle', {'on': 'Hoogle'}

  " Rust
  Plug 'rust-lang/rust.vim'
  Plug 'mattn/webapi-vim'


  "Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'thyrgle/vim-dyon'

  Plug 'bakpakin/fennel.vim'

  Plug 'tjdevries/nlua.nvim'
  Plug 'nvim-lua/completion-nvim'

  "Plug 'mxw/vim-prolog'


  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-compe'
  Plug 'glepnir/lspsaga.nvim'
  Plug 'cohama/lexima.vim'

  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'

  Plug 'RishabhRD/popfix'
  Plug 'RishabhRD/nvim-lsputils'

  Plug 'nvim-telescope/telescope-media-files.nvim'

  " }}}
call plug#end()

