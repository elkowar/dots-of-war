#!/bin/sh

echo "pass true to stop charging at 60%, false to charge to 100%"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

case $1 in
  true)
    tlp setcharge 90 1 BAT1
    ;;
  false)
    tlp setcharge 90 0 BAT1
    ;;
  *)
    echo "Usage: $0 [true|false]"
    ;;
esac
