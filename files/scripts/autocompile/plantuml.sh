#!/bin/bash
pngfile=$(echo "$1" | sed 's/\.plantuml$/.png/g')

function finish {
  rm "$pngfile"
}

trap finish EXIT

plantuml -tpng "$1"
feh --auto-zoom --auto-reload --fullscreen "$pngfile" &
echo "$1" | entr plantuml -tpng /_
