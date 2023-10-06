(local {: autoload : a : utils} (require :dots.prelude))
(local lsp (autoload :lspconfig)) 
(local lsp-configs (autoload :lspconfig/configs))
(local cmp_nvim_lsp (autoload :cmp_nvim_lsp))

(fn setup []
  ; TODO check https://github.com/neovim/nvim-lspconfig/blob/master/ADVANCED_README.md for default config for all of them

  (tset vim.lsp.handlers :textDocument/publishDiagnostics
    (vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics 
                  {:update_in_insert false
                   :virtual_text {:prefix "◆"}
                   :signs false
                   :severity_sort true}))



  (fn on_attach [client bufnr]
    (if client.server_capabilities.documentHighlight
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
  (local default-capabilities
    (let [capabilities (vim.lsp.protocol.make_client_capabilities)]
      (set capabilities.textDocument.completion.completionItem.snippetSupport true)
      (cmp_nvim_lsp.default_capabilities capabilities)))

  (fn init-lsp [lsp-name ?opts]
    "initialize a language server with defaults"
    (let [merged-opts (a.merge {:on_attach on_attach :capabilities default-capabilities} (or ?opts {}))]
      ((. lsp lsp-name :setup) merged-opts)))

  (init-lsp :jsonls   {:commands {:Format [ #(vim.lsp.buf.range_formatting [] [0 0] [(vim.fn.line "$") 0])]}})
  (init-lsp :denols   {:root_dir (better_root_pattern [".git"] ["package.json"])})
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
  (init-lsp :pyright)
  ;(init-lsp :ltex {:settings {:ltex {:dictionary           {:de-DE [":~/.config/ltex-ls/dictionary.txt"]}
                                     ;:disabledRules        {:de-DE [":~/.config/ltex-ls/disabledRules.txt"]}
                                     ;:hiddenFalsePositives {:de-DE [":~/.config/ltex-ls/hiddenFalsePositives.txt"]}
                                     ;:additionalRules {:motherTongue "de-DE"}}}})
  (init-lsp :vls)
  ;(init-lsp :clangd)
  ;(init-lsp :ccls)

  (init-lsp :perlls)

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
        liblldb-path   (.. extension-path "lldb/lib/liblldb.so") 
        features nil]
    (rust-tools.setup {:tools {:inlay_hints {:show_parameter_hints false}
                                             ;:auto false}
                               :autoSetHints false}
                       :dap {:adapter (rust-tools-dap.get_codelldb_adapter codelldb-path liblldb-path)}
                       :server {:on_attach on_attach
                                :capabilities default-capabilities
                                :settings {:rust-analyzer {:cargo {:loadOutDirsFromCheck true
                                                                   :features (or features "all")
                                                                   :noDefaultFeatures (~= nil features)}
                                                           :procMacro {:enable true}
                                                           :diagnostics {:enable false ;; native rust analyzer diagnostics
                                                                         :experimental {:enable false}}
                                                           :checkOnSave {:overrideCommand ["cargo" "clippy" "--workspace" "--message-format=json" "--all-targets" "--all-features"]}}}}}))
                                
                                ;:cmd ["/home/leon/coding/prs/rust-analyzer/target/release/rust-analyzer"]}}))

  (when (or true (not lsp.fennel_language_server))
    (tset lsp-configs :fennel_language_server
          {:default_config {:cmd "/Users/leon/.cargo/bin/fennel-language-server"
                            :filetypes [:fennel]
                            :single_file_support true
                            :root_dir (lsp.util.root_pattern ["fnl" "init.lua"])
                            :settings {:fennel {:workspace {:library (vim.api.nvim_list_runtime_paths)}
                                                :diagnostics {:globals [:vim]}}}}}))
                            
  (init-lsp :fennel_language_server
            {:root_dir (lsp.util.root_pattern ["fnl" "init.lua"])
             :settings {:fennel {:workspace {:library (vim.api.nvim_list_runtime_paths)}
                                 :diagnostics {:globals [:vim :comment]}}}})
;
;


  ; (let [sumneko_root_path (.. vim.env.HOME "/.local/share/lua-language-server")
  ;       sumneko_binary (.. sumneko_root_path "/bin/Linux/lua-language-server"))
  ;   (init-lsp 
  ;     :lua_ls
  ;     {:cmd [sumneko_binary "-E" (.. sumneko_root_path "/main.lua")]
  ;      :settings {:Lua {:runtime {:version "LuaJIT"
  ;                                 :path (vim.split package.path ";")}
  ;                       :diagnostics {:globals ["vim"]}
  ;                       :workspace {:library {(vim.fn.expand "$VIMRUNTIME/lua") true
  ;                                             (vim.fn.expand "$VIMRUNTIME/lua/vim/lsp") true}}
  ;                       :telemetry false}}}))

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

  (local autostart-semantic-highlighting true)
  (fn refresh-semantic-highlighting []
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

  ; Cleanup links in markdown documentation
  (fn cleanup-markdown [contents]
    (if (= contents.kind "markdown")
      (tset contents :value (string.gsub contents.value "%[([^%]]+)%]%(([^%)]+)%)" "[%1]")))
    contents)

  (let [previous-handler (. vim.lsp.handlers :textDocument/hover)]
    (tset vim.lsp.handlers :textDocument/hover 
      (fn [a result b c]
        (if (not (and result result.contents))
          (previous-handler a result b c)
          (let [new-contents (cleanup-markdown result.contents)]
            (tset result :contents new-contents)
            (previous-handler a result b c)))))))

[(utils.plugin :neovim/nvim-lspconfig {:event "VeryLazy" :lazy true :config setup})]
; vim:foldmarker=<<<<<,>>>>>
