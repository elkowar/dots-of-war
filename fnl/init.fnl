(module init 
  {require {a aniseed.core
            fennel aniseed.fennel 
            nvim aniseed.nvim 
            kb keybinds 
            utils utils}
    require-macros [macros]})
    ;include {keybinds keybinds}})

(global pp 
  (fn [x] 
    (print (fennel.view x))))

(set nvim.g.conjure#client#fennel#aniseed#aniseed_module_prefix "aniseed.")


(local lsp (require "lspconfig")) 
(local saga (require "lspsaga")) 
(local compe (require "compe"))


;(fn on_attach [client bufnr]
  ;(if client.resolved_capabilities.document_highlight
    ;(nvim.api.nvim_exec
      ;"hi LspReferenceRead cterm=bold ctermbg=red guibg='#8ec07c' guifg='#282828' hi LspReferenceText cterm=bold ctermbg=red guibg='#8ec07c' guifg='#282828' hi LspReferenceWrite cterm=bold ctermbg=red guibg='#8ec07c' guifg='#282828' 
      ;augroup lsp_document_highlight
        ;autocmd! * <buffer> autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight() autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      ;augroup END " false)))

(fn on_attach [client bufnr] (print "hi"))


(lsp.rust_analyzer.setup { :on_attach on_attach})
(lsp.jsonls.setup { :on_attach on_attach})
(lsp.vimls.setup { :on_attach on_attach})
(lsp.tsserver.setup { :on_attach on_attach})
(lsp.bashls.setup { :on_attach on_attach})
(lsp.html.setup { :on_attach on_attach})

(lsp.denols.setup { :on_attach on_attach
    :root_dir (lsp.util.root_pattern ".git")})
(lsp.hls.setup { :on_attach on_attach}
    :settings { :languageServerHaskell { :formattingProvider "stylish-haskell"}})

(compe.setup 
  { :enabled true
    :autocomplete false
    :debug false 
    :min_length 1 
    :preselect "enable" 
    :throttle_time 80 
    :source_timeout 200 
    :incomplete_delay 400 
    :max_abbr_width 100 
    :max_kind_width 100 
    :max_menu_width 100 
    :documentation true 
    :source { :path true
              :buffer true 
              :calc true 
              :nvim_lsp true 
              :nvim_lua true 
              :vsnip false}})


(saga.init_lsp_saga 
  { :border_style 1
    :code_action_keys { :quit "<esc>" :exec "<CR>"} 
    :rename_action_keys { :quit "<esc>" :exec "<CR>"} 
    :finder_action_keys { :quit "<esc>"
                          :open "<CR>" 
                          :vsplit "v" 
                          :split "b" 
                          :scroll_up "<C-u>" 
                          :scroll_down "<C-d>"}}
 

 (local galaxyline (require "galaxyline")) 
 (local colors (utils.colors)))


(local modes 
  { :n  { :text "NORMAL"        :colors { :bg colors.neutral_aqua :fg colors.dark0}}
    :i  { :text "INSERT"        :colors { :bg colors.neutral_yellow :fg colors.dark0}}
    :c  { :text "CMD"           :colors { :bg colors.neutral_aqua :fg colors.dark0}}
    :ce { :text "NORMEX"        :colors { :bg colors.neutral_aqua :fg colors.dark0}}
    :cv { :text "EX"            :colors { :bg colors.neutral_aqua :fg colors.dark0}}
    :ic { :text "INSCOMP"       :colors { :bg colors.neutral_aqua :fg colors.dark0}}
    :no { :text "OP-PENDING"    :colors { :bg colors.neutral_aqua :fg colors.dark0}}
    :r  { :text "HIT-ENTER"     :colors { :bg colors.neutral_aqua :fg colors.dark0}}
    :r? { :text "CONFIRM"       :colors { :bg colors.neutral_aqua :fg colors.dark0}}
    :R  { :text "REPLACE"       :colors { :bg colors.neutral_aqua :fg colors.dark0}}
    :Rv { :text "VIRTUAL"       :colors { :bg colors.neutral_aqua :fg colors.dark0}}
    :s  { :text "SELECT"        :colors { :bg colors.neutral_aqua :fg colors.dark0}}
    :S  { :text "SELECT"        :colors { :bg colors.neutral_aqua :fg colors.dark0}}
    :t  { :text "TERM"          :colors { :bg colors.neutral_aqua :fg colors.dark0}}
    :v  { :text "VISUAL"        :colors { :bg colors.neutral_blue :fg colors.dark0}}
    :V  { :text "VISUAL LINE"   :colors { :bg colors.neutral_blue :fg colors.dark0}}
    "" { :text "VISUAL BLOCK" :colors { :bg colors.neutral_blue :fg colors.dark0}}})




(fn viModeProvider [] 
  (let [modedata (or (. modes (nvim.fn.mode)) 
                     { :text (nvim.fn.mode) :colors {:bg colors.neutral_orange :fg colors.dark0}})]
    (utils.highlight "GalaxyViMode" modedata.colors)
    modedata.text))

    
(tset galaxyline.section.left 1
      { :ViMode { :provider viModeProvider :icon " "}})

(tset galaxyline.section.left 2
      { :FileSize { :provider "FileSize"}})


