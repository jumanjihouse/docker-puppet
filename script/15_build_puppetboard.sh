#!/bin/bash
set -e
set -o noclobber

# Import smitty.
source script/functions

say Create puppetboard image.
pushd puppetboard
cp -r ../ssl .
smitty docker build --rm -t jumanjiman/puppetboard . 2>&1 | tee /tmp/build-puppetboard.out
popd
