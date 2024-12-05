#!/bin/dash
if [ -z "$1" ]; then 
  echo "usage: screenrecorder.sh <output-file-path>"
  exit 1
fi

ffmpeg -video_size 2560x1080 -framerate 25 -f x11grab -i :0.0 "$1"
