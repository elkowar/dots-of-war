nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>'WhichKeyVisual '<Space>'<CR>
let g:which_key_map = {}
call which_key#register('<Space>', "g:which_key_map")





      "\ 'h' : 'which_key_ignore', 'l' : 'which_key_ignore' ,
      "\ 'h' : ':bprevious', 'l' : ':bnext' ,
      "\ 'h' : [':BufferPrevious', 'prev buffer'], 'l' : [':BufferNext', 'next buffer'] ,
let g:which_key_map = {
      \ 'h' : [':bprevious', 'prev buffer'], 'l' : [':bnext', 'next buffer'],
      \ 'f' : 'which_key_ignore', 's': 'which_key_ignore' ,
      \ 'c' : { 'name': '+comment_out' },
      \ 'e' : { 'name': '+emmet' },
      \ '[' : ['<Plug>(YoinkPostPasteSwapBack)',    'Swap last paste backwards' ],
      \ ']' : ['<Plug>(YoinkPostPasteSwapForward)', 'Swap last paste backwards' ],
      \ ':' : [':Commands'                        , 'Search command with fzf'   ],
      \ 'z' : { 'name': '+folds', 'c': ['foldclose', 'close fold'],
                                \ 'o': ['foldopen',  'open fold'] ,
                                \ }
      \ }


" Maps for code actions
let g:which_key_map['m'] = {
      \ 'name' : '+Code-actions'               ,
      \ 'd' : [ ':call Show_documentation()'   , 'show documentation'    ] ,
      \ 's' : [ ':CocFzfList symbols'          , 'list symbols'          ] ,
      \ 'o' : [ ':CocFzfList outline'          , 'show outline'          ] ,
      \ 'c' : [ ':CocFzfList commands'         , 'show all coc-commands' ] ,
      \ 'g' : [ '<Plug>(coc-definition)'       , 'go to definition'      ] ,
      \ 't' : [ '<Plug>(coc-type-definition)'  , 'show type definition'  ] ,
      \ 'i' : [ '<Plug>(coc-implementation)'   , 'show implementation'   ] ,
      \ 'r' : [ '<Plug>(coc-references-used)'  , 'show references'       ] ,
      \ 'b' : [ '<Plug>(coc-refactor)'         , 'refactor'              ] ,
      \ 'n' : [ '<Plug>(coc-rename)'           , 'rename'                ] ,
      \ 'F' : [ '<Plug>(coc-format-selected)'  , 'format selection'      ] ,
      \ 'f' : [ '<Plug>(coc-format)'           , 'format file'           ] ,
      "\ 'v' : [ ':CocCommand actions.open'     , 'apply codeaction'      ] ,
      \ 'v' : [ '<Plug>(coc-codeaction-cursor)', 'apply codeaction'      ] ,
      \ 'V' : [ '<Plug>(coc-codeaction-line)'  , 'codeaction current line'] ,
      \ 'e' : [ ':CocList diagnostics'         , 'list all errors'       ] ,
      \ 'L' : [ '<Plug>(coc-diagnostic-next)'  , 'go to next error'      ] ,
      \ 'H' : [ '<Plug>(coc-diagnostic-prev)'  , 'go to prev error'      ] ,
      \ 'a' : [ '<Plug>(coc-diagnostic-info)'  , 'diagnostics info'      ] ,
      \ 'O' : [ '<Plug>(coc-openlink)'         , 'open link under cursor'      ] ,
      \}
 
let g:which_key_map['f'] = {
      \ 'name': '+folds',
      \ 'o': [ ':foldopen'  , 'open fold'             ] ,
      \ 'n': [ ':foldclose' , 'close fold'            ] ,
      \ 'j': [ 'zj'         , 'jump to next fold'     ] ,
      \ 'k': [ 'zk'         , 'jump to previous fold' ] ,
      \ }

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

 " :bwipeout! bdelete!
      "\ 'b' : ['BufferPick' ,   'select open buffer'  ] ,
      "\ 'c' : ['BufferClose',   'close open buffer'   ] ,
      "\ 'w' : ['BufferWipeout', 'wipeout open buffer' ] ,
let g:which_key_map['b'] = {
      \ 'name': '+buffers',
      \ 'b' : [':Buffers' ,   'select open buffer'  ] ,
      \ 'c' : [':bdelete!',   'close open buffer'   ] ,
      \ 'w' : [':bwipeout!', 'wipeout open buffer' ] ,
      \ }

let g:which_key_map['x'] = {
      \ 'name' : '+other',
      \ 'f' : ['NERDTreeToggle' ,  '<Ctrl+F> show file tree'],
      \ 'p' : ['FZF'            ,  '<Ctrl+p> search file (c-v/c-x to open in split)' ] ,
      \ 'h' : [':History:'      ,  'search command history'],
      \ 'c' : [':Commands'      ,  'search through commands'],
      \ 's' : ['OverCommandLine',  'Substitute with preview'],
      \ 'y' : [':CocFzfList yank', 'Show yank history']
      \ }

" CocList -A --normal yank needs :CocInstall coc-yank



"nnoremap <silent> m :<c-u>WhichKey 'm'<CR>
  autocmd! VimEnter * :unmap <space>ig
  autocmd! FileType which_key
  "autocmd! FileType which_key set laststatus=2 noshowmode noruler
    "\| autocmd! BufLeave <buffer> set laststatus=2 showmode ruler

set timeoutlen=200

