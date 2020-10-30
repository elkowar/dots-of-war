#! /bin/sh
#sudo cat /sys/kernel/debug/dri/0/amdgpu_pm_info

[ "$1" = "--watch" ] && \
  sudo watch --no-title -n "0.5" "cat /sys/kernel/debug/dri/0/amdgpu_pm_info | grep -A 10 'GFX Clocks and Power'" || \
  sudo cat "/sys/kernel/debug/dri/0/amdgpu_pm_info" \
  | sed -n 's/^GPU Load: \(.*\)$/\1/gp'
