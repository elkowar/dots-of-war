#!/bin/bash
pgrep "$@" > /dev/null || ("$@" &)
