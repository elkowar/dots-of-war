(module dots.plugins.lililine
        {autoload {a aniseed.core
                   str aniseed.string
                   nvim aniseed.nvim 
                   utils dots.utils
                   colors dots.colors
                   line lililine}

         require-macros [macros]})


(fn get-current-filename []
  (nvim.fn.expand "%:t"))

(fn get-current-filepath []
  (let [file (utils.shorten-path (vim.fn.bufname) 5 50)]
    (if (a.empty? file) ""
      nvim.bo.readonly (.. "RO " file)
      (and nvim.bo.modifiable nvim.bo.modified) (.. file " ")
      file)))

(fn make-lsp-diagnostic-provider [kind]
  (fn []
    (let [n (vim.lsp.diagnostic.get_count 0 kind)]
      (if (= n 0) "" (.. " " n " ")))))


(def bar-bg colors.dark0_soft)


(def modes 
  {:n   {:text "NORMAL"        :color {:bg colors.neutral_aqua   :fg colors.dark0}}
   :i   {:text "INSERT"        :color {:bg colors.neutral_yellow :fg colors.dark0}}
   :c   {:text "CMMAND"        :color {:bg colors.neutral_aqua   :fg colors.dark0}}
   :ce  {:text "NORMEX"        :color {:bg colors.neutral_aqua   :fg colors.dark0}}
   :cv  {:text "EX"            :color {:bg colors.neutral_aqua   :fg colors.dark0}}
   :ic  {:text "INSCOMP"       :color {:bg colors.neutral_aqua   :fg colors.dark0}}
   :no  {:text "OP-PENDING"    :color {:bg colors.neutral_aqua   :fg colors.dark0}}
   :r   {:text "HIT-ENTER"     :color {:bg colors.neutral_aqua   :fg colors.dark0}}
   :r?  {:text "CONFIRM"       :color {:bg colors.neutral_aqua   :fg colors.dark0}}
   :R   {:text "REPLACE"       :color {:bg colors.neutral_aqua   :fg colors.dark0}}
   :Rv  {:text "VIRTUAL"       :color {:bg colors.neutral_aqua   :fg colors.dark0}}
   :s   {:text "SELECT"        :color {:bg colors.neutral_aqua   :fg colors.dark0}}
   :S   {:text "SELECT"        :color {:bg colors.neutral_aqua   :fg colors.dark0}}
   :t   {:text "TERM"          :color {:bg colors.neutral_aqua   :fg colors.dark0}}
   :v   {:text "VISUAL"        :color {:bg colors.neutral_blue   :fg colors.dark0}}
   :V   {:text "VISUAL LINE"   :color {:bg colors.neutral_blue   :fg colors.dark0}}
   "" {:text "VISUAL BLOCK"  :color {:bg colors.neutral_blue   :fg colors.dark0}}})




(utils.highlight :StatusLine {:bg bar-bg :fg colors.light4})
(utils.highlight :StatusLineFilePath {:bg bar-bg :fg colors.light4})

(utils.highlight :StatusLineLspInfo  {:bg colors.neutral_blue  :fg bar-bg})
(utils.highlight :StatusLineLspWarn  {:bg colors.neutal_yellow :fg bar-bg}) 
(utils.highlight :StatusLineLspError {:bg colors.bright_red    :fg bar-bg}) 

(def space {:provider #" " :highlight :StatusLineBase})


(set line.lines.status
     [[; Mode
       {:provider #(let [data (or (. modes (vim.fn.mode))
                                  {:text (vim.fn.mode)
                                   :color {:bg colors.neutral_orange :fg colors.dark0}})] 
                     {:text (.. " " data.text " ") :color data.color})
        :highlight :StatusLineMode}

       space

       ; Filepath
       {:provider get-current-filepath
        :highlight :StatusLineFilePath}]

      []

      
      [; Filetype
       {:provider #vim.bo.filetype :highlight :StatusLine}

       ; Diagnostics
       {:provider (make-lsp-diagnostic-provider "Info")
        :highlight :StatusLineLspInfo}
       {:provider (make-lsp-diagnostic-provider "Warning")
        :highlight :StatusLineLspWarn}
       {:provider (make-lsp-diagnostic-provider "Error")
        :highlight :StatusLineLspError}


      
       ; Line info
       {:provider #(let [[line col] (vim.api.nvim_win_get_cursor 0)]
                    (.. " " line ":" col " "))
        :highlight :StatusLineMode}]])

   ;{:LineInfo {:provider #(.. " " (gl-fileinfo.line_column) " ")
             ;:highlight "GalaxyViMode"
             ;:separator ""}}])
       

; TODO
;Git-branch 
 ;{:provider #(let [branch (vim.fn.system "git rev-parse --abbrev-ref HEAD")]
             ;(if (= "master" branch) "" branch))
  ;:highlight :StatusLine}]])



;(set galaxyline.section.left
  ;[{:ViMode {:provider 
           ;#(let [vim-mode (nvim.fn.mode)
                  ;modedata (or (. modes vim-mode)
                               ;{:text vim-mode 
                                ;:colors {:bg colors.neutral_orange :fg colors.dark0}})] 
              ;(utils.highlight "GalaxyViMode" modedata.colors)
              ;(.. "  " modedata.text " "))}} 

   ;{:FileName {:provider get-current-filepath
             ;:highlight [colors.light4 bar-bg-col]}}

   ;{:Space {:provider #"" 
          ;:highlight [colors.light0 bar-bg-col]}}])

;(set galaxyline.section.right
  ;[{:GitBranch {:highlight [colors.light4 bar-bg-col] 
              ;:provider 
              ;#(let [branch (gl-vcs.get_git_branch)]
                 ;(if (= "master" branch) "" branch))}}

   ;{:FileType {:provider #nvim.bo.filetype
             ;:highlight [colors.neutral_aqua bar-bg-col]}}

   ;{:DiagnosticInfo {:provider (make-lsp-diagnostic-provider "Info")
                   ;:highlight [colors.dark1 colors.neutral_blue]}}
   ;{:DiagnosticWarn {:provider (make-lsp-diagnostic-provider "Warning")
                   ;:highlight [colors.dark1 colors.neutral_yellow]
                   ;:separator ""}}
   ;{:DiagnosticError {:provider (make-lsp-diagnostic-provider "Error")
                    ;:highlight [colors.dark1 colors.bright_red]
                    ;:separator ""}}
   ;{:LineInfo {:provider #(.. " " (gl-fileinfo.line_column) " ")
             ;:highlight "GalaxyViMode"
             ;:separator ""}}])

;(do
  ;(fn add-segment-defaults [data] 
    ;(a.merge {:highlight [colors.light0 bar-bg-col]
            ;:separator " " 
            ;:separator_highlight "StatusLine"} 
           ;data))
                  
  ;(fn map-gl-section [f section]
    ;(icollect [_ elem (ipairs section)]
      ;(collect [k v (pairs elem)] 
       ;(values k (f v)))))
 
  ;(set galaxyline.section.left (map-gl-section add-segment-defaults galaxyline.section.left))
  ;(set galaxyline.section.right (map-gl-section add-segment-defaults galaxyline.section.right)))






