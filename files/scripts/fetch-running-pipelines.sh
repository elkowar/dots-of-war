# sh gitlab-api-script.sh | jq '[.data.namespace.projects.nodes[] | { name: .name, pipelines: .pipelines.nodes }]' | fx
# sh gitlab-api-script.sh | jq '[.data.namespace.projects.nodes[] | { name: .name, pipelines: .pipelines.nodes }] | map(select((.pipelines | length) > 0))' | fx # sh gitlab-api-script.sh | jq '[.data.namespace.projects.nodes[] | { name: .name, pipelines: (.pipelines.nodes | map([.finishedAt, .status] | join(": ")))}] | map(select((.pipelines | length) > 0))' | fx

token="i3_yxQr4ypsKkcht4AnS" data="$(curl -fsL "https://git.xware-gmbh.de/api/graphql" -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json" --request POST -s --data @- << GQL
{ "query": "
  query {
    namespace(fullPath: \"xware\") {
      id
      name
      projects {
        nodes {
          name
          pipelines(first: 1) {
            nodes {
              finishedAt
              status
            }
          }
        }
      }
    }
  }"
}
GQL
)"

#echo $data | jq '[.data.namespace.projects.nodes[] | { name: .name, pipelines: (.pipelines.nodes[0].status)}] | map(select((.pipelines | length) > 0)) |  map([.name, .pipelines] | join(": "))' | sed 's/"//g' | sed 's/^null$//'
filter () {
  now="$( date +%s )"
  maxAge="$($(("$now" - 60 * 5)))"
  while read input; do
    agePart="$( echo $input | sed 's/::::.*$//g' | sed 's/"//g' )"
    age="$( date --date="$agePart" +%s )"
    [ -z "$agePart" ] && \ # -z -> length of string is < 0
      echo "age "$pagePart""
      echo "$input" | sed 's/:::://g' || \
    [ "$maxAge" -lt "$age" ] && \
      echo "$input" | sed 's/^.*:::://g'
  done
}

a="$(echo "$data" | jq '[.data.namespace.projects.nodes[] | {name: .name, status: .pipelines.nodes[0].status, finishedAt: .pipelines.nodes[0].finishedAt}]')"
b="$(echo "$a" | jq 'map(select(.status | length > 0)) | map(.finishedAt + "::::" + .name + ": " + .status) | .[]' | sort -nr | head -n 1)"
echo "$b" | filter
