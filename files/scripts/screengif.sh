#!/bin/bash

file="$HOME/Bilder/gifs/gif_$(date +%s).gif"
giph -s -l -c  1,1,1,0.3 -b 5 -p 5 "$file"
echo "$file" | xclip -selection clipboard
