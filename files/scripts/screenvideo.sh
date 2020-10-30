#! /bin/sh

rec_filename="$HOME/Bilder/screenvids/$(date '+%Y-%m-%d_%H-%M-%S').mp4"
scr -m s -c "$rec_filename"
dragon --and-exit "$rec_filename"
