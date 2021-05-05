(module utils
  {require {a aniseed.core
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




(def colors
  { :dark0_hard "#1d2021"
    :dark0 "#282828"
    :dark0_soft "#32302f"
    :dark1 "#3c3836"
    :dark2 "#504945"
    :dark3 "#665c54"
    :dark4 "#7c6f64"
    :light0_hard "#f9f5d7"
    :light0 "#fbf1c7"
    :light0_soft "#f2e5bc"
    :light1 "#ebdbb2"
    :light2 "#d5c4a1"
    :light3 "#bdae93"
    :light4 "#a89984"
    :bright_red "#fb4934"
    :bright_green "#b8bb26"
    :bright_yellow "#fabd2f"
    :bright_blue "#83a598"
    :bright_purple "#d3869b"
    :bright_aqua "#8ec07c"
    :bright_orange "#fe8019"
    :neutral_red "#cc241d"
    :neutral_green "#98971a"
    :neutral_yellow "#d79921"
    :neutral_blue "#458588"
    :neutral_purple "#b16286"
    :neutral_aqua "#689d6a"
    :neutral_orange "#d65d0e"
    :faded_red "#9d0006"
    :faded_green "#79740e"
    :faded_yellow "#b57614"
    :faded_blue "#076678"
    :faded_purple "#8f3f71"
    :faded_aqua "#427b58"
    :faded_orange "#af3a03"
    :gray "#928374"})

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
