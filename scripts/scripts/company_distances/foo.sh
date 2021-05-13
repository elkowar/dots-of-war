#!/bin/bash


get_data() {
  while read -r line; do
    curl --silent "$line" | jq '.query.pages | .. | [.title, .extract]'
    sleep 1
  done
}

cat ./sorted.json  \
  | jq -r '.[].name' \
  | sed 's/ /%20/g'  \
  | sed 's/^\(.*\)$/https:\/\/de.wikipedia.org\/w\/api.php?format=json\&action=query\&prop=extracts\&exintro\&explaintext\&redirects=1\&titles=\1/g' \
  | get_data
