(module help-thingy
  {require {utils utils
            a aniseed.core
            str aniseed.string
            fennel aniseed.fennel
            popup popup
            ts nvim-treesitter}
   require-macros [macros]})

(defn in-range [lines r1 c1 r2 c2]
  (var res [])
  (for [i r1 r2]
    (let [line         (. lines (+ i 1))
          trimmed-line (line:sub (if (= r1 i) (+ c1 1) 1) 
                                 (if (= r2 i) (+ c2 1) -1))]
      (table.insert res trimmed-line)))
  res)

(def- query-module-header
  (vim.treesitter.parse_query
    "fennel"
    "(function_call 
      name: (identifier) @module-header-name (#eq? @module-header-name \"module\")
      (identifier) @module-name
      (table ((identifier) @import-type
              (table ((identifier) @key (_) @value)*)
             )*
      )
     )"))

(defn read-module-imports-fnl [bufnr]
  (let [parser   (vim.treesitter.get_parser bufnr "fennel")
        [tstree] (parser:parse)
        tsnode   (tstree:root)]
    (var last-module nil)
    (var modules {})
    (each [id node metadata (query-module-header:iter_captures tsnode bufnr 0 -1)]
      (let [name          (. query-module-header.captures id)
            (r1 c1 r2 c2) (node:range)
            node-text     (vim.treesitter.get_node_text node 0)]
        (match name
          :key   (set last-module node-text)
          :value (tset modules last-module node-text))))
    modules))

(defn get-current-word []
  (let [col  (. (vim.api.nvim_win_get_cursor 0) 2)
        line (vim.api.nvim_get_current_line)]
    (.. (vim.fn.matchstr (line:sub 1 (+ col 1)) 
                         "\\k*$")
        (string.sub (vim.fn.matchstr (line:sub (+ col 1))
                                     "^\\k*")
                    2))))

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

(defn pop [text ft]
  "Open a popup with the given text and filetype"
  (var width 20)
  (each [_ line (ipairs text)]
    (set width (math.max width (length line))))
  (let [bufnr (vim.api.nvim_create_buf false true)]
    (vim.api.nvim_buf_set_option bufnr :bufhidden "wipe")
    (vim.api.nvim_buf_set_option bufnr :filetype ft)
    (vim.api.nvim_buf_set_lines bufnr 0 -1 true text)
    (popup.create bufnr {:padding [1 1 1 1] :width width})))


(fn _G.get_help []
  (if-let [help-tag (find-help-tag-for (get-current-word))]
    (pop (help-for-tag help-tag) :help)))




(def all-module-paths
  (do
    (var paths (str.split package.path ";"))
    (each [_ path (ipairs (str.split vim.o.runtimepath ","))]
      (table.insert paths (.. path "/fnl/?.fnl"))
      (table.insert paths (.. path "/fnl/?/init.fnl"))
      (table.insert paths (.. path "/lua/?.lua"))
      (table.insert paths (.. path "/lua/?/init.lua")))
    paths))


(defn file-exists? [path]
  (let [file (io.open path :r)]
    (if (~= nil file)
      (do (io.close file)
        true)
      false)))

(defn find-module-path [module-name]
  (let [module-name (module-name:gsub "%." "/")]
    (utils.find-map #(utils.keep-if file-exists? ($1:gsub "?" module-name))
                    all-module-paths)))


(defn get-filetype [filename]
  "Return the filetype given a files name"
  (match (utils.split-last filename ".")
    [_ :fnl] "fennel"
    [_ :lua] "lua"))

(defn read-module-file [module-name]
  "Given the name of a module, returns two values: 
   the lines of the file that matched a given module
   and the filetype of that module"
  (if-let [path (find-module-path module-name)]
    (let [ft     (get-filetype path)
          result (icollect [line _ (io.lines path)] line)]
      (values result ft))))

;(defn make-def-query [symbol])
  ;(vim.treesitter.parse_query 
    ;"fennel"
    ;(.. "(function_call
          ;name: (identifier) @fn-name (#eq? @fn-name \"defn\")
          ;(identifier) @symbol-name (#contains? @symbol-name \"" symbol "\"))")))
(defn make-def-query [symbol]
  (vim.treesitter.parse_query 
    "fennel"
    (.. "(function_call
          name: (identifier)
          (identifier) @symbol-name (#contains? @symbol-name \"" symbol "\"))")))
;(defn make-def-query [symbol]
  ;(vim.treesitter.parse_query 
    ;"fennel" 
    ;(.. "((identifier) @symbol-name (#contains? @symbol-name \"" symbol "\"))")))


(defn create-buf-with [lines]
  "create a buffer and fill it with the given lines"
  (let [bufnr (vim.api.nvim_create_buf false true)]
    (vim.api.nvim_buf_set_lines bufnr 0 -1 true lines)
    bufnr))

(defn find-definition-node-fnl [lines symbol]
  (let [query      (make-def-query symbol)
        bufnr      (create-buf-with lines)
        parser     (vim.treesitter.get_parser bufnr "fennel")
        [tstree]   (parser:parse)
        tsnode     (tstree:root)]
    (each [id node metadata (query:iter_captures tsnode bufnr 0 -1)]
      (let [name          (. query.captures id)]
        (when (= name "symbol-name")
          (lua "return node"))))))

(defn find-definition-str-fnl [lines symbol]
  (if-let [node          (find-definition-node-fnl lines symbol)]
    (let [parent        (node:parent)
          (r1 c1 r2 c2) (parent:range)]
      (var code-lines [])
      (for [i (+ r1 1) r2]
        (table.insert code-lines (. lines i)))
      code-lines)))


(defn gib-definition [mod word]
  (let [imports                  (read-module-imports-fnl 0)
        actual-mod               (or (. imports mod) mod)
        (module-lines module-ft) (read-module-file actual-mod)]
    (if-let [definition-lines (find-definition-str-fnl module-lines word)]
      (pop definition-lines module-ft))))

(fn _G.gib_def []
  (xpcall
    (fn []
      (let [word (get-current-word)
            segs (utils.split-last word ".")]
        (match segs
          [mod ident] 
          (gib-definition mod ident)

          [ident] 
          (let [[current-file] (utils.split-last (vim.fn.expand "%:t") ".")]
            (gib-definition current-file ident)))))
    #(print (fennel.traceback $1))))


  ;(gib-definition "help-thingy" (ident)))
(utils.keymap :n :L ":call v:lua.get_help()<CR>")
(utils.keymap :n :N ":call v:lua.gib_def()<CR>")

; vim.api.nvim_buf_get_name
; vim.api.nvim_buf_call
; vim.api.nvim_buf_set_text
; vim.api.nvim_buf_set_var
; vim.fn.bufnr
