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


(local color-theme
  { :background "#282828"
    :background-dark "#1d2021"
    :background-light "#3c3836"
    :foreground "#ebdbb2"
    :cursor_bg "#8ec07c"
    :cursor_border "#8ec07c"
    :cursor_fg "#282828"
    :selection_bg "#e6d4a3"
    :selection_fg "#534a42"
    :ansi    [ "#282828" "#cc241d" "#98971a" "#d79921" "#458588" "#b16286" "#689d6a" "#a89984"]
    :brights [ "#928374" "#fb4934" "#b8bb26" "#fabd2f" "#83a598" "#d3869b" "#8ec07c" "#ebdbb2"]
    :accent "#689d6a"})


{ :font (wezterm.font "Terminus (TTF)")
  :hide_tab_bar_if_only_one_tab true
  :scrollback_lines 5000
  :line_height 0.91
  :window_padding { :left 20 :right 20 :top 20 :bottom 20}

  :leader { :mods "CTRL" :key "a" :timeout_milliseconds 500}
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
      [:CTRL   :UpArrow    { :ActivatePaneDirection "Up"}]])

  :colors
    (merge color-theme
      { :tab_bar
        { :background color-theme.background
          :active_tab { :bg_color color-theme.accent :fg_color color-theme.background}
          :inactive_tab { :bg_color color-theme.background-light :fg_color color-theme.accent}
          :inactive_tab_hover { :bg_color color-theme.background-dark :fg_color color-theme.accent :italic false}}})}

