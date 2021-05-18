(module dots.plugins.galaxyline
  {autoload {a aniseed.core
             str aniseed.string
             nvim aniseed.nvim 
             utils dots.utils
             colors dots.colors
            
             galaxyline galaxyline 
             gl-condition galaxyline.condition 
             gl-fileinfo galaxyline.provider_fileinfo 
             gl-diagnostic galaxyline.provider_diagnostic 
             gl-vcs galaxyline.provider_vcs} 
            
    require-macros [macros]})

(def- bar-bg-col colors.dark1)

(local modes 
 {:n   {:text "NORMAL"        :colors {:bg colors.neutral_aqua   :fg colors.dark0}}
  :i   {:text "INSERT"        :colors {:bg colors.neutral_yellow :fg colors.dark0}}
  :c   {:text "CMMAND"        :colors {:bg colors.neutral_aqua   :fg colors.dark0}}
  :ce  {:text "NORMEX"        :colors {:bg colors.neutral_aqua   :fg colors.dark0}}
  :cv  {:text "EX"            :colors {:bg colors.neutral_aqua   :fg colors.dark0}}
  :ic  {:text "INSCOMP"       :colors {:bg colors.neutral_aqua   :fg colors.dark0}}
  :no  {:text "OP-PENDING"    :colors {:bg colors.neutral_aqua   :fg colors.dark0}}
  :r   {:text "HIT-ENTER"     :colors {:bg colors.neutral_aqua   :fg colors.dark0}}
  :r?  {:text "CONFIRM"       :colors {:bg colors.neutral_aqua   :fg colors.dark0}}
  :R   {:text "REPLACE"       :colors {:bg colors.neutral_aqua   :fg colors.dark0}}
  :Rv  {:text "VIRTUAL"       :colors {:bg colors.neutral_aqua   :fg colors.dark0}}
  :s   {:text "SELECT"        :colors {:bg colors.neutral_aqua   :fg colors.dark0}}
  :S   {:text "SELECT"        :colors {:bg colors.neutral_aqua   :fg colors.dark0}}
  :t   {:text "TERM"          :colors {:bg colors.neutral_aqua   :fg colors.dark0}}
  :v   {:text "VISUAL"        :colors {:bg colors.neutral_blue   :fg colors.dark0}}
  :V   {:text "VISUAL LINE"   :colors {:bg colors.neutral_blue   :fg colors.dark0}}
  "" {:text "VISUAL BLOCK"  :colors {:bg colors.neutral_blue   :fg colors.dark0}}})

(fn get-current-filename []
  (nvim.fn.expand "%:t"))

(fn get-current-filepath []
  (let [file (utils.shorten-path (vim.fn.bufname) 5 50)]
    (if (a.empty? file) ""
        nvim.bo.readonly (.. "RO " file)
        (and nvim.bo.modifiable nvim.bo.modified) (.. file " ")
        file)))
 
(set galaxyline.short_line_list ["dbui" "diff" "peekaboo" "undotree" "vista" "vista_markdown"])

(fn make-lsp-diagnostic-provider [kind]
  (fn []
    (let [n (vim.lsp.diagnostic.get_count 0 kind)]
      (if (= n 0) "" (.. " " n " ")))))


(set galaxyline.section.left
  [{:ViMode {:provider 
             #(let [vim-mode (nvim.fn.mode)
                    modedata (or (. modes vim-mode)
                                 {:text vim-mode 
                                  :colors {:bg colors.neutral_orange :fg colors.dark0}})] 
                (utils.highlight "GalaxyViMode" modedata.colors)
                (.. "  " modedata.text " "))}} 

   {:FileName {:provider get-current-filepath
               :highlight [colors.light4 bar-bg-col]}}

   {:Space {:provider #"" 
            :highlight [colors.light0 bar-bg-col]}}])

(set galaxyline.section.right
  [{:GitBranch {:highlight [colors.light4 bar-bg-col] 
                :provider 
                #(let [branch (gl-vcs.get_git_branch)]
                   (if (= "master" branch) "" branch))}}

   {:FileType {:provider #nvim.bo.filetype
               :highlight [colors.neutral_aqua bar-bg-col]}}

   {:DiagnosticInfo {:provider (make-lsp-diagnostic-provider "Info")
                     :highlight [colors.dark1 colors.neutral_blue]}}
   {:DiagnosticWarn {:provider (make-lsp-diagnostic-provider "Warning")
                     :highlight [colors.dark1 colors.neutral_yellow]
                     :separator ""}}
   {:DiagnosticError {:provider (make-lsp-diagnostic-provider "Error")
                      :highlight [colors.dark1 colors.bright_red]
                      :separator ""}}
   {:LineInfo {:provider #(.. " " (gl-fileinfo.line_column) " ")
               :highlight "GalaxyViMode"
               :separator ""}}])

(do
  (fn add-segment-defaults [data] 
    (a.merge {:highlight [colors.light0 bar-bg-col]
              :separator " " 
              :separator_highlight "StatusLine"} 
             data))
                  
  (fn map-gl-section [f section]
    (icollect [_ elem (ipairs section)]
      (collect [k v (pairs elem)] 
        (values k (f v)))))
 
  (set galaxyline.section.left (map-gl-section add-segment-defaults galaxyline.section.left))
  (set galaxyline.section.right (map-gl-section add-segment-defaults galaxyline.section.right)))




