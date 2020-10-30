#! /bin/sh

# distance in meter, duration in sekunden ( hier: per auto )

distance() {
  while read -r line; do
    name="$(echo "$line" | jq -r '.name' | sed 's/\s\+$//g')"

    #from="9.2153932,49.095978" # Leon
    from="9.113909,48.998883" # Celine
    to="$(echo "$line" | jq -r '(.coordinates[0] | tostring) + "," + (.coordinates[1] | tostring)')"

    result="$(curl --silent \
      --header "Content-Type: application/json; charset=utf-8" \
      --header "Accept: application/json, application/geo+json" \
      --header "application/gpx+xml, img/png; charset=utf-8" \
      'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf62484d58426d15954cf5a48cc900072babfb&start='"$from"'&end='"$to"'' \
      | jq -c '.features[0].properties.summary')"

    echo "{\"name\": \"$name\", \"dist\": $result}"
    sleep 2
    done
}

cat ~/tmp/coordinates.json | distance
