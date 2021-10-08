#!/usr/bin/env bash

#output="$(upower -i /org/freedesktop/UPower/devices/battery_BAT1)"
percentage="$(cat /sys/class/power_supply/BAT1/capacity)"
status="$(cat /sys/class/power_supply/BAT1/status)"


echo "${percentage}%"
