#!/usr/bin/env bash

percentage="$(cat /sys/class/power_supply/BAT1/capacity)"
status="$(cat /sys/class/power_supply/BAT1/status)"



status_icon=""
case "$status" in
  "Charging")
    status_icon="ϟ";;
esac


echo "${status_icon}${percentage}%"
