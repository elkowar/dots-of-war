#! /bin/bash

menu_name="$1"
[ -n "$menu_name" ] && \
  last_selection="$(cat "/tmp/fzfopen_$menu_name" 2>"/dev/null")"

options_list="$(</dev/stdin)"

option_count="$((2+$(echo -e "$options_list" | wc -l)))"

options="$(echo -e "$options_list" | awk '{print $1}')"

[ -n "$last_selection" ] && \
  options="$last_selection\n$(echo -e "$options" | grep -v "$last_selection")"

selected=$(echo -e "$options" | fzf --history=/tmp/conf-open-history --cycle --reverse --height "$option_count")
[[ -z "$selected" ]] && exit 1
[[ -n "$menu_name" ]] && echo "$selected" > "/tmp/fzfopen_$menu_name"

selected_value="$(echo -e "$options_list" | grep "$selected" | sed -r 's/^\w*\s+(.*)$/\1/g')"
echo "$selected_value"
