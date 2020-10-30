#! /bin/sh

groups="$(ls "$HOME/scripts/bookmarks")\nauswahl"
group_selection="$(echo "$groups" | rofi -i -matching fuzzy -p open -dmenu -no-custom)"
[ "$group_selection" = "auswahl" ] && \
  auswahl "$(auswahl --list | rofi -dmenu -i -no-custom)" || \
  selection=$( cat "$HOME/scripts/bookmarks/$group_selection" | sed -r 's/^([^ ]*) .*$/\1/' | rofi -p open -matching fuzzy -dmenu -i -no-custom) && \
  [ -z "$selection" ] && exit 1

  cat "$HOME/scripts/bookmarks/$group_selection" | sed -n -r "s/^$selection (.*)$/\1/p" | bash
