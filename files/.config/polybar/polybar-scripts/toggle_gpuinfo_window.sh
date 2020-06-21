#!/bin/bash

if [[ -n $(xdotool search --class bar_system_status_indicator) ]]; then
  xdotool search --class bar_system_status_indicator windowkill &
else
  termite --class bar_system_status_indicator -e "$1" &
fi
