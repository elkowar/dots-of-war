(local wezterm (require "wezterm"))


(fn string? [x] (= "string" (type x)))

(fn gen-keys [entries]
  (icollect [_ x (pairs entries)]
    { :mods (. x 1)
      :key (. x 2) 
      :action (let [action (. x 3)]
                (if (string? action) action (wezterm.action action)))})) 
                  
                 
(fn merge [a b]
  (let [merged {}]
    (each [k v (pairs a)] (tset merged k v))
    (each [k v (pairs b)] (tset merged k v))
    merged))

(local gruvbox (. (wezterm.color.get_builtin_schemes) "GruvboxDarkHard"))

(local config (wezterm.config_builder))

(merge
  config
  {:font (wezterm.font "FiraMono Nerd Font")
   :scrollback_lines 10000
   :hide_tab_bar_if_only_one_tab true
   :color_scheme "GruvboxDarkHard"
   :leader { :mods "CTRL" :key "b" :timeout_milliseconds 500}

   :window_frame
   {:active_titlebar_bg "#1d2021"
    :inactive_titlebar_bg "#1d2021"}
    

   :colors (merge
             gruvbox
             {:tab_bar
              {:background "#282828"
               :inactive_tab {:bg_color "#1d2021" :fg_color gruvbox.foreground}
               :active_tab   {:bg_color gruvbox.background :fg_color gruvbox.foreground}
               :new_tab   {:bg_color "#1d2021" :fg_color gruvbox.foreground}}})
           
   :keys
   (gen-keys 
     [ [:CTRL   :+ "IncreaseFontSize"]
       [:LEADER :n "SpawnWindow"]
       [:LEADER :f "TogglePaneZoomState"]
       [:LEADER :p "ShowLauncher"]
       [:LEADER :t { :SpawnTab "CurrentPaneDomain"}]
       [:LEADER :c { :CloseCurrentTab {:confirm false}}]
       [:LEADER :l { :ActivateTabRelative 1}]
       [:LEADER :h { :ActivateTabRelative -1}]
       [:LEADER :v { :SplitVertical   {:domain "CurrentPaneDomain"}}]
       [:LEADER :b { :SplitHorizontal {:domain "CurrentPaneDomain"}}]
       [:LEADER :s { :Search {:CaseInSensitiveString ""}}]
       [:CTRL   :LeftArrow  { :ActivatePaneDirection "Left"}]
       [:CTRL   :RightArrow { :ActivatePaneDirection "Right"}]
       [:CTRL   :DownArrow  { :ActivatePaneDirection "Down"}]
       [:CTRL   :UpArrow    { :ActivatePaneDirection "Up"}]])})


;{ :font (wezterm.font "Terminus (TTF)")
  ;:hide_tab_bar_if_only_one_tab true
  ;:scrollback_lines 5000
  ;:line_height 0.91
  ;:window_padding { :left 20 :right 20 :top 20 :bottom 20}

  ;:leader { :mods "CTRL" :key "a" :timeout_milliseconds 500}
  ;:keys
  ;(gen-keys 
    ;[ [:CTRL   :+ "IncreaseFontSize"]
      ;[:LEADER :n "SpawnWindow"]
      ;[:LEADER :f "TogglePaneZoomState"]
      ;[:LEADER :p "ShowLauncher"]
      ;[:LEADER :t { :SpawnTab "CurrentPaneDomain"}]
      ;[:LEADER :c { :CloseCurrentTab {:confirm false}}]
      ;[:LEADER :l { :ActivateTabRelative 1}]
      ;[:LEADER :h { :ActivateTabRelative -1}]
      ;[:LEADER :v { :SplitVertical   {:domain "CurrentPaneDomain"}}]
      ;[:LEADER :b { :SplitHorizontal {:domain "CurrentPaneDomain"}}]
      ;[:LEADER :s { :Search {:CaseInSensitiveString ""}}]
      ;[:CTRL   :LeftArrow  { :ActivatePaneDirection "Left"}]
      ;[:CTRL   :RightArrow { :ActivatePaneDirection "Right"}]
      ;[:CTRL   :DownArrow  { :ActivatePaneDirection "Down"}]
      ;[:CTRL   :UpArrow    { :ActivatePaneDirection "Up"}]])

  ;:colors
  ;(merge color-theme
    ;{ :tab_bar
      ;{ :background color-theme.background
        ;:active_tab { :bg_color color-theme.accent :fg_color color-theme.background}
        ;:inactive_tab { :bg_color color-theme.background-light :fg_color color-theme.accent}
        ;:inactive_tab_hover { :bg_color color-theme.background-dark :fg_color color-theme.accent :italic false}}})}

