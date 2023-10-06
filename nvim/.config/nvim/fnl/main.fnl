(import-macros {: vim-let} :macros)

(local {: autoload} (require :nfnl.module))
(local a (autoload :aniseed.core))
(local str (autoload :aniseed.string))
(local utils (autoload :dots.utils))
(local lazy (require :lazy))

(utils.clear-deferred)

;(macro make-errors-epic [f]
;  `(xpcall #,f #(let [fennel# (require :aniseed.fennel)]
;                  (a.println (fennel#.traceback $1)))))
(macro make-errors-epic [f]
  f)

(when (vim.fn.has "termguicolors")
  (set vim.opt.termguicolors true))

;(make-errors-epic (require "dots.plugins"))

(vim-let mapleader "\\<Space>")
(vim-let maplocalleader ",")

(lazy.setup {:import "dots.plugins" :install {:colorscheme "gruvbox8"}})

; (require "impatient")

(make-errors-epic (require "dots.plugins.lsp"))
(make-errors-epic (require "dots.keybinds"))

; add to runtimepath
(let [added-paths []]
  (set vim.opt.runtimepath (.. vim.o.runtimepath (str.join "," added-paths))))

; Basic setup --------------------------------------- foldstart


(vim.cmd "filetype plugin indent on")
(vim.cmd "syntax on")

(set vim.opt.foldmethod "marker")
(set vim.opt.scrolloff 5)
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
(set vim.opt.keywordprg "rusty-man")

(set vim.g.AutoPairsMultilineClose 0)

(vim-let &t_ut "")

(vim.api.nvim_create_autocmd "BufWritePost" {:pattern "*.hs" :callback #(set vim.opt.shiftwidth 2)})
(vim.api.nvim_create_autocmd "FileType" {:pattern "vim" :callback #(set vim.opt_local.foldmethod "marker")})

;Disables automatic commenting on newline)
(vim.api.nvim_create_autocmd "FileType"
                             {:pattern "*"
                              :callback #(set vim.opt_local.formatoptions (vim.o.formatoptions:gsub "[cor]" ""))})
          
; Auto-close quickfix list when element is selected)
(vim.api.nvim_create_autocmd "FileType"
                             {:pattern "qf"
                              :callback #(vim.cmd "nnoremap <buffer> <CR> <CR>:cclose<CR>")})
(vim.api.nvim_create_autocmd "TextYankPost"
                             {:pattern "*"
                              :callback #(vim.highlight.on_yank {:higroup "IncSearch" :timeout 300})})


(set vim.g.copilot_filetypes {:TelescopePrompt false}) 


; foldend

; Colors  ------------------------------------------------------- foldstart




; foldend 

(vim.diagnostic.config
  {:float {:border "single"
           :style "minimal"}})

; Plugin config ----------------------- foldstart


(set vim.g.VM_leader "m") ; visual-multi leader

; rust.vim
(set vim.g.rust_clip_command "xclip -selection clipboard")
;(set vim.g.rustfmt_autosave 1)

(set vim.g.conjure#client#fennel#aniseed#aniseed_module_prefix "aniseed.")
(set vim.g.vim_parinfer_filetypes ["carp" "fennel" "clojure"])
(set vim.g.parinfer_additional_filetypes ["yuck"])

; foldend


; :: autoclose empty unnamed buffers ----------------------------------------------- foldstart


(fn _G.clean_no_name_empty_buffers []
  (let [bufs (a.filter #(and (a.empty? (vim.fn.bufname $1))
                             (< (vim.fn.bufwinnr $1) 0)
                             (vim.api.nvim_buf_is_loaded $1)
                             (= "" (str.join (utils.buffer-content $1)))
                             (vim.api.nvim_buf_get_option $1 "buflisted"))
                       (vim.fn.range 1 (vim.fn.bufnr "$")))]
    (when (not (a.empty? bufs))
      (vim.cmd (.. "bdelete " (str.join " " bufs))))))

(vim.cmd "autocmd! BufCreate * :call v:lua.clean_no_name_empty_buffers()")

; foldend

(vim.cmd
  "command! -nargs=1 L :lua print(vim.inspect(<args>))")

; (vim.cmd "Copilot enable")

(utils.run-deferred)

; vim:foldmarker=foldstart,foldend
