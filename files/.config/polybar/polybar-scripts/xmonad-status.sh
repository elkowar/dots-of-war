#!/bin/bash

if [ "$MONITOR" = "HDMI-A-0" ]; then
  while true; do
    tail -F /tmp/xmonad-state-bar0
  done
else
  while true; do
    tail -F /tmp/xmonad-state-bar1
  done
fi

#while true; do
  #if read -r line </tmp/.xmonad-state-bar0; then
    #echo "$line"
  #fi
#done
