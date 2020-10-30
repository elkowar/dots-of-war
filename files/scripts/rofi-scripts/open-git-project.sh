#! /bin/sh
token="i3_yxQr4ypsKkcht4AnS" data="$(curl "https://git.xware-gmbh.de/api/graphql" \
    -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json" \
    --request POST -s --data @- << GQL
{ "query": "
  query {
    xware: namespace(fullPath: \"xware\") {
      projects { nodes { name, httpUrlToRepo } }
    }
    leon: namespace(fullPath: \"leon\") {
      projects { nodes { name, httpUrlToRepo } }
    }
  }"
}
GQL
)"

a="$(echo "$data" | jq -r '.data.xware.projects.nodes + .data.leon.projects.nodes | map(.name + "::::" + .httpUrlToRepo)[]')"
selection="$(echo "$a" | sed -r 's/^(.*)::::.*$/\1/g' | rofi -dmenu -i -theme "$HOME/scripts/rofi-scripts/default_theme.rasi")"
[ ! "$selection" = "" ] && echo "$a" | sed -r -n "s/^$selection::::(.*)$/\1/pg" | xargs qutebrowser
