(module dots.utils
  {autoload {a aniseed.core
             nvim aniseed.nvim
             str aniseed.string}
   require-macros [macros]})

(defn plugin-installed? [name]
  (~= nil (. packer_plugins name)))

(defn all [f xs]
  (not (a.some #(not (f $1)))))

(defn single-to-list [x]
  "Returns the list given to it. If given a single value, wraps it in a list"
  (if (a.table? x) x [x]))

(defn contains? [list elem]
  (or (a.some #(= elem $1) list)) false)

(defn filter-table [f t]
  (collect [k v (pairs t)]
    (when (f k v)
      (values k v))))


(defn split-last [s sep]
  "split a string at the last occurrence of a separator"
  (for [i (length s) 1 -1]
    (let [c (s:sub i i)]
      (when (= sep c)
        (let [left (s:sub 1 (- i 1))
              right (s:sub (+ i 1))]
          (lua "return { left, right }")))))
  [s])

(defn find-where [pred xs]
  (each [_ x (ipairs xs)]
    (when (pred x)
      (lua "return x"))))

(defn find-map [f xs]
  (each [_ x (ipairs xs)]
    (let [res (f x)]
      (when (~= nil res)
        (lua "return res")))))

(defn keep-if [f x]
  (when (f x) x))


(defn without-keys [keys t]
  (filter-table #(not (contains? keys $1)) t))

(defn keymap [modes from to ?opts]
  "Set a mapping in the given modes, and some optional parameters, defaulting to {:noremap true :silent true}.
  If :buffer is set, uses buf_set_keymap rather than set_keymap"
  (let [full-opts (->> (or ?opts {})
                       (a.merge {:noremap true :silent true})
                       (without-keys [:buffer]))]
    (each [_ mode (ipairs (single-to-list modes))]
      (if (-?> ?opts (. :buffer))
        (nvim.buf_set_keymap 0 mode from to full-opts)
        (nvim.set_keymap mode from to full-opts)))))

(defn del-keymap [mode from ?buf-local]
  "Remove a keymap. Arguments: mode, mapping, bool if mapping should be buffer-local."
  (if ?buf-local
    (nvim.buf_del_keymap 0 mode from)
    (nvim.del_keymap mode from)))

(defn safe-require [name]
  (xpcall 
    #(
      ;do
       ;(print name)
       ;(time 
        (require name)) 
    #(let [fennel (require :aniseed.fennel)]
      (a.println (.. "Error sourcing " name ":\n" (fennel.traceback $1))))))


(defn buffer-content [bufnr]
  "Returns a table of lines in the given buffer"
  (vim.api.nvim_buf_get_lines bufnr 0 -1 false))

(defn surround-if-present [a mid b]
  (if mid 
    (.. a mid b)
    ""))

(defn highlight [group-arg colset]
  (let [default { :fg "NONE" :bg "NONE" :gui "NONE"}
        opts (a.merge default colset)]
    (each [_ group (ipairs (single-to-list group-arg))]
      (nvim.command (.. "hi! "group" guifg='"opts.fg"' guibg='"opts.bg"' gui='"opts.gui"'")))))

(defn highlight-add [group-arg colset]
  (each [_ group (ipairs (single-to-list group-arg))]
    (nvim.command 
      (.. "hi! "
          group
          (surround-if-present " guibg='"colset.bg"'")
          (surround-if-present " guifg='"colset.fg"'")
          (surround-if-present " gui='"colset.gui"'")))))






(defn shorten-path [path seg-length shorten-after]
  "shorten a filepath by truncating the segments to n characters, if the path exceeds a given length"
  (let [segments (str.split path "/")]
    (if (or (> shorten-after (length path))
            (> 2 (length segments)))
      path
      (let [init (a.butlast segments)
            filename (a.last segments)
            shortened-segs (a.map #(string.sub $1 1 seg-length) init)]
        (.. (str.join "/" shortened-segs) "/" filename))))) 

(defn comp [f g]
  (fn [...]
    (f (g ...))))
