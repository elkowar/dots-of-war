#!/bin/sh
[ -f "${1}" ] && op=cat
${op:-echo} "${1:-`cat -`}" | curl -sF f='@-' -F expire=129600 'https://oshi.at' | tail -n 1  | cut -d ' ' -f 2 | tee /dev/stderr | xclip -sel clip
