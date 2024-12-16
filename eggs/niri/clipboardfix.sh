#!/usr/bin/env bash
primary-wl-to-x () {
  while read; do
    if [[ "$(wl-paste --primary --no-newline | sha256sum)" != "$(xclip -selection primary -out | sha256sum)" ]]; then
      echo "syncing primary wl->x"
      wl-paste --primary --no-newline | xclip -selection primary -in
    fi
  done < <(wl-paste --primary --watch echo)
}

primary-x-to-wl () {
  while clipnotify -s primary; do
    if [[ "$(wl-paste --primary --no-newline | sha256sum)" != "$(xclip -selection primary -out | sha256sum)" ]]; then
      echo "syncing primary x->wl"
      xclip -selection primary -out | wl-copy --primary
    fi
  done
}

clipboard-wl-to-x () {
  while read; do
    if [[ "$(wl-paste --no-newline | sha256sum)" != "$(xclip -selection clipboard -out | sha256sum)" ]]; then
      echo "syncing clipboard wl->x"
      wl-paste --no-newline | xclip -selection clipboard -in
    fi
  done < <(wl-paste --watch echo)
}

clipboard-x-to-wl () {
  while clipnotify -s clipboard; do
    if [[ "$(wl-paste --no-newline | sha256sum)" != "$(xclip -selection clipboard -out | sha256sum)" ]]; then
      echo "syncing clipboard x->wl"
      xclip -selection clipboard -out | wl-copy
    fi
  done
}

clipboard-wl-to-x &
clipboard-x-to-wl &
primary-wl-to-x &
primary-x-to-wl &
