#! /bin/sh

repo_url="$1"
rev="$2"

[ -n "$rev" ] && \
  output="$(nix-prefetch-git "$repo_url" --rev "$rev" 2>"/dev/null")" || \
  output="$(nix-prefetch-git "$repo_url" 2>"/dev/null")"



owner="$(echo "$repo_url" | sed 's/.*github\..*\/\(.*\)\/\(.*\)$/\1/')"
repo="$(echo "$repo_url" | sed 's/.*github\..*\/\(.*\)\/\(.*\)$/\2/')"
rev="${rev:-$(echo "$output" | grep "\"rev\": " | sed 's/.*: "\(.*\)".*$/\1/')}"
sha="$(echo "$output" | grep "\"sha256\": " | sed 's/.*: "\(.*\)".*$/\1/')"

echo "pkgs.fetchFromGitHub {"
echo "  owner = \"$owner\";"
echo "  repo = \"$repo\";"
echo "  rev = \"$rev\";"
echo "  sha256 = \"$sha\";"
echo "};"
