hi link haskellOperators GruvboxAqua
hi link haskellImportKeywords GruvboxPurple


let g:vista_default_executive = 'coc'
let g:vista_sidebar_position = 'vertical topleft'
let g:vista_sidebar_width = '50'



au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces


let g:coc_global_extensions = [
      \ 'coc-yank', 'coc-vimlsp', 'coc-prettier', 'coc-eslint', 
      \ 'coc-diagnostic', 'coc-yaml', 'coc-tsserver', 
      \ 'coc-json', 'coc-go', 'coc-html', 'coc-css', 'coc-clangd',
      \ 'coc-actions'
      \ ]
" 'coc-rust-analyzer', 


" vim-jsx
autocmd! BufRead,BufNewFile *.tsx setlocal syntax=javascript.jsx


" make emmet behave well with JSX in JS and TS files
let g:user_emmet_settings = { 'javascript': { 'extends': 'jsx' }, 'typescript': { 'extends': 'tsx' }}
let g:user_emmet_mode='n'




" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" ? idk
"inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"



function! Show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


" Show all diagnostics.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction


" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
command! -nargs=0 Prettier :CocCommand prettier.formatFile

"Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

setlocal formatprg=floskell\ --style\ chris-done

set signcolumn=yes
set cmdheight=1
set updatetime=300

" maybe helps coc?
set nobackup
set nowritebackup


hi CocUnderline gui=undercurl term=undercurl
hi CocErrorHighlight ctermfg=red  guifg=#c4384b gui=undercurl term=undercurl
hi CocWarningHighlight ctermfg=yellow guifg=#c4ab39 gui=undercurl term=undercurl
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')


" Snippet stuff {{{


" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

" }}}



