#! /bin/sh

while read -r input; do
  echo "$input" | sed 's/\s\+/\n/g' | sed -n '/.\{5\}.\+/p'
done | fzf --height 10 | tr -d "\n" | kitty @send-text --stdin -m "id:$1"
