#!/bin/dash
#sudo cat /sys/kernel/debug/dri/0/amdgpu_pm_info

sudo cat /sys/kernel/debug/dri/0/amdgpu_pm_info \
  | sed -n 's/^GPU Load: \(.*\)$/\1/gp'
