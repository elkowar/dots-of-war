#!/bin/bash

options="screenshot\nscreengif"
selected="$(echo -e "$options" | rofi -dmenu -i -theme ~/scripts/rofi-scripts/default_theme.rasi)"
case "$selected" in
  screenshot)
    ~/scripts/screenshot.sh
    ;;
  screengif)
    notify-send gif "press M-S-C-g to end gif"
    ~/scripts/screengif.sh
    ;;
esac

