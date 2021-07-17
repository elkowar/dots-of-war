(module init 
  {autoload {utils dots.utils
             nvim aniseed.nvim
             a aniseed.core
             str aniseed.string
             colors dots.colors}
   require-macros [macros]})

(macro make-errors-epic [f]
  `(xpcall #,f #(let [fennel# (require :aniseed.fennel)]
                  (a.println (fennel#.traceback $1)))))

(when (vim.fn.has "termguicolors")
  (set vim.opt.termguicolors true))

(make-errors-epic (require "dots.plugins"))

(make-errors-epic (require "dots.plugins.lsp"))
(make-errors-epic (require "dots.keybinds"))


;(set vim.opt.runtimepath (.. vim.o.runtimepath ",/home/leon/coding/projects/kbd-vim"))

; TODO
;(make-errors-epic (require "smart-compe-conjure"))

; Basic setup --------------------------------------- foldstart

(vim-let mapleader "\\<Space>")
(vim-let maplocalleader ",")

(vim.cmd "filetype plugin indent on")
(vim.cmd "syntax on")

(set vim.opt.foldmethod "marker")
(set vim.opt.showmode false)
(set vim.opt.undodir (.. vim.env.HOME "/.vim/undo-dir"))
(set vim.opt.undofile true)
(set vim.opt.shortmess (.. vim.o.shortmess "c")) ; Don't give completion messages like 'match 1 of 2' or 'The only match'
(set vim.opt.hidden true)
(set vim.opt.encoding "utf-8")
(set vim.opt.number false)
(set vim.opt.relativenumber false)
(set vim.opt.compatible false)
(set vim.opt.cursorline true)
(set vim.opt.incsearch true)
(set vim.opt.hlsearch true)
(set vim.opt.inccommand "nosplit")
(set vim.opt.signcolumn "yes")
(set vim.opt.shiftwidth 2)
(set vim.opt.tabstop 2)
(set vim.opt.backspace "indent,eol,start")
(set vim.opt.autoindent true)
(set vim.opt.smartindent true)
(set vim.opt.expandtab true)
(set vim.opt.wrap false)
(set vim.opt.completeopt "menuone,noselect")
(set vim.opt.laststatus 2)
(set vim.opt.splitbelow true)
(set vim.opt.splitright true)
(set vim.opt.mouse "a")
(set vim.opt.shell "bash")
(set vim.opt.background "dark")
(set vim.opt.swapfile false)
(set vim.opt.undolevels 10000)

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
(utils.highlight-add :SpecialComment {:fg colors.dark4})


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
