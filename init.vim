" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|


set runtimepath^=~/coding/tmp/coc.nvim/

let g:vim_config_root = expand('<sfile>:p:h')
let $VIM_ROOT = g:vim_config_root

let g:vimspector_enable_mappings = 'HUMAN'

source $VIM_ROOT/plugins.vim


if &shell =~# 'fish$'
    set shell=bash
endif

let mapleader ="\<Space>"



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

" May cause problems!
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

set completeopt=longest,menuone " Enable autocompletion
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

let g:vim_parinfer_filetypes = ['carp']


let g:sneak#label = 1
nmap   <DEL> <Plug>Sneak_s
nmap <S-DEL> <Plug>Sneak_S
omap   <DEL> <Plug>Sneak_s
omap <S-DEL> <Plug>Sneak_S


" FZF showing previews
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

command! -bang -nargs=? -complete=dir HFiles
  \ call fzf#vim#files(<q-args>, {'source': 'ag --hidden --ignore .git -g ""'}, <bang>0)

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


nnoremap <silent> <C-p> :Files<CR>

"map <Leader>f <Plug>(easymotion-bd-f)
"map <Leader>s <Plug>(easymotion-overwin-f2)
"let g:EasyMotion_smartcase = 1

let g:signify_sign_add               = '▍'
let g:signify_sign_delete            = '▍'
let g:signify_sign_delete_first_line = '▍'
let g:signify_sign_change            = '▍'
let g:signify_sign_show_text = 0

hi SignifySignDelete cterm=NONE gui=NONE guifg='#fb4934'
hi SignifySignChange cterm=NONE gui=NONE guifg='#83a598'
hi SignifySignAdd    cterm=NONE gui=NONE guifg='#8ec07c'

" Airline -------------------------------------------------------------------------- {{{

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 0

function! AirlineInit()
  let g:airline_section_a = '
        \%#__accent#
        \%{airline#util#wrap(airline#parts#mode(),0)}
        \%#__restore__#
        \%{airline#util#append(airline#parts#iminsert(),0)}'
  let g:airline_section_b = ''
  let g:airline_section_c = '
        \%<%<
        \%#__accent_red#
        \%{airline#util#wrap(airline#parts#readonly(),0)}
        \%#__restore__#
        \%#__accent_bold#
        \%{airline#util#wrap(airline#extensions#coc#get_status(),0)}
        \%#__restore__#'

  let g:airline_section_y = ''
  let g:airline_section_z = '%4l% %3v'

  let g:airline_section_warning = '
        \%{airline#extensions#whitespace#check()}
        \%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

  let airline#extensions#coc#error_symbol = ''
  let airline#extensions#coc#warning_symbol = ''
  let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
  let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'
endfun
autocmd User AirlineAfterInit call AirlineInit()


let g:airline_theme='elkowars_gruvbox'

" update airline themes properly... idk why this is so weird
function! s:update_highlights()
  hi airline_tabfill ctermbg=NONE guibg=NONE
  hi airline_tablabel_right ctermbg=NONE guibg=NONE ctermfg=NONE guifg=NONE
endfunction
autocmd User AirlineAfterTheme call s:update_highlights()

" }}}


" Barbar --------------------------------------------------------------------------- {{{

if has('nvim')
  let bufferline = get(g:, 'bufferline', {})
  let bufferline.auto_hide = v:false
  let bufferline.animation = v:true
  let bufferline.icons = v:false

  let bufferline.icon_separator_active = ' '
  let bufferline.icon_separator_active = ' '
  "let bufferline.icon_separator_inactive = '▎'
  "let bufferline.icon_separator_inactive = '▎'
  let bufferline.icon_close_tab = '◆'
  let bufferline.icon_close_tab_modified = '●'
  let bufferline.maximum_padding = 1

  hi! BufferVisible  guibg='#282828' guifg='#282828'
  hi! BufferCurrent  guibg='#689d6a' guifg='#282828'
  hi! BufferInactive guibg='#3c3836' guifg='#282828'
  hi! BufferTabpageFill guibg='#282828' guifg='#282828'
  hi! BufferCurrentSign guibg='#689d6a' guifg='#689d6a'

  hi! BufferVisibleMod  guibg='#282828' guifg='#8ec07c'
  hi! BufferCurrentMod  guibg='#282828' guifg='#8ec07c'
  hi! BufferInactiveMod guibg='#3c3836' guifg='#8ec07c'
endif


" }}}

" }}}

" :: and _ as space ------------------------------------------------------------------- {{{

function RebindShit(newKey)
  let b:RemappedSpace={
        \ 'old': maparg("<Space>", "i"),
        \ 'cur': a:newKey
        \ }
  exe 'inoremap <buffer> <Space>' a:newKey
endfun

function! UnbindSpaceStuff()
  if get(b:, "RemappedSpace", {}) != {}
    exe 'iunmap <buffer> <Space>'
    if b:RemappedSpace['old'] != ""
      exe 'inoremap <buffer> <space>' b:RemappedSpace['old']
    endif
    unlet b:RemappedSpace
  endif
endfun

augroup UnmapSpaceStuff
  autocmd!
  autocmd InsertLeave * call UnbindSpaceStuff()
augroup END


nnoremap <Tab>j :call RebindShit("_")<CR>a
nnoremap <Tab>k :call RebindShit("::")<CR>a

inoremap <Tab>j <space><C-o>:call RebindShit("_")<CR>
inoremap <Tab>k <space><C-o>:call RebindShit("::")<CR>


nnoremap ö a


" }}}


source $VIM_ROOT/whichkeyConfig.vim
source $VIM_ROOT/lsp.vim

