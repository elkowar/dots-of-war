#!/bin/bash

killall -q lemonbar

datetime() {
    datetime=$(date "+%H:%M | %a, %d.%m.%y")
    #echo -e -n "\uf073 ${datetime}"
    #echo -e -n " ${datetime}"
    echo -e -n "${datetime}"
}

output() {
  while true; do
    echo -e -n "%{l}%{l}%{r}\ue0b0 $(datetime)%{r}"
    sleep 0.1s
  done 
}

output | lemonbar -f "Roboto:size=10" -f "Font Awesome:size=10" -f "Iosevka Nerd Font" -B "#282828" -g "2532x30+14+7" &
#xmonad-log | lemonbar -f "Roboto:size=10" -f "Font Awesome:size=10" -B "#282828" -g "500x30+14+7"
