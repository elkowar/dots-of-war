(import-macros {: al} :macros)
(al a nfnl.core)
(al cmp cmp)
(al utils dots.utils)


(fn setup []
  ; check this for coloring maybe
  ; https://github.com/hrsh7th/nvim-cmp/blob/ada9ddeff71e82ad0e52c9a280a1e315a8810b9a/lua/cmp/entry.lua#L199
  (fn item-formatter [item vim-item]
    (let [padding (string.rep " " (- 10 (vim.fn.strwidth vim-item.abbr)))
          details (?. item :completion_item :detail)]
      (when details
        (set vim-item.abbr (.. vim-item.abbr padding " " details))))
    vim-item)


  (cmp.setup
    {:snippet {:expand (fn [args] ((. vim.fn :vsnip#anonymous) args.body))}

     :completion {:autocomplete false}

     :mapping (cmp.mapping.preset.insert
                {:<C-d> (cmp.mapping.scroll_docs -4)
                 :<C-f> (cmp.mapping.scroll_docs 4)
                 :<C-space> (cmp.mapping.complete)
                 :<esc> #(do (cmp.mapping.close) (vim.cmd "stopinsert"))
                 :<CR>  (cmp.mapping.confirm {:select true})})

     :experimental {:custom_menu true}

     :sources [{:name "nvim_lsp" :priority 5}
               {:name "vsnip" :priority 3}
               ; {:name "omni"} ; this prints the completion thing, for some reason,....
               {:name "nvim_lua"}
               {:name "calc"}
               {:name "path"}
               {:name "nvim_lsp_signature_help"}
               {:name "conventionalcommits"}
               {:name "crates"}]
               ;{:name "buffer"}]

     :formatting {:format item-formatter}

     :sorting {:priority_weight 2
               :comparators [#(do (if (and (= 15 ($1:get_kind)) (= 15 ($2:get_kind))) nil
                                      (= 15 ($1:get_kind)) false 
                                      (= 15 ($2:get_kind)) true
                                      nil)) ; 15 means "SNIPPET", see https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/types/lsp.lua
                             cmp.config.compare.offset
                             cmp.config.compare.exact
                             cmp.config.compare.score
                             cmp.config.compare.kind
                             cmp.config.compare.sort_text
                             cmp.config.compare.length
                             cmp.config.compare.order]}})
                             
  (cmp.setup.cmdline "/" {:sources [{:name :buffer}]}))

[(utils.plugin :hrsh7th/vim-vsnip {:lazy true :event ["VeryLazy"]})
 (utils.plugin :hrsh7th/vim-vsnip-integ {:lazy true :event ["VeryLazy"]})
 (utils.plugin :rafamadriz/friendly-snippets)
 (utils.plugin :hrsh7th/nvim-cmp {:lazy true
                                  :event ["VeryLazy"]
                                  :dependencies [[:hrsh7th/cmp-nvim-lsp] 
                                                 [:hrsh7th/cmp-buffer]
                                                 [:hrsh7th/cmp-vsnip]
                                                 [:hrsh7th/cmp-nvim-lua]
                                                 [:hrsh7th/cmp-calc]
                                                 [:hrsh7th/cmp-path]
                                                 [:hrsh7th/cmp-nvim-lsp-signature-help]
                                                 [:davidsierradz/cmp-conventionalcommits]
                                                 [:hrsh7th/cmp-omni]]
                                  :config setup})]
