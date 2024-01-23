#!/bin/bash

# Render a CSV changelog from the git log
# this can be used to add a changelog to the document itself

cd "$(dirname "$0")/.." || exit 1

git log --reverse --pretty=format:'%ad,%an,"%s"' --date=short #| sed 's/\#/\\\#/g'
