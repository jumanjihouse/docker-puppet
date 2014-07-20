#!/bin/bash
set -e
set -o noclobber

source script/functions

rm -f /tmp/start
date > /tmp/start

say Run build scripts in order.
#
# This is a kludge to sort-of parse wercker.yml
# to have DRY approach for running build locally.
#
for file in $(awk '/code: script\/[0-9][0-9]_build_.*/ {print $NF}' wercker.yml); do
  $file
done

rm -f /tmp/stop
date > /tmp/stop
