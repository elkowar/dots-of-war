#!/bin/bash

killall -q polybar
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log

# for loop only for multi monitor
for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
  MONITOR=$m polybar --config=/home/leon/.config/polybar/config.ini main >>/tmp/polybar1.log 2>&1 &
done

#polybar --config=/home/leon/.config/polybar/config.ini main >>/tmp/polybar1.log 2>&1 &
