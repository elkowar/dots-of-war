#!/bin/bash

selection=$( cat ~/scripts/bookmarks | sed -r 's/^([^ ]*) .*$/\1/' | rofi -p open -dmenu -no-custom )
[ -z "$selection" ] && exit 1

cat ~/scripts/bookmarks | sed -n -r "s/^$selection (.*)$/\1/p" | bash
