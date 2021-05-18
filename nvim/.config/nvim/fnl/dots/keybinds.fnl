(module dots.keybinds
  {autoload {a aniseed.core
             nvim aniseed.nvim
             utils dots.utils
             wk which-key
             treesitter-selection nvim-treesitter.incremental_selection}
   require-macros [macros]})

; undo autopairs fuckup    
(set vim.g.AutoPairsShortcutBackInsert "<M-b>")

(utils.keymap [:n] :<C-p> "<cmd>Telescope find_files<cr>")
(utils.keymap :n :K "<Nop>")
(utils.keymap :v :K "<Nop>")


(utils.keymap :n :MM "<cmd>lua require('nvim-gehzu').go_to_definition()<CR>" {})
(utils.keymap :n :MN "<cmd>lua require('nvim-gehzu').show_definition()<CR>" {})


(fn cmd [s desc] [(.. "<cmd>" s "<cr>") desc])
(fn rebind [s desc] [s desc])

(wk.setup {})
(wk.register 
 {"c" {:name "+comment out"}
  "e" {:name "+emmet"}

  "h" (cmd "bprevious"              "previous buffer")
  "l" (cmd "bnext"                  "next buffer")
  "o" (cmd "Telescope live_grep"    "Grep files")
  "p" (cmd "Telescope file_browser" "Open file-browser")
  ":" (cmd "Telescope commands"     "Search command with fzf")

  "m" {:name "+Code actions"
       "d" (cmd "Lspsaga hover_doc"                       "Show documentation") 
       "b" (cmd "Lspsaga lsp_finder"                      "Find stuff") 
       "x" (cmd "Lspsaga preview_definition"              "Preview definition") 
       "o" (cmd "SymbolsOutline"                          "Outline") 
       "S" (cmd "Telescope lsp_document_symbols"          "Symbols in document") 
       "s" (cmd "Telescope lsp_dynamic_workspace_symbols" "Symbols in workspace") 
       "t" (cmd "Lspsaga signature_help"                  "Show signature help") 
       "n" (cmd "Lspsaga rename"                          "Rename") 
       "v" (cmd "Lspsaga code_action"                     "Apply codeaction") 
       "A" (cmd "Lspsaga show_cursor_diagnostics"         "Cursor diagnostics") 
       "a" (cmd "Lspsaga show_line_diagnostics"           "Line diagnostics")
       "h" (cmd "RustToggleInlayHints"                    "Toggle inlay hints")
       "r" (cmd "Trouble lsp_references"                  "Show references") 
       "E" (cmd "Trouble lsp_document_diagnostics"        "List diagnostics")
       "e" (cmd "Trouble lsp_workspace_diagnostics"       "Show diagnostics")
       "g" [vim.lsp.buf.definition                        "Go to definition"] 
       "i" [vim.lsp.buf.implementation                    "Show implementation"] 
       "f" [vim.lsp.buf.formatting                        "format file"]}

  "f" {:name "+folds"
       "o" (cmd "foldopen"  "open fold") 
       "n" (cmd "foldclose" "close fold") 
       "j" (rebind "zj"     "jump to next fold") 
       "k" (rebind "zk"     "jump to previous fold")}
 
  "v" {:name "+view-and-layout"
       "n" (cmd "set relativenumber!"             "toggle relative numbers") 
       "m" (cmd "set nonumber! norelativenumber"  "toggle numbers") 
       "g" (cmd "Goyo | set linebreak"            "toggle focus mode") 
       "i" (cmd "IndentGuidesToggle"              "toggle indent guides")}

  "b" {:name "+buffers"
       "b" (cmd "Buffers"   "select open buffer")
       "c" (cmd "bdelete!"  "close open buffer")
       "w" (cmd "bwipeout!" "wipeout open buffer")}}

 {:prefix "<leader>"})

(wk.register
 {"<tab>" "which_key_ignore"
  "gss" "init selection"
  "z" {:name "+folds" 
       "c" (cmd "foldclose" "close fold")
       "o" (cmd "foldopen"  "open fold")}})

(wk.register
 {"<tab>" "which_key_ignore"}
 {:mode "i"})
           
(wk.register
 {:name "+Selection"
  "j" "increment selection"
  "k" "decrement selection"
  "l" "increment node"
  "h" "decrement node"}
 {:prefix "gs"
  :mode "v"})


(set nvim.o.timeoutlen 200)

