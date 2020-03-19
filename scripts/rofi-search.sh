#!/bin/bash
# todo combine selection with query by using first word as selection and rest as query
selection=$( echo -e "hoogle\ngoogle" | rofi -dmenu )
if [ $selection = "hoogle" ]; then
  input=$( rofi -p "search hoogle" -dmenu )
  query=$( echo $input | sed 's/ p=.*$//g' )
  package=$( echo $input | sed 's/.*p=//g' )
  [ $package = $query ] && package=""
  #firefox --new-window "https://hoogle.haskell.org/?hoogle=$query&scope=package:$package" &
  surf "https://hoogle.haskell.org/?hoogle=$query&scope=package:$package" &
  #result=$( hoogle $query | rofi -p "select" -dmenu | sed 's/^\(.*\) :: .*$/\1/' | sed 's/\ /./g' | xargs hoogle --info )
  #notify-send "hoogle" "$result"
elif [ $selection = "google" ]; then
  query=$( rofi -p "search google" -dmenu )
  firefox "https://google.de/search?q=$query" &
fi
