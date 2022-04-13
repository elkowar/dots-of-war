(module dots.plugins.lsp
  {autoload {a aniseed.core
             str aniseed.string
             lsp lspconfig 
             lsp-configs lspconfig/configs
             utils dots.utils
             ltex-ls dots.plugins.ltex-ls
             cmp_nvim_lsp cmp_nvim_lsp}

   require-macros [macros]})

; TODO check https://github.com/neovim/nvim-lspconfig/blob/master/ADVANCED_README.md for default config for all of them

(tset vim.lsp.handlers :textDocument/publishDiagnostics
  (vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics 
                {:update_in_insert false
                 :virtual_text {:prefix "◆"}
                 :signs false
                 :severity_sort true}))



(fn on_attach [client bufnr]
  ;(pkg lsp_signature.nvim [lsp_signature (require "lsp_signature")]
       ;(lsp_signature.on_attach {:bind true
                                 ;:hint_scheme "String" 
                                 ;:hint_prefix "ƒ "
                                 ;:handler_opts {:border "single"}
                                 ;:use_lspsaga false
                                 ;:decorator ["`" "`"]}))

  ;(req dots.utils.highlight :LspDiagnosticsUnderlineError {:gui "underline"})
  (if client.resolved_capabilities.document_highlight
    (do
      (utils.highlight "LspReferenceRead"  {:gui "underline"})
      (utils.highlight "LspReferenceText"  {:gui "underline"})
      (utils.highlight "LspReferenceWrite" {:gui "underline"})
      (vim.api.nvim_exec
        "augroup lsp_document_highlight
        autocmd! * <buffer> 
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight() 
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END"
        false))))


(fn better_root_pattern [patterns except-patterns]
  "match path if one of the given patterns is matched, EXCEPT if one of the except-patterns is matched"
  (fn [path] 
    (when (not ((lsp.util.root_pattern except-patterns) path))
      ((lsp.util.root_pattern patterns) path))))

; advertise snippet support
(def default-capabilities
  (let [capabilities (vim.lsp.protocol.make_client_capabilities)]
    (set capabilities.textDocument.completion.completionItem.snippetSupport true)
    (cmp_nvim_lsp.update_capabilities capabilities)))

(fn init-lsp [lsp-name ?opts]
  "initialize a language server with defaults"
  (let [merged-opts (a.merge {:on_attach on_attach :capabilities default-capabilities} (or ?opts {}))]
    ((. lsp lsp-name :setup) merged-opts)))

(init-lsp :jsonls   {:commands {:Format [ #(vim.lsp.buf.range_formatting [] [0 0] [(vim.fn.line "$") 0])]}})
;(init-lsp :denols   {:root_dir (better_root_pattern [".git"] ["package.json"])})
(init-lsp :hls      {:settings {:languageServerHaskell {:formattingProvider "stylish-haskell"}}})
(init-lsp :ocamllsp)
(init-lsp :vimls)
(init-lsp :gopls)
(init-lsp :bashls)
(init-lsp :erlangls)
(init-lsp :yamlls)
(init-lsp :html)
(init-lsp :svelte)
(init-lsp :elmls)
(init-lsp :texlab)
;(init-lsp :ltex {:settings {:ltex {:dictionary           {:de-DE [":~/.config/ltex-ls/dictionary.txt"]}
                                   ;:disabledRules        {:de-DE [":~/.config/ltex-ls/disabledRules.txt"]}
                                   ;:hiddenFalsePositives {:de-DE [":~/.config/ltex-ls/hiddenFalsePositives.txt"]}
                                   ;:additionalRules {:motherTongue "de-DE"}}}})
(init-lsp :vls)
;(init-lsp :clangd)
;(init-lsp :ccls)


(init-lsp :powershell_es {:bundle_path "/home/leon/powershell"})
;(ltex-ls.init)
         
         
         
         

(init-lsp :clangd)


                                              
(init-lsp :cssls {:filestypes ["css" "scss" "less" "stylus"]
                  :root_dir (lsp.util.root_pattern ["package.json" ".git"])
                  :settings {:css  {:validate true} 
                             :less {:validate true}
                             :scss {:validate true}}})

(lsp.tsserver.setup {:root_dir (lsp.util.root_pattern "package.json")
                     :on_attach (fn [client bufnr] 
                                  (set client.resolved_capabilities.document_formatting false)
                                  (on_attach client bufnr))})


(let [rust-tools (require "rust-tools")
      rust-tools-dap (require "rust-tools.dap")
      extension-path "/home/leon/.vscode/extensions/vadimcn.vscode-lldb-1.6.8/"
      codelldb-path  (.. extension-path "adapter/codelldb")
      liblldb-path   (.. extension-path "lldb/lib/liblldb.so")] 
  (rust-tools.setup {:tools {:inlay_hints {:show_parameter_hints false}
                             :autoSetHints false}
                     :dap {:adapter (rust-tools-dap.get_codelldb_adapter codelldb-path liblldb-path)}
                     :server {:on_attach on_attach
                              :capabilities default-capabilities}}))
                              ;:cmd ["/home/leon/coding/prs/rust-analyzer/target/release/rust-analyzer"]}}))

