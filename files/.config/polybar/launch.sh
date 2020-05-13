#!/bin/bash

killall -q polybar
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log


outputs=$(xrandr --query | grep " connected" | cut -d" " -f1)
tray_output=HDMI-A-0
for m in $outputs; do
  if [[ $m == "DisplayPort-1" ]]; then
    tray_output=$m
  fi
done

for m in $outputs; do
  export MONITOR=$m
  export TRAY_POSITION=none
  if [[ $m == "$tray_output" ]]; then
    TRAY_POSITION=right
  fi
  MONITOR=$m polybar -r --config=/home/leon/.config/polybar/config.ini main & # >>/tmp/polybar1.log 2>&1 &
done

#polybar --config=/home/leon/.config/polybar/config.ini main >>/tmp/polybar1.log 2>&1 &
