(module help-thingy
  {require {utils utils
            a aniseed.core
            str aniseed.string
            popup popup
            ts nvim-treesitter}
   require-macros [macros]})

(def helpfiles-path (str.join "/" (a.butlast (str.split vim.o.helpfile "/"))))

(def tags
  (var entries {})
  (each [line _ (io.lines (.. helpfiles-path "/tags"))]
    (let [[key file address] (str.split line "\t")]
      (tset entries key {:file (.. helpfiles-path "/" file) :address address})))
  entries)

(defn find-help-tag-for [topic]
  (or (. tags topic)
      (. tags (.. topic "()"))
      (. tags (.. (string.gsub topic "vim%.api%." "") "()"))
      (. tags (.. (string.gsub topic "vim%.fn%." "") "()"))
      (. tags (.. (string.gsub topic "fn%." "") "()"))
      (. tags (.. (string.gsub topic "vim%.o%." "") "()"))
      (. tags (.. (string.gsub topic "vim%.b%." "") "()"))
      (. tags (.. (string.gsub topic "vim%.g%." "") "()"))))


(defn help-for-tag [tag]
  (var data nil)
  (each [line _ (io.lines tag.file)]
    (if (= nil data)
      (when (~= -1 (vim.fn.match line (tag.address:sub 2)))
        (set data [line]))
      (if (or (> 2 (length data)) 
              (= "" line) 
              (= " "  (line:sub 1 1))
              (= "\t" (line:sub 1 1))
              (= "<"  (line:sub 1 1)))
        (table.insert data line)
        (lua "return data")))))

(fn _G.get_help []
  (if-let [help-tag (find-help-tag-for (get-current-word))]
    (pop (help-for-tag help-tag) :help)))

(utils.keymap :n :ML ":call v:lua.get_help()<CR>")

