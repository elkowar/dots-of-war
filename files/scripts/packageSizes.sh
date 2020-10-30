#! /bin/sh


expac -SsH M "%m: %n$\t%d" "$@" | sort -h | tr "$" "\n"

# less verbose: expac -S -H M "%m %n"|sort -n
