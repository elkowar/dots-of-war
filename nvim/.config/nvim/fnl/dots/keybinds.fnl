(local {: autoload} (require :nfnl.module))
(local a (autoload :nfnl.core))
(local str (autoload :nfnl.string))
(local utils (autoload :dots.utils))
(local wk (autoload :which-key))
(local glance (autoload :glance))
(local crates (autoload :crates))
(local dap (autoload :dap))
(local dapui (autoload :dapui))



; undo autopairs fuckup    
(set vim.g.AutoPairsShortcutBackInsert "<M-b>")

(utils.keymap :n :K "<Nop>")
(utils.keymap :v :K "<Nop>")

(utils.keymap :i "" "<C-w>")
(utils.keymap :i :<C-h> "<C-w>")
(utils.keymap :i :<C-BS> "<C-w>")

(utils.keymap :n :zt "zt<c-y><c-y><c-y>")
(utils.keymap :n :zb "zb<c-e><c-e><c-e>")

; these should really not be necessary, but whatever...
(utils.keymap :n :<space>c<space> "<cmd>call nerdcommenter#Comment(\"m\", \"Toggle\")<CR>" {})
(utils.keymap :v :<space>c<space> "<cmd>call nerdcommenter#Comment(\"x\", \"Toggle\")<CR>" {})

(utils.keymap :n :<C-LeftMouse> "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>")
(utils.keymap :n :<A-LeftMouse> "<Esc><LeftMouse><cmd>lua vim.lsp.buf.hover()<CR>")


;(utils.keymap :i :<C-l><C-j> "<Plug>(copilot-suggest)")
;(utils.keymap :i :<C-l><C-d> "<Plug>(copilot-dismiss)")
;(utils.keymap :i :<C-l><C-n> "<Plug>(copilot-next)")
;(utils.keymap :i :<C-l><C-p> "<Plug>(copilot-previous)")
;(utils.keymap :i :<C-l><C-o> "<cmd>Copilot panel<cr>")

(utils.keymap :n :<a-s-j> "<cmd>RustMoveItemDown<cr>j")
(utils.keymap :n :<a-s-k> "<cmd>RustMoveItemUp<cr>k")


(utils.keymap :n :<Backspace> "<cmd>HopChar2<CR>")


; Fix keybinds in linewrapped mode
;(utils.keymap [:n] :j "gj")
;(utils.keymap [:n] :k "gk")

(fn open-selection-zotero []
  (let [(_ _ sel) (utils.get-selection)]
    (vim.cmd (.. "silent !xdg-open zotero://select/items/@" (str.join sel)))))


(fn cmd [s desc] [(.. "<cmd>" s "<cr>") desc])
(fn sel-cmd [s desc] [(.. "<cmd>'<,'>" s "<cr>") desc])
(fn rebind [s desc] [s desc])


(fn format []
  (if (a.some #$1.server_capabilities.documentFormattingProvider (vim.lsp.get_active_clients))
    (vim.lsp.buf.format {:async true})
    (vim.cmd "Neoformat")))

(fn open-rename []
  (vim.api.nvim_feedkeys (.. ":IncRename " (vim.fn.expand "<cword>")) "n" ""))

(fn toggle-lsp-lines []
  (vim.diagnostic.config {:virtual_lines (not (. (vim.diagnostic.config) :virtual_lines))})
  ; TODO: this doesn't seem to work...
  (vim.diagnostic.config {:virtual_text (not (. (vim.diagnostic.config) :virtual_lines))}))

(fn toggle-lsp-lines-current []
  (vim.diagnostic.config {:virtual_lines {:only_current_line true}}))

(wk.setup {})
(wk.register 
 {"c" {:name "+comment out"}
  "e" {:name "+emmet"}

  "[" (cmd "HopWord" "Hop to a word")
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
       "b" [dap.toggle_breakpoint    "toggle breakpoint"]
       "u" [dapui.toggle             "toggle dapui"]
       "c" [dap.step_into            "continue"]
       "r" [dap.repl.open            "open repl"]
       "s" {:name "+Step"
            "o" [dap.step_over       "over"]
            "u" [dap.step_out        "out"]
            "i" [dap.step_into       "into"]}}

  "m" {:name "+Code actions"
       ";" [#(set vim.o.spell (not vim.o.spell))          "Toggle spell checking"]
       "d" [vim.lsp.buf.hover                             "Show documentation"] 
       "o" (cmd "SymbolsOutline"                          "Outline") 
       "S" (cmd "Telescope lsp_document_symbols"          "Symbols in document") 
       "s" (cmd "Telescope lsp_dynamic_workspace_symbols" "Symbols in workspace") 
       "T" [vim.lsp.buf.signature_help                    "Show signature help"] 
       "n" [open-rename                                   "Rename"] 
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
       "w" [toggle-lsp-lines                              "Toggle LSP lines"]
       "W" [toggle-lsp-lines-current                      "Toggle LSP line"]
       "f" [format                                        "format file"]
       "," (cmd "RustRunnables"                           "Run rust stuff")
       "x" {:name "+Glance"
            "d" [#(glance.open "definitions")             "Definitions"] 
            "r" [#(glance.open "references")              "References"] 
            "t" [#(glance.open "type_definitions")        "Type definitions"] 
            "i" [#(glance.open "implementations")         "Implementations"]} 
       "c" {:name "+Crates"
            "j" [crates.show_popup "crates popup"]
            "f" [crates.show_features_popup "crate features"]
            "v" [crates.show_versions_popup "crate versions"]
            "d" [crates.show_dependencies_popup "crate dependencies"]
            "h" [crates.open_documentation "crate documentation"]}}
  

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
       "b" (cmd ":Telescope buffers" "select open buffer")
       "c" (cmd ":Bdelete!"          "close open buffer")
       "w" (cmd ":Bwipeout!"         "wipeout open buffer")}}
  

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


(set vim.o.timeoutlen 200)

