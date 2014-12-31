#!/bin/bash
set -e
set -o noclobber

# Import smitty.
source script/functions

say Build dns server image.
pushd named
smitty docker build --rm -t jumanjiman/named . 2>&1 | tee /tmp/build-named.out
popd
