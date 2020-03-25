#!/bin/dash
cat ~/.xmonad/lib/Config.hs | awk '/myKeys = \[/,/\] \+\+ concat .*/' | sed 's/myKeys = \[//g' | sed 's/\].*concat.*//g' | sed 's/^\s*,\? //g' | sed 's/^(\|)//g'
