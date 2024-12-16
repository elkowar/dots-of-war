#!/bin/sh


file="$(echo ~/wpms/* | xargs realpath | rofi -dmenu)"
if [ -f "$file" ]; then
  echo "$(date +%s) $(rofi -dmenu)" >> "$file"

else
  notify-send "No valid file given :/"
fi






