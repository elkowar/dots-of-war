#!/bin/bash

stack new "$1"
cd "$1"
echo -e "cradle:\n  stack:" >> hie.yaml
sed -i 's/^resolver: .*$/resolver: lts-15.0/' stack.yaml
stack setup
stack build --fast
