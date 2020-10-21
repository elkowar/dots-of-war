#!/usr/bin/bash



fixArtUrl() {
  sed -e 's/open.spotify.com/i.scdn.co/g'
}

getData() {
  eww update song-name "$(playerctl metadata --format "{{ xesam:title }}")"
  wget -O /tmp/music-file "$(playerctl metadata --format "{{ mpris:artUrl }}"| fixArtUrl)"
  eww update song-image /tmp/music-file
  eww update song-album "$(playerctl metadata --format "{{ xesam:album }}")"
  eww update song-artist "$(playerctl metadata --format "{{ xesam:artist }}")"
  if [ "spotify" = "$(playerctl metadata | head -n1 | awk '{ print $1 }')" ]; then
    eww update song-show-progress "false"
  else
    eww update song-show-progress "true"
  fi;

  song_status="$(playerctl status --format "{{ lc(status) }}")"
  if [ "$song_status" = "playing" ]; then
    eww update song-playpause 
  else 
    eww update song-playpause 
  fi


}

#getData
cat <(playerctl metadata --format '{{ title }}' -F & playerctl status -F) | while read -r _; do getData; done;
