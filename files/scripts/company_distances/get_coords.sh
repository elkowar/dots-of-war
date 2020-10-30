#! /bin/sh


get_coords () {
  while read -r input; do
    name="$(echo "$input" | sed -r 's/^(.*)\s*\| .*$/\1/g' | tr -s " ")"
    loc="$(echo "$input" | sed -r 's/^.*\s*\| (.*)$/\1/g')"

    escaped_query="$(echo "$loc" | sed 's/ /%20/g')"
    result="$(curl --silent \
         --header "Content-Type: application/json; charset=utf-8" \
         --header "Accept: application/json, application/geo+json"\
         --header "application/gpx+xml, img/png; charset=utf-8" \
      'https://api.openrouteservice.org/geocode/search?api_key=5b3ce3597851110001cf62484d58426d15954cf5a48cc900072babfb&text='"$escaped_query" \
      | jq -c '.bbox | [.[0], .[1]]')"
    echo "{\"name\": \"$name\", \"coordinates\": $result}"
    sleep 2
  done
}

cat "$HOME/Downloads/Unternehmensliste" | get_coords
