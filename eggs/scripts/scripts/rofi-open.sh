#!/bin/bash



groups="$(ls "$HOME/scripts/bookmarks")\nauswahl"
group_selection=$(echo -e "$groups" | rofi -i -matching fuzzy -p open -dmenu -no-custom)
if [ "$group_selection" = "auswahl" ]; then
  auswahl "$(auswahl --list | rofi -dmenu -i -no-custom)"
else
  selection=$( cat "$HOME/scripts/bookmarks/$group_selection" | sed -r 's/^([^ ]*) .*$/\1/' | rofi -p open -matching fuzzy -dmenu -i -no-custom)
  [ -z "$selection" ] && exit 1

  cat "$HOME/scripts/bookmarks/$group_selection" | sed -n -r "s/^$selection (.*)$/\1/p" | bash
fi
