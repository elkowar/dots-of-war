(module init 
  {autoload {utils utils
             nvim aniseed.nvim
             a aniseed.core
             str aniseed.string
             fennel aniseed.fennel
             colors colors}
   require-macros [macros]})

(macro make-errors-epic [f]
  `(xpcall #,f #(a.println (fennel.traceback $1))))

(make-errors-epic (require "plugins"))

(make-errors-epic (require "plugins.lsp"))
(make-errors-epic (require "keybinds"))

; Basic setup --------------------------------------- foldstart

(vim-let mapleader "\\<Space>")
(vim-let maplocalleader ",")

(vim.cmd "filetype plugin indent on")
(vim.cmd "syntax on")

(set vim.o.showmode false)
(set vim.o.foldmethod "marker")
(set vim.o.undodir (.. vim.env.HOME "/.vim/undo-dir"))
(set vim.o.undofile true)
(set vim.o.shortmess (.. vim.o.shortmess "c")) ; Don't give completion messages like 'match 1 of 2' or 'The only match'
(set vim.o.hidden true)
(set vim.o.encoding "utf-8")
(set vim.o.number false)
(set vim.o.relativenumber false)
(set vim.o.compatible false)
(set vim.o.cursorline true)
(set vim.o.incsearch true)
(set vim.o.hlsearch true)
(set vim.o.inccommand "nosplit")
(set vim.o.signcolumn "yes")
(set vim.o.shiftwidth 2)
(set vim.o.tabstop 2)
(set vim.o.backspace "indent,eol,start")
(set vim.o.autoindent true)
(set vim.o.smartindent true)
(set vim.o.expandtab true)
(set vim.o.wrap false)
(set vim.o.completeopt "longest,menuone,noselect")
(set vim.o.laststatus 2)
(set vim.o.showmode true)
(set vim.o.splitbelow true)
(set vim.o.splitright true)
(set vim.o.mouse "a")
(set vim.o.shell "bash")
(set vim.o.background "dark")

(when (vim.fn.has "termguicolors")
  (set vim.o.termguicolors true))

(when (not (vim.fn.has "gui_running"))
  (set vim.o.t_Co 256))

(vim.cmd "colorscheme gruvbox")
(vim-let &t_ut "")

(vim.cmd "autocmd! BufReadPost *.hs :set shiftwidth=2)")
(vim.cmd "autocmd! FileType vim setlocal foldmethod=marker")

;Disables automatic commenting on newline)
(vim.cmd "autocmd! FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o") 
; Auto-close quickfix list when element is selected)
(vim.cmd "autocmd! FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>")

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

(vim.cmd "highlight link Function GruvboxGreen")


; foldend 

; Plugin config ----------------------- foldstart

(set vim.g.VM_leader "m") ; visual-multi leader


; rust.vim
(set vim.g.rust_clip_command "xclip -selection clipboard")
(set vim.g.rustfmt_autosave 1)

(set vim.g.conjure#client#fennel#aniseed#aniseed_module_prefix "aniseed.")
(set vim.g.vim_parinfer_filetypes ["carp" "fennel"])

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

; vim:foldmarker=foldstart,foldend
