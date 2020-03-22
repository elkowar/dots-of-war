if [ -z "$1" ]; then 
  echo "timer.sh <time>"
  exit 1
fi
termdown -o /home/leon/scripts/remainingTime.txt $1 && notify-send "Timer" "Timer finished: $1"
