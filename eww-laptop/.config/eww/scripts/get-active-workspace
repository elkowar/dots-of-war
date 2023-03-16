#!/bin/bash
hyprctl monitors -j | jq --raw-output .[0].activeWorkspace.id
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | stdbuf -o0 grep '^workspace>>' | stdbuf -o0 awk -F '>>|,' '{print $2}'
