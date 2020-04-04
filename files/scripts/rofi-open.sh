#!/bin/bash



groups=$(ls "$HOME/scripts/bookmarks")
group_selection=$(echo -e "$groups" | rofi -i -matching fuzzy -p open -dmenu -no-custom -theme /home/leon/scripts/rofi-scripts/default_theme.rasi )

selection=$( cat "$HOME/scripts/bookmarks/$group_selection" | sed -r 's/^([^ ]*) .*$/\1/' | rofi -p open -matching fuzzy -dmenu -i -no-custom -theme /home/leon/scripts/rofi-scripts/default_theme.rasi )
[ -z "$selection" ] && exit 1

cat "$HOME/scripts/bookmarks/$group_selection" | sed -n -r "s/^$selection (.*)$/\1/p" | bash
