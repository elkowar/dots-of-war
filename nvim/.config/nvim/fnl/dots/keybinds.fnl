(local {: autoload : a : str : utils} (require :dots.prelude))
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

(utils.keymap [:n :v] :<space><space>c "\"+y")


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


(fn key-map [obj]
  (icollect [key val (pairs obj)]
    (utils.prepend key val)))
(fn m [bind desc]
  {1 bind :desc desc})


(fn cmd [s desc] (utils.prepend (.. "<cmd>" s "<cr>") {:desc desc}))
(fn sel-cmd [s desc] (utils.prepend (.. "<cmd>'<,'>" s "<cr>") {:desc desc}))
(fn rebind [s desc] (m s desc))


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

(wk.add
  (key-map
    {"<leader>c" {:group "+comment out"}
     "<leader>e" {:group "+emmet"}

     "<leader>[" (cmd "HopWord" "Hop to a word")
     "<leader>h" (cmd "bprevious"              "previous buffer")
     "<leader>l" (cmd "bnext"                  "next buffer")
     "<leader>o" (cmd "Telescope live_grep"    "Grep files")
     "<leader>P" (cmd "Telescope frecency frecency default_text=:CWD:"     "Frecency magic")
     "<leader>p" (cmd "Telescope find_files"   "Open file-browser")
     "<leader>:" (cmd "Telescope commands"     "Search command with fzf")
     "<leader>s" (cmd "w"                      "Save file")
     "<leader>g" (cmd "Neogit"                 "Git")

     "<leader>n" (m (. (require :persistence) :load) "Load last session")

     "<leader>d" {:group "+Debugging"}
     "<leader>db" (m dap.toggle_breakpoint    "toggle breakpoint")
     "<leader>du" (m dapui.toggle             "toggle dapui")
     "<leader>dc" (m dap.step_into            "continue")
     "<leader>dr" (m dap.repl.open            "open repl")

     "<leader>ds" {:group "+Step"}
     "<leader>dso" (m dap.step_over       "over")
     "<leader>dsu" (m dap.step_out        "out")
     "<leader>dsi" (m dap.step_into       "into")

     "<leader>m" {:group "+Code actions"}
     "<leader>m;" (m #(set vim.o.spell (not vim.o.spell))          "Toggle spell checking")
     "<leader>md" (m vim.lsp.buf.hover                             "Show documentation") 
     "<leader>mo" (cmd "SymbolsOutline"                          "Outline") 
     "<leader>mS" (cmd "Telescope lsp_document_symbols"          "Symbols in document") 
     "<leader>ms" (cmd "Telescope lsp_dynamic_workspace_symbols" "Symbols in workspace") 
     "<leader>mT" (m vim.lsp.buf.signature_help                    "Show signature help") 
     "<leader>mn" (m open-rename                                   "Rename") 
     "<leader>mv" (cmd "CodeActionMenu"                          "Apply codeaction") 
     "<leader>mA" (m #(vim.diagnostic.open_float {:scope :cursor}) "Cursor diagnostics") 
     "<leader>ma" (m #(vim.diagnostic.open_float {})               "Line diagnostics") 
     "<leader>mh" (cmd "RustToggleInlayHints"                    "Toggle inlay hints")
     "<leader>mr" (cmd "Trouble lsp_references"                  "Show references") 
     "<leader>mE" (cmd "Trouble document_diagnostics"            "List diagnostics")
     "<leader>me" (cmd "Trouble workspace_diagnostics"           "Show diagnostics")
     "<leader>mt" (cmd "Trouble lsp_type_definitions"            "Go to type-definition") 
     "<leader>mi" (cmd "Trouble lsp_implementations"             "Show implementation") 
     "<leader>mg" (cmd "Trouble lsp_definitions"                 "Go to definition") 
     "<leader>mw" (m toggle-lsp-lines                              "Toggle LSP lines")
     "<leader>mW" (m toggle-lsp-lines-current                      "Toggle LSP line")
     "<leader>mf" (m format                                        "format file")
     "<leader>m," (cmd "RustRunnables"                           "Run rust stuff")

     "<leader>mx" {:group "+Glance"}
     "<leader>mxd" (m #(glance.open "definitions")             "Definitions") 
     "<leader>mxr" (m #(glance.open "references")              "References") 
     "<leader>mxt" (m #(glance.open "type_definitions")        "Type definitions") 
     "<leader>mxi" (m #(glance.open "implementations")         "Implementations") 

     "<leader>c" {:group "+Crates"}
     "<leader>mcj" (m crates.show_popup "crates popup")
     "<leader>mcf" (m crates.show_features_popup "crate features")
     "<leader>mcv" (m crates.show_versions_popup "crate versions")
     "<leader>mcd" (m crates.show_dependencies_popup "crate dependencies")
     "<leader>mch" (m crates.open_documentation "crate documentation")

     "<leader>f" {:group "+folds"}
     "<leader>fo" (cmd "foldopen"  "open fold") 
     "<leader>fn" (cmd "foldclose" "close fold") 
     "<leader>fj" (rebind "zj"     "jump to next fold") 
     "<leader>fk" (rebind "zk"     "jump to previous fold")
 
     "<leader>v" {:group "+view-and-layout"}
     "<leader>vn" (cmd "set relativenumber!"             "toggle relative numbers") 
     "<leader>vm" (cmd "set nonumber! norelativenumber"  "toggle numbers") 
     "<leader>vg" (cmd "ZenMode"                         "toggle zen mode") 
     "<leader>vi" (cmd "IndentGuidesToggle"              "toggle indent guides")
     "<leader>vw" (cmd "set wrap! linebreak!"            "toggle linewrapping")

     "<leader>b" {:group "+buffers"}
     "<leader>bb" (cmd ":Telescope buffers" "select open buffer")
     "<leader>bc" (cmd ":Bdelete!"          "close open buffer")
     "<leader>bw" (cmd ":Bwipeout!"         "wipeout open buffer")}))
  

(wk.add
  (key-map
    {"<tab>" {:hidden true}
     "gss" {:desc "init selection"}
     "z" {:group "folds"}
     "zc" (m "<cmd>foldclose<cr>" "close fold")
     "zo" (m "<cmd>foldopen<cr>" "open fold")}))

(wk.add
  (key-map {"<tab>" {:hidden true :mode "i"}}))

(wk.add
  (utils.prepend
    (key-map
      {"<leader>s" (sel-cmd "VSSplit" "keep selection visible in split")
       "<leader>z" (m open-selection-zotero "open in zotero")

       "gs" {:group "+Selection"}
       "gsj" {:desc "increment selection"}
       "gsk" {:desc "decrement selection"}
       "gsl" {:desc "increment node"}
       "gsh" {:desc "decrement node"}})
    {:mode "v"}))
   

(set vim.o.timeoutlen 200)

