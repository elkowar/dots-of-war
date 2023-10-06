(local {: autoload : utils} (require :dots.prelude))
(local lsp (autoload :lspconfig))
(local configs (autoload :lspconfig/configs))
(local lsputil (autoload :lspconfig/util))


(fn cmds [xs]
  (icollect [_ x (ipairs xs)]
    (.. "\\" x "{}")))

(local latex-command-settings
  {:dummy (cmds ["texttt" "scripture" "lstref" "figref" "tblref" "secref" "personaltextcite" "personalparencite" "textcite" "parencite" "parencite[]" "game" "acsu" "enquote" "name" "item" "reqref" "gamebtn" "fs" "cs" "appref" "sorty"])
   :ignore (cmds ["urlfootnote" "caption" "todo"])})
  


(local Dictionary-file      {:de-DE [(.. (vim.fn.getenv "HOME") "/.config/ltex-ls/dictionary.txt")]})
(local Disabled-rules-file  {:de-DE [(.. (vim.fn.getenv "HOME") "/.config/ltex-ls/disable.txt")]})
(local False-positives-file {:de-DE [(.. (vim.fn.getenv "HOME") "/.config/ltex-ls/false.txt")]})


(local latex-command-settings-formatted
  (let [tbl {}]
    (each [option commands (pairs latex-command-settings)]
      (each [_ command (ipairs commands)]
        (tset tbl command option)))
    tbl))


(fn read-files [files]
  (let [dict {}]
    (each [_ file (ipairs files)]
      (local f (io.open file :r))
      (when (~= nil f)
        (each [l (f:lines)]
          (table.insert dict l))))
    dict))

(fn find-ltex-lang []
  (let [buf-clients (vim.lsp.buf_get_clients)]
    (each [_ client (ipairs buf-clients)]
      (when (= client.name :ltex)
        (let [___antifnl_rtn_1___ client.config.settings.ltex.language]
          (lua "return ___antifnl_rtn_1___"))))))

(fn find-ltex-files [filetype value]
  (if (= filetype :dictionary)
      (. Dictionary-file (or value (find-ltex-lang)))
      (= filetype :disable)
      (. Disabled-rules-file (or value (find-ltex-lang)))
      (= filetype :falsePositive)
      (. False-positives-file (or value (find-ltex-lang)))))

(fn update-config [lang configtype]
  (let [buf-clients (vim.lsp.buf_get_clients)]
    (var client nil)
    (each [_ lsp (ipairs buf-clients)]
      (when (= lsp.name :ltex)
        (set client lsp)))
    (if client
        (if (= configtype :dictionary)
            (if client.config.settings.ltex.dictionary
                (do
                  (set client.config.settings.ltex.dictionary
                       {lang (read-files (. Dictionary-file lang))})
                  (client.notify :workspace/didChangeConfiguration
                                 client.config.settings))
                (vim.notify "Error when reading dictionary config, check it"))
            (= configtype :disable)
            (if client.config.settings.ltex.disabledRules
                (do
                  (set client.config.settings.ltex.disabledRules
                       {lang (read-files (. Disabled-rules-file lang))})
                  (client.notify :workspace/didChangeConfiguration
                                 client.config.settings))
                (vim.notify "Error when reading disabledRules config, check it"))
            (= configtype :falsePositive)
            (if client.config.settings.ltex.hiddenFalsePositives
                (do
                  (set client.config.settings.ltex.hiddenFalsePositives
                       {lang (read-files (. False-positives-file lang))})
                  (client.notify :workspace/didChangeConfiguration
                                 client.config.settings))
                (vim.notify "Error when reading hiddenFalsePositives config, check it")))
        nil)))

(fn add-to-file [filetype lang file value]
  (set-forcibly! file (io.open (. file (- (length file) 0)) :a+))
  (if file (do
             (file:write (.. value "\n"))
             (file:close))
      (let [___antifnl_rtns_1___ [(print "Failed insert %q" value)]]
        (lua "return (table.unpack or _G.unpack)(___antifnl_rtns_1___)")))
  (if (= filetype :dictionary)    (update-config lang :dictionary)
      (= filetype :disable)       (update-config lang :disable)
      (= filetype :falsePositive) (update-config lang :falsePositive)))

(fn add-to [filetype lang file value]
  (let [dict (read-files file)]
    (each [_ v (ipairs dict)]
      (when (= v value)
        (lua "return nil")))
    (add-to-file filetype lang file value)))


(fn init []
  (set configs.ltex
       {:default_config {:cmd [:ltex-ls]
                         :filetypes [:tex :latex :bib]
                         :root_dir (fn [filename] (lsputil.path.dirname filename))}})

  (lsp.ltex.setup {:settings {:ltex {:enabled [:latex :tex :bib]
                                     :language "de-DE"
                                     :checkFrequency "save"
                                     :diagnosticSeverity "information"
                                     :setenceCacheSize 5000
                                     :additionalRules {:enablePickyRules true
                                                       :motherTongue "de-DE"}
                                     :dictionary           (utils.map-values read-files Dictionary-file)
                                     :disabledRules        (utils.map-values read-files Disabled-rules-file)
                                     :hiddenFalsePositives (utils.map-values read-files False-positives-file)
                                     :latex {:commands latex-command-settings-formatted}}}})
                   
  (set lsp.ltex.dictionary_file Dictionary-file)
  (set lsp.ltex.disabledrules_file Disabled-rules-file)
  (set lsp.ltex.falsepostivies_file False-positives-file)
  (local orig-execute-command vim.lsp.buf.execute_command)

  (set vim.lsp.buf.execute_command
       (fn [command]
         (if (= command.command :_ltex.addToDictionary)
             (let [arg (. (. command.arguments 1) :words)]
               (each [lang words (pairs arg)]
                 (each [_ word (ipairs words)]
                   (local filetype :dictionary)
                   (add-to filetype lang (find-ltex-files filetype lang) word))))
             (= command.command :_ltex.disableRules)
             (let [arg (. (. command.arguments 1) :ruleIds)]
               (each [lang rules (pairs arg)]
                 (each [_ rule (ipairs rules)]
                   (local filetype :disable)
                   (add-to filetype lang (find-ltex-files filetype lang) rule))))
             (= command.command :_ltex.hideFalsePositives)
             (let [arg (. (. command.arguments 1) :falsePositives)]
               (each [lang rules (pairs arg)]
                 (each [_ rule (ipairs rules)]
                   (local filetype :falsePositive)
                   (add-to filetype lang (find-ltex-files filetype lang) rule))))
             (orig-execute-command command)))))


[]
