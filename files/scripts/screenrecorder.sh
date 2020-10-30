#! /bin/sh

[ -z "$1" ] && \
  echo "usage: screenrecorder.sh <output-file-path>" && \
  exit 1

ffmpeg -video_size 2560x1080 -framerate 25 -f x11grab -i :0.0 "$@"
