" symlink this to ~/.vim/plugged/vim-airline-themes/autoload/airline/themes/elkowars_gruvbox.vim
let g:airline#themes#elkowars_gruvbox#palette = {}

let s:gui_bg0     = "#1d2021"
let s:gui_bg1     = "#282828"
let s:gui_bg2     = "#3c3836"
let s:gui_bg3     = "#504945"
let s:gui_bg4     = "#665c54"
let s:gui_fg1     = "#ebdbb2"
let s:gui_fg2     = "#fbf1c7"
let s:gui_red     = "#fb4934"
let s:gui_orange  = "#fe8019"
let s:gui_yellow  = "#fabd2f"
let s:gui_green   = "#b8bb26"
let s:gui_cyan    = "#689d6a"
let s:gui_blue    = "#83a598"
let s:gui_pink    = "#d3869b"
let s:gui_orange2 = "#d65d0e"

let s:cterm_bg1     = 234
let s:cterm_bg2     = 235
let s:cterm_bg3     = 236
let s:cterm_bg4     = 240
let s:cterm_fg1     = 223
let s:cterm_fg2     = 230
let s:cterm_red     = 203
let s:cterm_orange  = 208
let s:cterm_yellow  = 214
let s:cterm_green   = 142
let s:cterm_cyan    = 108
let s:cterm_blue    = 108
let s:cterm_pink    = 175
let s:cterm_orange2 = 166



let s:N1 = [ s:gui_bg2,   s:gui_cyan,  s:cterm_bg1,     s:cterm_cyan ]
let s:N2 = [ s:gui_fg1,   s:gui_bg3,   s:cterm_fg1,     s:cterm_bg3 ]
let s:N3 = [ s:gui_cyan,  s:gui_bg2,   s:cterm_orange,  s:cterm_bg2 ]
"                               ^ is for background in statusline
let s:I1 = [ s:gui_bg2,  s:gui_yellow,  s:cterm_bg2,  s:cterm_yellow ]
let s:V1 = [ s:gui_bg2,  s:gui_orange2,  s:cterm_bg2,  s:cterm_orange ]
let s:R1 = [ s:gui_bg2,  s:gui_green,   s:cterm_bg2,  s:cterm_green ]

"let s:N1 = [ s:gui_cyan,   s:gui_bg1,  s:cterm_bg1,     s:cterm_cyan ]
"let s:N2 = [ s:gui_fg1,   s:gui_bg3,   s:cterm_fg1,     s:cterm_bg3 ]
"let s:N3 = [ s:gui_cyan,  s:gui_bg1,   s:cterm_orange,  s:cterm_bg2 ]
""                               ^ is for background in statusline
"let s:I1 = [ s:gui_yellow,   s:gui_bg1,     s:cterm_bg2,  s:cterm_yellow ]
"let s:V1 = [ s:gui_orange2,  s:gui_bg1,     s:cterm_bg2,  s:cterm_orange ]
"let s:R1 = [ s:gui_bg2,      s:gui_green,   s:cterm_bg2,  s:cterm_green ]

let g:airline#themes#elkowars_gruvbox#palette.normal   = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#elkowars_gruvbox#palette.insert   = airline#themes#generate_color_map(s:I1, s:N2, s:N3)
let g:airline#themes#elkowars_gruvbox#palette.replace  = airline#themes#generate_color_map(s:R1, s:N2, s:N3)
let g:airline#themes#elkowars_gruvbox#palette.visual   = airline#themes#generate_color_map(s:V1, s:N2, s:N3)
let g:airline#themes#elkowars_gruvbox#palette.inactive = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

