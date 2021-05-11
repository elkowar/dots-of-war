(module help-thingy
  {require {utils utils
            a aniseed.core
            str aniseed.string
            fennel aniseed.fennel
            popup popup
            ts nvim-treesitter}
   require-macros [macros]})

(defn get-current-word []
  (let [col (. (vim.api.nvim_win_get_cursor 0) 2)
        line (vim.api.nvim_get_current_line)]
    (.. (vim.fn.matchstr (string.sub line 1 (+ col 1)) 
                         "\\k*$")
        (string.sub ( vim.fn.matchstr (string.sub line (+ col 1))
                                      "^\\k*")
                    2))))



(def helpfiles-path (str.join "/" (a.butlast (str.split vim.o.helpfile "/"))))

(def tags
  (let [entries {}]
    (each [line _ (io.lines (.. helpfiles-path "/tags"))]
      (let [[key file address] (str.split line "\t")]
        (tset entries key {:file (.. helpfiles-path "/" file) :address address})))
    entries))

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
  (var width 0)
  (each [_ line (ipairs text)]
    (when (> (length line) width)
      (set width (length line))))
  (let [bufnr (vim.api.nvim_create_buf false true)]
    (vim.api.nvim_buf_set_option bufnr :bufhidden "wipe")
    (vim.api.nvim_buf_set_option bufnr :filetype ft)
    (vim.api.nvim_buf_set_lines bufnr 0 -1 true text)
    (popup.create bufnr {:padding [1 1 1 1] :width width})))


(fn _G.get_help []
  (let [help-tag (find-help-tag-for (get-current-word))]
    (when help-tag
      (pop (help-for-tag help-tag) :help))))




(def all-module-paths
  (let [paths (str.split package.path ";")]
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


(defn read-module-file [module-name]
  (let [path (find-module-path module-name)]
    (when path
      (let [ft (match (string.gsub path ".+%.(%w+)" "%1")
                 :fnl "fennel"
                 :lua "lua")
            result (icollect [line _ (io.lines path)]
                     line)]
        (values result ft)))))


(defn gib-definition [mod word]
  (let [(file-lines filetype) (read-module-file mod)
        query (vim.treesitter.parse_query 
                filetype
                (.. "((identifier) @fuck (#contains? @fuck \"" word "\"))"))
        bufnr (vim.api.nvim_create_buf false true)]
    (vim.api.nvim_buf_set_lines bufnr 0 -1 true file-lines)
    (let [parser (vim.treesitter.get_parser bufnr filetype)
          [tstree] (parser:parse)
          tsnode (tstree:root)
          code-lines []]
      (each [id node metadata (query:iter_captures tsnode bufnr 0 -1)]
        (let [parent (node:parent)
              (r1 c1 r2 c2) (parent:range)]
          (for [i (+ r1 1) r2]
            (table.insert code-lines (. file-lines i)))))
      (pop code-lines filetype))))




(fn _G.gib_def []
  (let [word (get-current-word)
        segs (str.split word "%.")]
    (match segs
      [mod ident] 
      (gib-definition mod ident)

      [ident] 
      (let [[current-file] (str.split (vim.fn.expand "%:t") "%.")]
        (gib-definition current-file ident)))))



  ;(gib-definition "help-thingy" (ident)))
(utils.keymap :n :L ":call v:lua.get_help()<CR>")
(utils.keymap :n :N ":call v:lua.gib_def()<CR>")

; vim.api.nvim_buf_get_name
; vim.api.nvim_buf_call
; vim.api.nvim_buf_set_text
; vim.api.nvim_buf_set_var
; vim.fn.bufnr
