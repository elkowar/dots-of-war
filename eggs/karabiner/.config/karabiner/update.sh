#!/bin/sh


deno run ./karabiner.ts > karabiner.json
# yq -o=json config.yaml > karabiner.json
