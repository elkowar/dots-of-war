#!/bin/bash
pngfile="${1//.plantuml/.png}"

function finish {
  rm "$pngfile"
}

trap finish EXIT

plantuml -tpng "$1"
feh --auto-zoom --auto-reload --fullscreen "$pngfile" &
echo "$1" | entr plantuml -tpng /_
