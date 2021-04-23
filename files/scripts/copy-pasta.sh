#!/bin/sh

GEN_SCRIPT_DATA_PATH="/home/leon/gen-script-data"



options=$(for x in $GEN_SCRIPT_DATA_PATH/*; do echo "$x" | sed "s|$GEN_SCRIPT_DATA_PATH/||g"; done)


echo "$options" | rofi -dmenu

