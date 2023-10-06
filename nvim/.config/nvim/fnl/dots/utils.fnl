(local {: autoload : a : str} (require :dots.prelude))

(fn plugin [name ?opts]
  (if (= nil ?opts)
    name
    (do
      (tset ?opts 1 name)
      ?opts)))

(fn all [f]
  (not (a.some #(not (f $1)))))

(fn single-to-list [x]
  "Returns the list given to it. If given a single value, wraps it in a list"
  (if (a.table? x) x [x]))

(fn contains? [list elem]
  (or (a.some #(= elem $1) list)) false)

(fn filter-table [f t]
  (collect [k v (pairs t)]
    (when (f k v)
      (values k v))))


(fn split-last [s sep]
  "split a string at the last occurrence of a separator"
  (for [i (length s) 1 -1]
    (let [c (s:sub i i)]
      (when (= sep c)
        (let [left (s:sub 1 (- i 1))
              right (s:sub (+ i 1))]
          (lua "return { left, right }")))))
  [s])

(fn find-where [pred xs]
  (each [_ x (ipairs xs)]
    (when (pred x)
      (lua "return x"))))

(fn find-map [f xs]
  (each [_ x (ipairs xs)]
    (let [res (f x)]
      (when (~= nil res)
        (lua "return res")))))

(fn keep-if [f x]
  (when (f x) x))

(fn map-values [f t]
  "Map over the values of a table, keeping the keys intact"
  (let [tbl {}]
    (each [k v (pairs t)] (tset tbl k (f v)))
    tbl))


(fn without-keys [keys t]
  (filter-table #(not (contains? keys $1)) t))

(fn keymap [modes from to ?opts]
  "Set a mapping in the given modes, and some optional parameters, defaulting to {:noremap true :silent true}.
  If :buffer is set, uses buf_set_keymap rather than set_keymap"
  (let [full-opts (->> (or ?opts {})
                       (a.merge {:noremap true :silent true})
                       (without-keys [:buffer]))]
    (each [_ mode (ipairs (single-to-list modes))]
      (let [keymap-opts (if (-?> ?opts (. :buffer)) (a.assoc full-opts :buffer 0) full-opts)]
        (vim.keymap.set mode from to keymap-opts)))))

(fn del-keymap [mode from ?buf-local]
  "Remove a keymap. Arguments: mode, mapping, bool if mapping should be buffer-local."
  (vim.keymap.del mode from
    (if ?buf-local {:buffer 0} {})))


(fn buffer-content [bufnr]
  "Returns a table of lines in the given buffer"
  (vim.api.nvim_buf_get_lines bufnr 0 -1 false))

(fn surround-if-present [a mid b]
  (if mid 
    (.. a mid b)
    ""))

(fn highlight [group-arg colset]
  (let [default { :fg "NONE" :bg "NONE" :gui "NONE"}
        opts (a.merge default colset)]
    (each [_ group (ipairs (single-to-list group-arg))]
      (vim.cmd (.. "hi! "group" guifg='"opts.fg"' guibg='"opts.bg"' gui='"opts.gui"'")))))

(fn highlight-add [group-arg colset]
  (each [_ group (ipairs (single-to-list group-arg))]
    (vim.cmd
      (.. "hi! "
          group
          (surround-if-present " guibg='"colset.bg"'")
          (surround-if-present " guifg='"colset.fg"'")
          (surround-if-present " gui='"colset.gui"'")))))






(fn shorten-path [path seg-length shorten-after]
  "shorten a filepath by truncating the segments to n characters, if the path exceeds a given length"
  (let [segments (str.split path "/")]
    (if (or (> shorten-after (length path))
            (> 2 (length segments)))
      path
      (let [init (a.butlast segments)
            filename (a.last segments)
            shortened-segs (a.map #(string.sub $1 1 seg-length) init)]
        (.. (str.join "/" shortened-segs) "/" filename))))) 

(fn comp [f g]
  (fn [...]
    (f (g ...))))


(fn get-selection []
  (let [[_ s-start-line s-start-col] (vim.fn.getpos "'<")
        [_ s-end-line s-end-col]     (vim.fn.getpos "'>")
        n-lines                      (+ 1 (math.abs (- s-end-line s-start-line)))
        lines                        (vim.api.nvim_buf_get_lines 0 (- s-start-line 1) s-end-line false)]
    (if (= nil (. lines 1))
      (values s-start-line s-end-line lines)
      (do
        (tset lines 1 (string.sub (. lines 1) s-start-col -1))
        (if (= 1 n-lines)
          (tset lines n-lines (string.sub (. lines n-lines) 1 (+ 1 (- s-end-col s-start-col))))
          (tset lines n-lines (string.sub (. lines n-lines) 1 s-end-col)))
        (values s-start-line s-end-line lines)))))

{: plugin
 : all
 : single-to-list
 : contains?
 : filter-table
 : split-last
 : find-where
 : find-map
 : keep-if
 : map-values
 : without-keys
 : keymap
 : del-keymap
 : buffer-content
 : surround-if-present
 : highlight
 : highlight-add
 : shorten-path
 : comp
 : get-selection}
