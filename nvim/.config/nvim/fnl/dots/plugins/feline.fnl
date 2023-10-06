(import-macros m :macros)
(m.al a nfnl.core)
(m.al utils dots.utils)
(m.al str nfnl.string)
(m.al colors dots.colors)
(m.al feline feline)
(m.al feline-git feline.providers.git)
(m.al feline-lsp feline.providers.lsp)

(fn setup [])
(set vim.opt.termguicolors true)

(local modes 
  {:n   {:text "NORMAL"        :color colors.neutral_aqua}
   :i   {:text "INSERT"        :color colors.neutral_yellow}
   :c   {:text "CMMAND"        :color colors.neutral_aqua}
   :ce  {:text "NORMEX"        :color colors.neutral_aqua}
   :cv  {:text "EX"            :color colors.neutral_aqua}
   :ic  {:text "INSCOMP"       :color colors.neutral_aqua}
   :no  {:text "OP-PENDING"    :color colors.neutral_aqua}
   :r   {:text "HIT-ENTER"     :color colors.neutral_aqua}
   :r?  {:text "CONFIRM"       :color colors.neutral_aqua}
   :R   {:text "REPLACE"       :color colors.neutral_aqua}
   :Rv  {:text "VIRTUAL"       :color colors.neutral_aqua}
   :s   {:text "SELECT"        :color colors.neutral_aqua}
   :S   {:text "SELECT"        :color colors.neutral_aqua}
   :t   {:text "TERM"          :color colors.neutral_aqua}
   :v   {:text "VISUAL"        :color colors.neutral_blue}
   :V   {:text "VISUAL LINE"   :color colors.neutral_blue}
   "" {:text "VISUAL BLOCK"  :color colors.neutral_blue}})

(local bar-bg colors.bg_main)
(local horiz-separator-color colors.light1) 

(fn or-empty [x] (or x ""))
(fn spaces [x] (if x (.. " " x " ") ""))

(fn get-current-filepath []
  (let [file (utils.shorten-path (vim.fn.bufname) 30 30)]
    (if (a.empty? file) ""
       vim.bo.readonly (.. "RO " file)
       (and vim.bo.modifiable vim.bo.modified) (.. file " ●")
       (.. file " "))))

(fn vim-mode-hl [use-as-fg?]
  (let [color (. modes (vim.fn.mode) :color)] 
    (if use-as-fg? {:bg bar-bg :fg color} {:bg color :fg bar-bg})))

(fn git-status-provider []
  (or-empty (utils.keep-if #(~= "master" $1)
                           (?. vim.b :gitsigns_status_dict :head))))

(fn vim-mode []
  (.. " " (or (. modes (vim.fn.mode) :text) vim.fn.mode) " "))

(fn lsp-progress-provider []
  (let [msgs (vim.lsp.util.get_progress_messages)
        s (icollect [_ msg (ipairs msgs)]
                    (when msg.message
                       (.. msg.title " " msg.message)))]
     (or-empty (str.join " | " s))))



(fn lsp-diagnostic-component [kind color]
  {:enabled #(~= 0 (length (vim.diagnostic.get 0 {:severity kind})))
   :provider #(spaces (length (vim.diagnostic.get 0 {:severity kind})))
   :left_sep ""
   :right_sep ""
   :hl {:fg bar-bg :bg color}})

(fn coordinates []
  (let [[line col] (vim.api.nvim_win_get_cursor 0)]
    (.. " " line " ")))


  ; Fills the bar with an horizontal line
(fn inactive-separator-provider []
  (if (not= (vim.fn.winnr) (vim.fn.winnr :j))
    (string.rep "─" (vim.api.nvim_win_get_width 0))
    ""))
          
(local components {:active {} :inactive {}})

(tset components.active 1
  [{:provider vim-mode :hl #(vim-mode-hl false)} 
   {:provider get-current-filepath :left_sep " " :hl {:fg colors.light4}}
   {:provider git-status-provider :left_sep " " :hl #(vim-mode-hl true)}]) 

(tset components.active 2
  [{:provider lsp-progress-provider
    :left_sep " "
    :right_sep " "
    :enabled #(< 0 (length (vim.lsp.buf_get_clients)))}])

(tset components.active 3
  [{:provider vim.bo.filetype :right_sep " " :hl #(vim-mode-hl true)}
   (lsp-diagnostic-component vim.diagnostic.severity.INFO colors.neutral_green)
   (lsp-diagnostic-component vim.diagnostic.severity.HINT colors.neutral_aqua)
   (lsp-diagnostic-component vim.diagnostic.severity.WARN colors.neutral_yellow)  
   (lsp-diagnostic-component vim.diagnostic.severity.ERROR colors.neutral_red)
   {:provider coordinates :hl #(vim-mode-hl false)}])

(tset components.inactive 1
  [{:provider inactive-separator-provider 
    :hl {:bg "NONE" :fg horiz-separator-color}}])



(utils.highlight-add :StatusLineNC {:bg "NONE" :fg colors.light1})

(feline.setup {:theme {:fg colors.light1 :bg colors.bg_main}
               :components components})

[(utils.plugin :Famiu/feline.nvim {:config setup})]
