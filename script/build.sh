#!/bin/bash
set -e
set -o noclobber

source script/functions

rm -f /tmp/start
date > /tmp/start

say Run build scripts in order.
for file in script\/[0-9][0-9]_build_*.sh; do
  $file
done

rm -f /tmp/stop
date > /tmp/stop
