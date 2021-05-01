(module keybinds
  {require {a aniseed.core
            nvim aniseed.nvim
            utils utils
            fennel aniseed.fennel
            wk which-key
            treesitter-selection nvim-treesitter.incremental_selection}
   require-macros [macros]})


(utils.keymap :i :<C-Space> "call compe#complete()" {:expr true})
(utils.keymap :i :<esc> "compe#close('<esc>')" {:expr true})



(wk.setup {})

(fn cmd [s desc] [(.. "<cmd>" s "<cr>") desc])
(fn le [s desc] (cmd (.. "call luaeval(\"" s "\")") desc))
(fn rebind [s desc] [s desc])

(wk.register 
  { "c" { :name "+comment out"}
    "e" { :name "+emmet"}

    "h" (cmd "bprevious"              "previous buffer")
    "l" (cmd "bnext"                  "next buffer")
    "o" (cmd "Telescope live_grep"    "Grep files")
    "p" (cmd "Telescope file_browser" "Open file-browser")
    ":" (cmd "Telescope commands"     "Search command with fzf")

    "m" { :name "+Code actions"
          "d" (cmd "Lspsaga hover_doc"                       "Show documentation") 
          "b" (cmd "Lspsaga lsp_finder"                      "Find stuff") 
          "x" (cmd "Lspsaga preview_definition"              "Preview definition") 
          "o" (cmd "SymbolsOutline"                          "Outline") 
          "S" (cmd "Telescope lsp_document_symbols"          "Symbols in document") 
          "s" (cmd "Telescope lsp_dynamic_workspace_symbols" "Symbols in workspace") 
          "t" (cmd "Lspsaga signature_help"                  "Show signature help") 
          "n" (cmd "Lspsaga rename"                          "Rename") 
          "v" (cmd "Lspsaga code_action"                     "Apply codeaction") 
          "a" (cmd "Lspsaga show_cursor_diagnostics"         "Cursor diagnostics") 
          "A" (cmd "Lspsaga show_line_diagnostics"           "Line diagnostics")
          "E" (cmd "Telescope lsp_workspace_diagnostics"     "List diagnostics") 
          "r" (cmd "Telescope lsp_references"                "Show references") 
          "e" (cmd "LspTroubleOpen"                          "Show diagnostics") 
          "g" [vim.lsp.buf.definition                        "Go to definition"] 
          "i" [vim.lsp.buf.implementation                    "Show implementation"] 
          "f" [vim.lsp.buf.formatting                        "format file"]
          "h" (cmd "RustToggleInlayHints"                    "Toggle inlay hints")}

    "f" { :name "+folds"
          "o" (cmd "foldopen"  "open fold") 
          "n" (cmd "foldclose" "close fold") 
          "j" (rebind "zj"     "jump to next fold") 
          "k" (rebind "zk"     "jump to previous fold")}
  
    "v" { :name "+view-and-layout"
          "n" (cmd "set relativenumber!"             "toggle relative numbers") 
          "m" (cmd "set nonumber! norelativenumber"  "toggle numbers") 
          "g" (cmd "Goyo | set linebreak"            "toggle focus mode") 
          "i" (cmd "IndentGuidesToggle"              "toggle indent guides")}

    "b" { :name "+buffers"
          "b" (cmd "Buffers"   "select open buffer")
          "c" (cmd "bdelete!"  "close open buffer")
          "w" (cmd "bwipeout!" "wipeout open buffer")}}

  { :prefix "<leader>"})

(wk.register
   { "<tab>" "which_key_ignore"
     "gss" "init selection"
     "z" { :name "+folds" 
           "c" (cmd "foldclose" "close fold")
           "o" (cmd "foldopen"  "open fold")}})

(wk.register
  { "<tab>" "which_key_ignore"}
  { :mode "i"})
           
(wk.register
  { :name "+Selection"
    "j" "increment selection"
    "k" "decrement selection"
    "l" "increment node"
    "h" "decrement node"}
  { :prefix "gs"
    :mode "v"})


(set nvim.o.timeoutlen 200)