(let [sumneko_root_path (.. vim.env.HOME "/.local/share/lua-language-server")
      sumneko_binary (.. sumneko_root_path "/bin/Linux/lua-language-server")]
  (init-lsp 
    :sumneko_lua
    {:cmd [sumneko_binary "-E" (.. sumneko_root_path "/main.lua")]
     :settings {:Lua {:runtime {:version "LuaJIT"
                                :path (vim.split package.path ";")}
                      :diagnostics {:globals ["vim"]}
                      :workspace {:library {(vim.fn.expand "$VIMRUNTIME/lua") true
                                            (vim.fn.expand "$VIMRUNTIME/lua/vim/lsp") true}}
                      :telemetry false}}}))

(comment
  (when (not lsp.prolog_lsp)
    (tset lsp-configs :prolog_lsp
         {:default_config {:cmd ["swipl" "-g" "use_module(library(lsp_server))." "-g" "lsp_server:main" "-t" "halt" "--" "stdio"]
                           :filetypes ["prolog"]
                           :root_dir (fn [fname] (or (lsp.util.find_git_ancestor fname) (vim.loop.os_homedir)))
                           :settings {}}}))

  (lsp.prolog_lsp.setup {}))


(comment
  (let [ewwls-path "/home/leon/coding/projects/ls-eww/crates/ewwls/target/debug/ewwls"]
    (when (vim.fn.filereadable ewwls-path)
      (when (not lsp.ewwls)
        (set lsp-configs.ewwls
          {:default_config {:cmd [ewwls-path]
                            :filetypes ["yuck"]
                            :root_dir (fn [fname] (or (lsp.util.find_git_ancestor fname) (vim.loop.os_homedir)))
                            :settings {}}}))
      (init-lsp :ewwls))))


; Idris2 ----------------------------------------------------------- <<<<<

(def autostart-semantic-highlighting true)
(defn refresh-semantic-highlighting []
  (when autostart-semantic-highlighting
    (vim.lsp.buf_request 0
                         :textDocument/semanticTokens/full
                         {:textDocument (vim.lsp.util.make_text_document_params)}
                         nil)
    vim.NIL))

(when (not lsp.idris2_lsp)
  (set lsp-configs.idris2_lsp
    {:default_config 
     {:cmd [:idris2-lsp]
      :filetypes [:idris2]
      :on_new_config (fn [new-config new-root-dir]
                       (set new-config.cmd {1 :idris2-lsp})
                       (set new-config.capabilities.workspace.semanticTokens {:refreshSupport true}))
      :root_dir (fn [fname]
                  (local scandir (require :plenary.scandir))
                  (fn find-ipkg-ancestor [fname]
                    (lsp.util.search_ancestors 
                      fname 
                      (fn [path]
                        (local res (scandir.scan_dir path {:depth 1 :search_pattern ".+%.ipkg"}))
                        (when (not (vim.tbl_isempty res)) path))))

                  (or (or (find-ipkg-ancestor fname)
                          (lsp.util.find_git_ancestor fname))
                      (vim.loop.os_homedir)))
      :settings {}}}))
(lsp.idris2_lsp.setup 
  {:on_attach refresh-semantic-highlighting
   :autostart true
   :handlers {:workspace/semanticTokens/refresh refresh-semantic-highlighting
              :textDocument/semanticTokens/full 
              (fn [err method result client-id bufnr config]
                (let [client       (vim.lsp.get_client_by_id client-id)
                      legend       client.server_capabilities.semanticTokensProvider.legend
                      token-types  legend.tokenTypes
                      data         result.data
                      ns           (vim.api.nvim_create_namespace :nvim-lsp-semantic)]
                  (vim.api.nvim_buf_clear_namespace bufnr ns 0 (- 1))
                  (local tokens {}) 
                  (var (prev-line prev-start) (values nil 0))
                  (for [i 1 (length data) 5]
                    (local delta-line (. data i))
                    (set prev-line
                         (or (and prev-line (+ prev-line delta-line))
                             delta-line))
                    (local delta-start (. data (+ i 1)))
                    (set prev-start (or (and (= delta-line 0) (+ prev-start delta-start))
                                        delta-start))
                    (local token-type (. token-types (+ (. data (+ i 3)) 1)))
                    (vim.api.nvim_buf_add_highlight bufnr
                                                    ns
                                                    (.. :LspSemantic_ token-type)
                                                    prev-line
                                                    prev-start
                                                    (+ prev-start (. data (+ i 2)))))))}})

(vim.cmd "highlight link LspSemantic_type Include")
(vim.cmd "highlight link LspSemantic_function Identifier")
(vim.cmd "highlight link LspSemantic_struct Number")
(vim.cmd "highlight LspSemantic_variable guifg=gray")
(vim.cmd "highlight link LspSemantic_keyword Structure")    

; --------------------------------- >>>>>

(set vim.opt.signcolumn "yes")



; vim:foldmarker=<<<<<,>>>>>
