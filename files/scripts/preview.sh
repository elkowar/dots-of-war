#! /bin/sh

type="$(file --mime-type "$@")"

case "$type" in
  *text*)
    bat --color always --plain --theme gruvbox "$@"
    ;;
  *image* | *pdf)
      [ "$(command -v timg)" ] && \
      timg -g50x50 -E -F "$@" || \
      [ "$(command -v catimg)" ] && \
      catimg -w 100 -r 2 "$@" || \
      echo "Install timg or catimg to view images!"
    ;;
  *directory*)
    exa --icons -1 --color=always "$@"
    ;;
  *)
    echo "unknown file format"
    ;;
esac
