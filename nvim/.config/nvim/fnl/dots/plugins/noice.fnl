(module dots.plugins.noice
  {autoload {a aniseed.core
             lazy lazy
             noice noice
             colors dots.colors
             utils dots.utils}


   require-macros [macros]})

(noice.setup 
  {:presets {:inc_rename true
             :long_message_to_split true
             :bottom_search true}
             ;:command_palette true}
   :lsp {:override {:vim.lsp.util.convert_input_to_markdown_lines true
                    :vim.lsp.util.stylize_markdown true
                    :cmp.entry.get_documentation true}}
   :views {:cmdline_popup {:border {:style "none" :padding [1 1]}
                           :position {:row 5 :col "50%"}
                           :size {:width 60 :height "auto"}}
           :popupmenu {:relative "editor"
                       :border {:style "none" :padding [1 1]}
                       :position {:row 8 :col "50%"}
                       :size {:width 60 :height 10}}
           :mini      {:max_height 5}}
   :cmdline {:view "cmdline_popup" ; change to cmdline
             :format {:cmdline {:icon ":"}
                      :lua false
                      :help false}}
   :messages {:view "mini"
              :view_error "cmdline_output"
              :view_warn "mini"
              :view_search "virtualtext"}
   :markdown {:hover {"|(%S-)|" vim.cmd.help}}
   :routes [{:view "notify" :filter {:event "msg_showmode"}}
            {:view "mini"
             :filter {:error true :max_height 5}}
            {:view "cmdline_output"
             :filter {:error true :min_height 6}}]})

(+ 1 b)
(defn- setup-noice-theme []
  (utils.highlight-add :NoicePopupmenu {:bg colors.dark0_hard})
  (utils.highlight-add :NoiceCmdline {:bg "#1f2324"})
  (utils.highlight-add :NoiceCmdlinePopup {:bg "#1f2324"})
  (utils.highlight-add :NoiceCmdlinePrompt {:bg "#1f2324"})
  (utils.highlight-add :NoiceCmdlinePopupBorder {:fg colors.bright_aqua})
  (utils.highlight-add :NoiceCmdlineIcon {:fg colors.bright_aqua}))


(vim.defer_fn setup-noice-theme 200)
