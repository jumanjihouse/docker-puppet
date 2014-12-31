#!/bin/bash
set -e
set -o noclobber

# Import smitty.
source script/functions

say Create puppetboard image.
base_tag="jumanjiman/puppetboard"
hash_tag="${base_tag}:${short_hash}"
late_tag="${base_tag}:latest"
pushd puppetboard
cp -r ../ssl .
smitty docker build --rm -t $hash_tag . 2>&1 | tee /tmp/build-puppetboard.out
smitty docker tag $hash_tag $late_tag
popd
