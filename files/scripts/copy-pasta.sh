#!/bin/sh

set -e

GEN_SCRIPT_DATA_PATH="/home/leon/copy-pasta"



#options=$(for x in $GEN_SCRIPT_DATA_PATH/*; do echo "$x" | sed "s|$GEN_SCRIPT_DATA_PATH/||g"; done)
options=$(find "$GEN_SCRIPT_DATA_PATH" -type f | grep --invert-match ".git" | sed "s|$GEN_SCRIPT_DATA_PATH/||g")
choice="$(echo "$options" | rofi -dmenu -matching glob)"
file="$GEN_SCRIPT_DATA_PATH/$choice"

mime_type="$(file --mime-type "$choice" | sed 's/.*:\s*//g')"

xclip -selection clipboard -in -t "$mime_type" -i "$file"
