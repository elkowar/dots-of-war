" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|


"set runtimepath^=~/coding/tmp/coc.nvim/

let g:vim_config_root = expand('<sfile>:p:h')
let $VIM_ROOT = g:vim_config_root

luafile $VIM_ROOT/plugins.lua

if &shell =~# 'fish$'
    set shell=bash
endif

let mapleader ="\<Space>"
let maplocalleader = "m"



" Vanilla VIM configuration ------------------------------------ {{{

filetype plugin indent on
syntax on

set noshowmode " mode is already shown in airline
set foldmethod=marker
set undodir=~/.vim/undo-dir
set undofile
set shortmess+=c " Don't give completion messages like 'match 1 of 2' or 'The only match'
set hidden
set encoding=utf-8
set nonumber norelativenumber
set nocompatible
set cursorline
set incsearch
set hlsearch
set inccommand=nosplit
set signcolumn=yes

if (has("termguicolors"))
  set termguicolors
endif

" Indentation
set shiftwidth=2
set tabstop=2
set backspace=indent,eol,start
set autoindent smartindent noet expandtab
set nowrap
set noshowmode " hide the mode as shown by vim, because the status line does it better!

set completeopt=longest,menuone,noselect " Enable autocompletion
set laststatus=2
set noshowmode



set background=dark
colorscheme gruvbox
let g:onedark_terminal_italics=1
hi LineNr ctermbg=NONE guibg=NONE
hi Comment cterm=italic
let &t_ut=''



" hide empty line ~'s
highlight EndOfBuffer ctermfg=black ctermbg=black guibg=NONE guifg='#282828'


hi Pmenu ctermbg=black guibg='#1d2021'
hi PmenuSel guibg='#8ec07c'
hi PmenuSbar guibg='#1d2021'
hi PmenuThumb guibg='#3c3836'

hi WhichKeyFloating ctermbg=black guibg='#282828'

hi NormalFloat ctermbg=black guibg='#1d2021'
hi SignColumn ctermbg=NONE guibg='#282828'
hi link Function GruvboxGreen


if !has("nvim")
  set term=xterm-256color
endif

" Clipboard support in WSL
func! GetSelectedText()
    normal gv"xy
    let result = getreg("x")
    return result
endfunc

if !has("clipboard") && executable("clip.exe")
    vnoremap <C-C> :call system('clip.exe', GetSelectedText())<CR>
    vnoremap <C-X> :call system('clip.exe', GetSelectedText())<CR>gvx
endif


" Mouse config
set mouse=a
if !has("nvim")
  if has("mouse_sgr")
    set ttymouse=sgr
  else
    set ttymouse=xterm2
  end
end

if !has('gui_running')
  set t_Co=256
endif

augroup basics
  autocmd!
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o  "Disables automatic commenting on newline:
  autocmd FileType vim setlocal foldmethod=marker

  " file type assignments
  autocmd BufRead,BufNewFile *.ddl setlocal filetype=sql


  " Auto-close quickfix list when element 
  autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>

augroup END



" autoclose empty unedited buffers
function! CleanNoNameEmptyBuffers()
    let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val) < 0 && (getbufline(v:val, 1, "$") == [""])')
    if !empty(buffers)
        exe 'bd '.join(buffers, ' ')
    else
        echo 'No buffer deleted'
    endif
endfunction

autocmd BufCreate * execute 'call CleanNoNameEmptyBuffers()'

" this nearly works, and does the same 

" ; autoclose empty unedited buffers
" (fn _G.clean_no_name_empty_buffers []
"   (local bufs
"     (a.filter
"       #(and 
"         (vim.api.nvim_buf_get_option $1 "buflisted")
"         (a.empty? (vim.fn.bufname $1))
"         (< (vim.fn.bufwinnr $1) 0)
"         (vim.api.nvim_buf_is_loaded $1))
"         ;(do (utils.dbg (.. (fennel.view $1) " -> " (fennel.view (vim.api.nvim_buf_is_loaded $1))) true)))
"         ;(a.empty? (vim.api.nvim_buf_get_lines $1 1 (vim.api.nvim_buf_line_count $1) false)))
"       (vim.fn.range 1 (vim.fn.bufnr "$"))))
"   (when (not (a.empty? bufs))
"     (nvim.command (.. "bd " (str.join " " bufs)))))
" 
" (nvim.command "autocmd! BufCreate * :call v:lua.clean_no_name_empty_buffers()")
" 
" ; autocmd BufCreate * execute 'call CleanNoNameEmptyBuffers()'





" ===============
" Basic remapping
" ===============

" Split configs
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow splitright

" Buffer switching
"noremap <silent> <leader>l :bnext<CR>
"noremap <silent> <leader>h :bprevious<CR>

" Disable default K mapping (would open man page of hovered word)
nnoremap K <Nop>
vnoremap K <Nop>


" }}}

" Plugin configuration --------------------------------------------------- {{{

let g:VM_leader = 'm'

autocmd BufReadPost * :DetectIndent
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 2

autocmd BufReadPost *.hs :set shiftwidth=2

let g:vim_parinfer_filetypes = ['carp', 'fennel']


let g:sneak#label = 1
nmap   <DEL> <Plug>Sneak_s
nmap <S-DEL> <Plug>Sneak_S
omap   <DEL> <Plug>Sneak_s
omap <S-DEL> <Plug>Sneak_S


let g:rust_clip_command = 'xclip -selection clipboard'
let g:rustfmt_autosave = 1

let g:user_emmet_leader_key='<leader>e'
let g:user_emmet_settings = { 'javascript.jsx' : { 'extends' : 'jsx' }, 'typescript.jsx' : { 'extends' : 'jsx' } }

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_lazy_highlight = 1



au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces



"map <Leader>f <Plug>(easymotion-bd-f)
"map <Leader>s <Plug>(easymotion-overwin-f2)
"let g:EasyMotion_smartcase = 1

let g:signify_sign_add               = '▍'
let g:signify_sign_delete            = '▍'
let g:signify_sign_delete_first_line = '▍'
let g:signify_sign_change            = '▍'
"let g:signify_sign_show_text = 0

hi SignifySignDelete cterm=NONE gui=NONE guifg='#fb4934'
hi SignifySignChange cterm=NONE gui=NONE guifg='#83a598'
hi SignifySignAdd    cterm=NONE gui=NONE guifg='#8ec07c'

" }}}

" }}}


" how 2 highlight group at cursor
":exe 'hi '.synIDattr(synID(line("."), col("."), 0),"name")

"source $VIM_ROOT/whichkeyConfig.vim

let g:aniseed#env = v:true
"let g:aniseed#env = { "compile": v:false }

"let g:lexima_no_default_rules = v:true
"call lexima#set_default_rules()
