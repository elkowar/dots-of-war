(module utils
  {autoload {a aniseed.core
             fennel aniseed.fennel
             nvim aniseed.nvim}
   require-macros [macros]})
 
(def req 
  (setmetatable {} {:__index (fn [_ idx] (require idx))}))

(defn plugin-installed? [name]
  (~= nil (. packer_plugins name)))

(defn dbg [x]
  (a.println (fennel.view x))
  x)


(defn contains? [list elem]
  (or (a.some #(= elem $1) list)) false)

(defn filter-table [f t]
  (collect [k v (pairs t)]
    (when (f k v)
      (values k v))))

(defn without-keys [keys t]
  (filter-table #(not (contains? keys $1)) t))

(defn keymap [mode from to ?opts]
  "Set a mapping in the given mode, and some optional parameters, defaulting to {:noremap true :silent true}.
  If :buffer is set, uses buf_set_keymap rather than set_keymap"
  (local full-opts 
    (->> (or ?opts {})
      (a.merge {:noremap true :silent true})
      (without-keys [:buffer])))
  (if (and ?opts (?. ?opts :buffer))
    (nvim.buf_set_keymap 0 mode from to full-opts)
    (nvim.set_keymap mode from to full-opts)))

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
          (-?> (. opts :mod) (safe-require-plugin-config))
          (use (a.assoc opts 1 name)))))))


(defn surround-if-present [a mid b]
  (if mid 
    (.. a mid b)
    ""))

(defn highlight [group-arg colset]
  (let [default { :fg "NONE" :bg "NONE" :gui "NONE"}
        opts (a.merge default colset)
        hl-groups (if (a.string? group-arg) [group-arg] group-arg)]
    (each [_ group (ipairs hl-groups)]
      (nvim.command (.. "hi! "group" guifg='"opts.fg"' guibg='"opts.bg"' gui='"opts.gui"'")))))

(defn highlight-add [group-arg colset]
  (let [hl-groups (if (a.string? group-arg) [group-arg] group-arg)]
    (each [_ group (ipairs hl-groups)]
      (nvim.command 
        (.. "hi! "
            group
            (surround-if-present " guibg='"colset.bg"'")
            (surround-if-present " guifg='"colset.fg"'")
            (surround-if-present " gui='"colset.gui"'"))))))


(defn comp [f g]
  (fn [...]
    (f (g ...))))
