#!/bin/dash
cat ~/.xmonad/lib/Config.hs | awk '/myKeys = \[/,/\] \+\+ generatedMappings.*/' | sed 's/myKeys = \[//g' | sed 's/\].*generatedMappings.*//g' | sed 's/^\s*,\? //g' | sed 's/^(\|)//g'
