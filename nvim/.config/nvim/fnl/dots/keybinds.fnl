(module dots.keybinds
  {autoload {a aniseed.core
             str aniseed.string
             nvim aniseed.nvim
             utils dots.utils
             wk which-key
             treesitter-selection nvim-treesitter.incremental_selection
             lspactions lspactions}
   require-macros [macros]})

; undo autopairs fuckup    
(set vim.g.AutoPairsShortcutBackInsert "<M-b>")

(utils.keymap [:n] :<C-p> "<cmd>Telescope file_browser<cr>")
(utils.keymap :n :K "<Nop>")
(utils.keymap :v :K "<Nop>")

(utils.keymap :i "" "<C-w>")
(utils.keymap :i :<C-h> "<C-w>")
(utils.keymap :i :<C-BS> "<C-w>")

(utils.keymap :n :MM "<cmd>lua require('nvim-gehzu').go_to_definition()<CR>" {})
(utils.keymap :n :MN "<cmd>lua require('nvim-gehzu').show_definition()<CR>" {})

(utils.keymap :n :zt "zt<c-y><c-y><c-y>")
(utils.keymap :n :zb "zb<c-e><c-e><c-e>")

; these should really not be necessary, but whatever...
(utils.keymap :n :<space>c<space> "<cmd>call nerdcommenter#Comment(\"m\", \"Toggle\")<CR>" {})
(utils.keymap :v :<space>c<space> "<cmd>call nerdcommenter#Comment(\"x\", \"Toggle\")<CR>" {})

; Fix keybinds in linewrapped mode
;(utils.keymap [:n] :j "gj")
;(utils.keymap [:n] :k "gk")

(defn open-selection-zotero []
  (let [(_ _ sel) (utils.get-selection)]
    (vim.cmd (.. "silent !xdg-open zotero://select/items/@" (str.join sel)))))


(fn cmd [s desc] [(.. "<cmd>" s "<cr>") desc])
(fn sel-cmd [s desc] [(.. "<cmd>'<,'>" s "<cr>") desc])
(fn rebind [s desc] [s desc])


(defn format []
  (if (a.some #$1.server_capabilities.documentFormattingProvider (vim.lsp.get_active_clients))
    (vim.lsp.buf.format {:async true})
    (vim.cmd "Neoformat")))



(wk.setup {})
(wk.register 
 {"c" {:name "+comment out"}
  "e" {:name "+emmet"}

  "h" (cmd "bprevious"              "previous buffer")
  "l" (cmd "bnext"                  "next buffer")
  "o" (cmd "Telescope live_grep"    "Grep files")
  "P" (cmd "Telescope frecency frecency default_text=:CWD:"     "Frecency magic")
  "p" (cmd "Telescope find_files"   "Open file-browser")
  ":" (cmd "Telescope commands"     "Search command with fzf")
  "s" (cmd "w"                      "Save file")
  "g" (cmd "Neogit"                 "Git")

  "n" [(. (require :persistence) :load) "Load last session"]

  "d" {:name "+Debugging"
       "b" [#(req dap.toggle_breakpoint)    "toggle breakpoint"]
       "u" [#(req dapui.toggle)             "toggle dapui"]
       "c" [#(req dap.step_into)            "continue"]
       "r" [(. (require "dap") :repl :open) "open repl"]
       "s" {:name "+Step"
            "o" [#(req dap.step_over)       "over"]
            "u" [#(req dap.step_out)        "out"]
            "i" [#(req dap.step_into)       "into"]}}

  "m" {:name "+Code actions"
       ";" [#(set vim.o.spell (not vim.o.spell))          "Toggle spell checking"]
       "d" [vim.lsp.buf.hover                             "Show documentation"] 
       "o" (cmd "SymbolsOutline"                          "Outline") 
       "S" (cmd "Telescope lsp_document_symbols"          "Symbols in document") 
       "s" (cmd "Telescope lsp_dynamic_workspace_symbols" "Symbols in workspace") 
       "T" [vim.lsp.buf.signature_help                    "Show signature help"] 
       "n" (cmd "IncRename "                              "Rename") 
       "v" (cmd "CodeActionMenu"                          "Apply codeaction") 
       "A" [#(vim.diagnostic.open_float {:scope :cursor}) "Cursor diagnostics"] 
       "a" [#(vim.diagnostic.open_float {})               "Line diagnostics"] 
       "h" (cmd "RustToggleInlayHints"                    "Toggle inlay hints")
       "r" (cmd "Trouble lsp_references"                  "Show references") 
       "E" (cmd "Trouble document_diagnostics"            "List diagnostics")
       "e" (cmd "Trouble workspace_diagnostics"           "Show diagnostics")
       "t" (cmd "Trouble lsp_type_definitions"            "Go to type-definition") 
       "i" (cmd "Trouble lsp_implementations"             "Show implementation") 
       "g" (cmd "Trouble lsp_definitions"                 "Go to definition") 
       "f" [format                                        "format file"]
       "," (cmd "RustRunnables"                           "Run rust stuff")}

  "f" {:name "+folds"
       "o" (cmd "foldopen"  "open fold") 
       "n" (cmd "foldclose" "close fold") 
       "j" (rebind "zj"     "jump to next fold") 
       "k" (rebind "zk"     "jump to previous fold")}
 
  "v" {:name "+view-and-layout"
       "n" (cmd "set relativenumber!"             "toggle relative numbers") 
       "m" (cmd "set nonumber! norelativenumber"  "toggle numbers") 
       "g" (cmd "ZenMode"                         "toggle zen mode") 
       "i" (cmd "IndentGuidesToggle"              "toggle indent guides")
       "w" (cmd "set wrap! linebreak!"            "toggle linewrapping")}

  "b" {:name "+buffers"
       "b" (cmd "Buffers"   "select open buffer")
       "c" (cmd "bdelete!"  "close open buffer")
       "w" (cmd "bwipeout!" "wipeout open buffer")}}
  

 {:prefix"<leader>"})

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
 {"s" (sel-cmd "VSSplit" "keep selection visible in split")
  "z" [open-selection-zotero "open in zotero"]}
 {:prefix "<leader>"
  :mode "v"})
           
(wk.register
 {:name "+Selection"
  "j" "increment selection"
  "k" "decrement selection"
  "l" "increment node"
  "h" "decrement node"}
 {:prefix "gs"
  :mode "v"})


(set nvim.o.timeoutlen 200)

