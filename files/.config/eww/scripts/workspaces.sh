#!/usr/bin/env bash

monitor="$1"

gib_workspace_names() {
  wmctrl -d \
    | awk '{ print $1 " " $2 " " $9 }' \
    | grep -v NSP \
    | grep "${monitor}_"
}

gib_workspace_xml() {
  gib_workspace_names | while read -r id active name; do
    name="${name#*_}"
    if [ "$active" == '*' ]; then
      button_class="active_wsp"
    elif wmctrl -l | grep --regexp '.*\s\+'"$id"'\s\+.*' >/dev/null; then
      button_class="full_wsp"
    else
      button_class="inactive_wsp"
    fi    
    echo -n '<button class="'"$button_class"'" onclick="wmctrl -s '"$id"'">'"$name"'</button>'
  done
}

xprop -spy -root _NET_CURRENT_DESKTOP | while read -r; do
  echo '<box orientation="h" class="workspaces" space-evenly="true" halign="start" valign="center" vexpand="true">'"$(gib_workspace_xml)"'</box>'
done
