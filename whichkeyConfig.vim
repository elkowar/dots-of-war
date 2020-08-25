nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>'WhichKeyVisual '<Space>'<CR>
let g:which_key_map = {}
call which_key#register('<Space>', "g:which_key_map")

let g:which_key_map = {
      \ 'h' : 'which_key_ignore', 'l' : 'which_key_ignore',
      \ 'f' : 'which_key_ignore', 's': 'which_key_ignore' ,
      \ 'c' : { 'name': '+comment_out' },
      \ 'e' : { 'name': '+emmet' },
      \ 'z' : { 'name': '+folds', 'c': ['foldclose', 'close fold'],
                                \ 'o': ['foldopen', 'open fold'] ,
                                \ }
      \ }


" Maps for code actions
let g:which_key_map['m'] = {
      \ 'name' : '+Code-actions'               ,
      \ 'd' : [ ':call Show_documentation()'   , 'show documentation'    ] ,
      \ 's' : [ ':CocList -I symbols'          , 'list symbols'          ] ,
      \ 'o' : [ ':CocList outline'             , 'show outline'          ] ,
      \ 'c' : [ ':CocList commands'            , 'show all coc-commands' ] ,
      \ 'g' : [ '<Plug>(coc-definition)'       , 'go to definition'      ] ,
      \ 't' : [ '<Plug>(coc-type-definition)'  , 'show type definition'  ] ,
      \ 'i' : [ '<Plug>(coc-implementation)'   , 'show implementation'   ] ,
      \ 'r' : [ '<Plug>(coc-references)'       , 'show references'       ] ,
      \ 'n' : [ '<Plug>(coc-rename)'           , 'rename'                ] ,
      \ 'F' : [ '<Plug>(coc-format-selected)'  , 'format selection'      ] ,
      \ 'f' : [ '<Plug>(coc-format)'           , 'format file'           ] ,
      \ 'v' : [ '<Plug>(coc-codeaction)'       , 'apply codeaction'      ] ,
      \ 'V' : [ '<Plug>(coc-fix-current)'      , 'apply quickfix'        ] ,
      \ 'e' : [ ':CocList diagnostics'         , 'list all errors'       ] ,
      \ 'L' : [ '<Plug>(coc-diagnostics-next)' , 'go to next error'      ] ,
      \ 'H' : [ '<Plug>(coc-diagnostics-prev)' , 'go to prev error'      ] ,
      \}


let g:which_key_map['a'] = {
      \ 'name': '+Bookmarks',
      \ ' ' : ['<Plug>(coc-bookmark-toggle)'              , 'toggle bookmark'        ] ,
      \ 'a' : ['<Plug>(coc-bookmark-annotate)'            , 'annotate bookmark'      ] ,
      \ 'j' : ['<Plug>(coc-bookmark-next)'                , 'next bookmark'          ] ,
      \ 'k' : ['<Plug>(coc-bookmark-prev)'                , 'prev bookmark'          ] ,
      \ 'l' : [':CocList bookmark'                        , 'list bookmarks'         ] ,
      \ 'c' : [':CocCommand bookmark.clearForCurrentFile' , 'clear for current file' ] ,
      \ 'C' : [':CocCommand bookmark.clearForAllFiles'    , 'clear for all files'    ]
      \}

" mappings for view and layout
let g:which_key_map['v'] = {
      \ 'name' : '+view-and-layout',
      \ 'n' : [':set relativenumber!'            , 'toggle relative numbers' ] ,
      \ 'm' : [':set nonumber! norelativenumber' , 'toggle numbers'] ,
      \ 'g' : [':Goyo | set linebreak'           , 'toggle focus mode'    ] ,
      \ 'i' : [':IndentGuidesToggle'             , 'toggle indent guides' ] ,
      \ }

let g:which_key_map['b'] = {
      \ 'name': '+buffers'  ,
      \ 'o' : ['Buffers'    ,  'select open buffer'  ] ,
      \ 'c' : [':bdelete!'  ,  'close open buffer'   ] ,
      \ 'w' : [':bwipeout!' ,  'wipeout open buffer' ] ,
      \ }

let g:which_key_map['x'] = {
      \ 'name' : '+other',
      \ 'f' : ['NERDTreeToggle' ,  '<Ctrl+F> show file tree'],
      \ 'p' : ['FZF'            ,  '<Ctrl+p> search file (c-v/c-x to open in split)' ] ,
      \ 'h' : [':History:'      ,  'search command history'],
      \ 'c' : [':Commands'      ,  'search through commands'],
      \ 's' : ['OverCommandLine',  'Substitute with preview'],
      \ 'y' : [':CocList -A --normal yank', 'Show yank history']
      \ }

" CocList -A --normal yank needs :CocInstall coc-yank



"nnoremap <silent> m :<c-u>WhichKey 'm'<CR>
  autocmd! VimEnter * :unmap <space>ig
  autocmd! FileType which_key
  autocmd! FileType which_key set laststatus=2 noshowmode noruler
    \| autocmd! BufLeave <buffer> set laststatus=2 showmode ruler

set timeoutlen=200

