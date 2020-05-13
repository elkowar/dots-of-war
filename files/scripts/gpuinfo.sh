#!/bin/dash
#sudo cat /sys/kernel/debug/dri/0/amdgpu_pm_info


if [ "$1" = "--watch" ]; then
  sudo watch --no-title -n 0.5 "cat /sys/kernel/debug/dri/0/amdgpu_pm_info | grep -A 10 'GFX Clocks and Power'"
else
  sudo cat /sys/kernel/debug/dri/0/amdgpu_pm_info \
    | sed -n 's/^GPU Load: \(.*\)$/\1/gp'
fi
