#! /bin/sh
echo "%{r} $(date "+%H:%M - %a, %d.%m.%y")%{-r} " | lemonbar -p -f "Jetbrains Mono:size=10" -f "Font Awesome:size=10" -B "#66282833" -g "480x25+2066+7"
