#!/bin/dash
openDetailsAction() {
  echo "Details:surf https://hoogle.haskell.org/?hoogle=$1&scope=package:$2"
}

query=$( echo "h\ng" | rofi -dmenu )
selection=$( echo "$query" | awk '{print $1}' )
input=$( echo "$query" | awk '{print $2}' )

case "$selection" in
  "h") 
    query=$(   echo "$input" | sed 's/ p=.*$//g' )
    package=$( echo "$input" | sed 's/.*p=//g' )
    [ "$package" = "$query" ] && package=""

    selection=$( hoogle "$query" | rofi -p "select" -dmenu | sed 's/^\(.*\) :: .*$/\1/' | sed 's/\ /./g' )
    result=$( echo "$selection" | xargs hoogle --info )
    notify-send.sh --icon="dialog-information" --action="$(openDetailsAction "$query" "$package")" "Hoogle" "$result"
  ;;
  "g")
    $BROWSER "https://google.de/search?q=$input" &
  ;;
esac

