#!/usr/bin/env bash

query="$1"
shift
if [ -n "$query" ]; then
  scene="$(hueadm scenes | grep -i "$query" | cut -d ' ' -f 1)"
  group="$(hueadm groups | grep Schlafzimmer | cut -d ' ' -f 1)"

  hueadm recall-scene "$scene" "$group"
else
  echo "Select a scene from the following list:"
  if [ command -v rg &>/dev/null ]; then
     hueadm scenes | rg '^.*\d$' | awk '{print $2}' | sort -u
  else
    hueadm scenes | awk '{print $2}' | tail -n +2 | sort -u
  fi
fi
