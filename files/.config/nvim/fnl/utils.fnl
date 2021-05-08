(module utils
  {autoload {a aniseed.core
             fennel aniseed.fennel
             nvim aniseed.nvim}
   require-macros [macros]})
 
(defn plugin-installed? [name]
  (~= nil (. packer_plugins name)))

(defn all [f xs]
  (not (a.some (not (f $1)))))

(defn single-to-list [x]
  "Returns the list given to it. If given a single value, wraps it in a list"
  (if (a.table? x) x [x]))

(defn contains? [list elem]
  (or (a.some #(= elem $1) list)) false)

(defn filter-table [f t]
  (collect [k v (pairs t)]
    (when (f k v)
      (values k v))))

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

(defn- safe-require-plugin-config [name]
  (xpcall 
    #(require name) 
    #(a.println (.. "Error sourcing " name ":\n" (fennel.traceback $1)))))

(defn use [...]
  "Iterates through the arguments as pairs and calls packer's function for
  each of them. Works around Fennel not liking mixed associative and sequential
  tables as well.
  Additionally sources the file set in the :mod field of the plugin options"
  (let [pkgs [...]
        packer (require "packer")]
    (packer.startup
      (fn [use]
        (each-pair [name opts pkgs]
          (-?> opts (. :mod) (safe-require-plugin-config))
          (use (a.assoc opts 1 name)))))))


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


(defn comp [f g]
  (fn [...]
    (f (g ...))))
