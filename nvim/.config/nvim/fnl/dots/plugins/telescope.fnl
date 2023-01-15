(module dots.plugins.telescope
  {autoload {utils dots.utils
             telescope telescope
             actions telescope.actions
             colors dots.colors}})

(telescope.setup 
  {:defaults {:mappings {:i {:<esc> actions.close}}
              :file_ignore_patterns ["Cargo.lock" ".*.snap" "docs/theme/.*" "node%_modules/.*" "target/.*"]}
   :extensions {:ui-select [((. (require "telescope.themes") :get_dropdown))]}})
                  
(telescope.load_extension "dap")
(telescope.load_extension "ui-select")

(utils.keymap :n :<C-p> ":Telescope find_files<CR>")

(defn setup-telescope-theme []
  (def prompt "blacker")
  (if
    (= prompt "bright")
    (let [promptbg "#689d6a"]
      (utils.highlight-add :TelescopePromptBorder {:bg promptbg :fg promptbg})
      (utils.highlight-add :TelescopePromptNormal {:bg promptbg :fg colors.dark0})
      (utils.highlight-add :TelescopePromptTitle  {:bg promptbg :fg colors.dark1}))

    (= prompt "dark")
    (let [promptbg "#252525"]
      (utils.highlight-add :TelescopePromptBorder {:bg promptbg :fg promptbg})
      (utils.highlight-add :TelescopePromptNormal {:bg promptbg :fg colors.light2})
      (utils.highlight-add :TelescopePromptPrefix {:bg promptbg :fg colors.neutral_aqua})
      (utils.highlight-add :TelescopePromptTitle  {:bg colors.neutral_blue :fg colors.dark1}))

    (= prompt "black")
    (let [promptbg "#212526"]
      (utils.highlight-add :TelescopePromptBorder {:bg promptbg :fg promptbg})
      (utils.highlight-add :TelescopePromptNormal {:bg promptbg :fg colors.light2})
      (utils.highlight-add :TelescopePromptPrefix {:bg promptbg :fg colors.neutral_aqua})
      (utils.highlight-add :TelescopePromptTitle  {:bg colors.neutral_green :fg colors.dark1}))

    (= prompt "blacker")
    (let [promptbg "#1f2324"]
      (utils.highlight-add :TelescopePromptBorder {:bg promptbg :fg promptbg})
      (utils.highlight-add :TelescopePromptNormal {:bg promptbg :fg colors.light2})
      (utils.highlight-add :TelescopePromptPrefix {:bg promptbg :fg colors.neutral_aqua})
      (utils.highlight-add :TelescopePromptTitle  {:bg colors.neutral_blue :fg colors.dark1})))

  (def side "darker")
  (if
    (= side "brighter")
    (let [previewbg "#1f2324"]
      (utils.highlight-add :TelescopePreviewNormal {:bg previewbg})
      (utils.highlight-add :TelescopePreviewBorder {:bg previewbg :fg previewbg}))

    (= side "darker")
    (let [previewbg "#1a1e1f"]
      (utils.highlight-add :TelescopePreviewNormal {:bg previewbg})
      (utils.highlight-add :TelescopePreviewBorder {:bg previewbg :fg previewbg})))

  (utils.highlight-add :TelescopeBorder       {:bg colors.dark0_hard :fg colors.dark0_hard})
  (utils.highlight-add :TelescopeNormal       {:bg colors.dark0_hard})
  (utils.highlight-add :TelescopePreviewTitle {:bg colors.neutral_green :fg colors.dark1})
  (utils.highlight-add :TelescopeResultsTitle {:bg colors.neutral_aqua  :fg colors.dark1})

  (utils.highlight-add :TelescopeSelection    {:bg colors.neutral_aqua :fg colors.dark1}))

; TODO this is the hackiest thing I've ever done
(vim.defer_fn setup-telescope-theme 50)

