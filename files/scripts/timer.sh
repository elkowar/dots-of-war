#! /bin/sh

[ -z "$1" ] && \
  echo "timer.sh <time>" && \
  exit 1

termdown -o /home/leon/scripts/remainingTime.txt "$1" && notify-send "Timer" "Timer finished: $1"
