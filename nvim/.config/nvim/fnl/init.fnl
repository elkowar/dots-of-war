(module init 
  {autoload {utils utils
             nvim aniseed.nvim
             a aniseed.core
             str aniseed.string
             colors colors
             gehzu nvim-gehzu}
   require-macros [macros]})

(macro make-errors-epic [f]
  `(xpcall #,f #(let [fennel# (require :aniseed.fennel)]
                  (a.println (fennel#.traceback $1)))))

(when (vim.fn.has "termguicolors")
  (se termguicolors true))


(make-errors-epic (require "plugins"))

(make-errors-epic (require "plugins.lsp"))
(make-errors-epic (require "keybinds"))


;(se runtimepath (.. vim.o.runtimepath ",/home/leon/coding/projects/kbd-vim"))

; TODO
;(make-errors-epic (require "smart-compe-conjure"))

; Basic setup --------------------------------------- foldstart

(vim-let mapleader "\\<Space>")
(vim-let maplocalleader ",")

(vim.cmd "filetype plugin indent on")
(vim.cmd "syntax on")

(se foldmethod "marker")
(se showmode false)
(se undodir (.. vim.env.HOME "/.vim/undo-dir"))
(se undofile true)
(set vim.bo.undofile true)
(se shortmess (.. vim.o.shortmess "c")) ; Don't give completion messages like 'match 1 of 2' or 'The only match'
(se hidden true)
(se encoding "utf-8")
(se number false)
(se relativenumber false)
(se compatible false)
(se cursorline true)
(se incsearch true)
(se hlsearch true)
(se inccommand "nosplit")
(se signcolumn "yes")
(se shiftwidth 2)
(se tabstop 2)
(se backspace "indent,eol,start")
(se autoindent true)
(se smartindent true)
(se expandtab true)
(se wrap false)
(se completeopt "menuone,noselect")
(se laststatus 2)
(se splitbelow true)
(se splitright true)
(se mouse "a")
(se shell "bash")
(se background "dark")
(se swapfile false)
(se undolevels 10000)

(vim-let &t_ut "")

(vim.cmd "autocmd! BufReadPost *.hs :set shiftwidth=2")
(vim.cmd "autocmd! FileType vim setlocal foldmethod=marker")

;Disables automatic commenting on newline)
(vim.cmd "autocmd! FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o") 
; Auto-close quickfix list when element is selected)
(vim.cmd "autocmd! FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>")

(vim.cmd "autocmd! TextYankPost * silent! lua vim.highlight.on_yank {higroup=\"IncSearch\", timeout=300}")




; foldend

; Colors  ------------------------------------------------------- foldstart

(utils.highlight-add 
 ["GruvboxBlueSign" "GruvboxAquaSign" "GruvboxRedSign" "GruvboxYellowSign" "GruvboxGreenSign" "GruvboxOrangeSign" "GruvboxPurpleSign"] 
 {:bg "NONE"})

; hide empty line ~'s
(utils.highlight :EndOfBuffer {:bg "NONE" :fg colors.dark0})
(utils.highlight :LineNr {:bg "NONE"})

(utils.highlight-add :Pmenu {:bg colors.dark0_hard})
(utils.highlight-add :PmenuSel {:bg colors.bright_aqua})
(utils.highlight-add :PmenuSbar {:bg colors.dark0_hard})
(utils.highlight-add :PmenuThumb {:bg colors.dark1})
(utils.highlight-add :NormalFloat {:bg colors.dark0_hard})
(utils.highlight-add :SignColumn {:bg colors.dark0})

(utils.highlight-add :FloatBorder {:bg colors.dark0_hard})


(utils.highlight ["StatusLine" "GalaxyLineInfo" "GalaxySpace" ] {:bg colors.dark1 :fg colors.light0})

(vim.cmd "highlight link Function GruvboxGreen")


; foldend 

; Plugin config ----------------------- foldstart

(set vim.g.VM_leader "m") ; visual-multi leader


; rust.vim
(set vim.g.rust_clip_command "xclip -selection clipboard")
(set vim.g.rustfmt_autosave 1)

(set vim.g.conjure#client#fennel#aniseed#aniseed_module_prefix "aniseed.")
(set vim.g.vim_parinfer_filetypes ["carp" "fennel" "clojure"])

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

; :: autoclose empty unnamed buffers ----------------------------------------------- foldstart


(fn _G.clean_no_name_empty_buffers []
  (let [bufs (a.filter #(and (a.empty? (vim.fn.bufname $1))
                             (< (vim.fn.bufwinnr $1) 0)
                             (vim.api.nvim_buf_is_loaded $1)
                             (= "" (str.join (utils.buffer-content $1)))
                             (vim.api.nvim_buf_get_option $1 "buflisted"))
                       (vim.fn.range 1 (vim.api.nvim_buf_get_number "$")))]
    (when (not (a.empty? bufs))
      (vim.cmd (.. "bdelete " (str.join " " bufs))))))

(vim.cmd "autocmd! BufCreate * :call v:lua.clean_no_name_empty_buffers()")

; foldend



(vim.cmd
  "command! -nargs=1 L :lua print(vim.inspect(<args>))")

; vim:foldmarker=foldstart,foldend
