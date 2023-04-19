#!/bin/sh

case "$1" in
  -*) exit 0;;
esac

case "$(file --mime-type "$1")" in
  *directory*)
    exa --icons -1 --color=always "$1"
    ;;
  *text*)
    bat --color always --plain --theme gruvbox-dark "$1"
    ;;
  *image* | *pdf)
    if command -v timg; then 
      timg -g50x50 -E -F "$1"
    elif command -v catimg; then
      catimg -w 100 -r 2 "$1"
    else
      echo "Install timg or catimg to view images!"
    fi
    ;;
  *)
    echo "unknown file format"
    ;;
esac




