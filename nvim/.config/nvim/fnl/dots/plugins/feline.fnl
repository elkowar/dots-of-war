(module dots.plugins.feline
  {autoload {a aniseed.core
             nvim aniseed.nvim
             utils dots.utils
             str aniseed.string
             colors dots.colors
             view aniseed.view
             feline feline
             feline-git feline.providers.git
             feline-lsp feline.providers.lsp}
   require-macros [macros]})


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

;(def bar-bg colors.dark1)
(def bar-bg colors.dark0)

(defn or-empty [x] (or x ""))
(defn spaces [x] (if x (.. " " x " ") ""))

(defn get-current-filepath []
   (let [file (utils.shorten-path (vim.fn.bufname) 5 50)]
      (if (a.empty? file) ""
         nvim.bo.readonly (.. "RO " file)
         (and nvim.bo.modifiable nvim.bo.modified) (.. file "●")
         (.. file " "))))

(defn lsp-diagnostic-component [kind color]
   {:enabled #(~= 0 (vim.lsp.diagnostic.get_count 0 kind))
    :provider #(spaces (vim.lsp.diagnostic.get_count 0 kind))
    :left_sep ""
    :right_sep ""
    :hl {:fg bar-bg :bg color}})


(defn vim-mode-hl [use-as-fg?]
   (let [color (. modes (vim.fn.mode) :color)] 
      (if use-as-fg? {:bg bar-bg :fg color} {:bg color :fg bar-bg})))

(defn git-status-provider []
   (or-empty (utils.keep-if #(~= "master" $1) 
                            (?. vim.b :gitsigns_status_dict :head))))


(defn lsp-progress-provider []
   (let [msgs (vim.lsp.util.get_progress_messages)
         s (icollect [_ msg (ipairs msgs)]
                     (when msg.message
                        (.. msg.title " " msg.message)))]
      (or-empty (str.join " | " s))))


(def components {:active {} :inactive {}})

(tset components.active 1
     [{:provider #(.. " " (or (. modes (vim.fn.mode) :text) vim.fn.mode) " ")
       :hl #(vim-mode-hl false)} 
      {:provider get-current-filepath :left_sep " "}
      {:provider git-status-provider :left_sep " " :hl #(vim-mode-hl true)}]) 

(tset components.active 2
     [{:provider lsp-progress-provider
       :enabled #(< 0 (length (vim.lsp.buf_get_clients)))}])


(tset components.active 3
     [{:provider #vim.bo.filetype 
       :hl #(vim-mode-hl true) 
       :right_sep " "}
      (lsp-diagnostic-component "Information" colors.neutral_purple)
      (lsp-diagnostic-component "Hint" colors.neutral_blue)
      (lsp-diagnostic-component "Warn" colors.neutal_yellow)
      (lsp-diagnostic-component "Error" colors.neutral_red)
      {:provider #(let [[line col] (vim.api.nvim_win_get_cursor 0)] (.. " " line ":" col " "))
       :hl #(vim-mode-hl false)}]) 


(feline.setup
   {:colors {:bg bar-bg
             :fg colors.dark4}
    :components components})

