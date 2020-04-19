#!/bin/bash


to_file=0
fullscreen=0
for arg in "$@"; do
  case $arg in
    --tofile)     to_file=1;;
    --fullscreen) fullscreen=1;;
  esac
done

select_flag="-s"
[ $fullscreen -eq 1 ] && select_flag=""

if [ $to_file -eq 1 ]; then
  file="$HOME/Bilder/screenshots/screenshot_$(date +%s).png"
  echo "$file"
  [ -z "$select_flag" ] && sleep 1
  maim $select_flag --format png "$file"
  echo "$file" | xclip -selection clipboard 
else
  [ -z "$select_flag" ] && sleep 1
  maim "$select_flag" --format png /dev/stdout | xclip -selection clipboard -t image/png -i
fi
