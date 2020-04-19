#!/bin/dash

cat ~/.xmonad/lib/Config.hs \
  | awk '/myKeys = \[/,/\] \+\+ generatedMappings.*/' \
  | sed 's/myKeys = \[ (\|\].*generatedMappings.*//g' \
  | sed 's/^\s*, \?(\|)//g'    
