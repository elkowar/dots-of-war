#!/bin/sh

# This script watches the battery charging status and notifies the user
# when the battery is charging.

# The script is meant to be run in the background.


charging=false
while true; do
    if [ "$(cat /sys/class/power_supply/BAT1/status)" = "Charging" ]; then
        if [ $charging = "false" ]; then
            notify-send "Battery charging" "Run ~/scripts/conserve-battery false to charge to 100%"
        fi
        charging=true
    else
        if [ $charging = "true" ]; then
            notify-send "Charger disconnected"
        fi
        charging=false
    fi
    sleep 1
done
