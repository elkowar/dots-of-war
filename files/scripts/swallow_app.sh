#! /bin/bash

file="$HOME/.local/share/unhide"
app="$1"
#target="$2"

tid=$(xdo id)


hidecurrent() {
    echo $tid+$app >> $file & xdo hide
}

showlast() {
    sid=$(cat $file | grep "$app" | awk -F "+" 'END{print $1}')
    xdo show -r $sid
}

hidecurrent & $@ ; showlast
