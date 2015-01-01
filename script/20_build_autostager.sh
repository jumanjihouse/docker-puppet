#!/bin/bash
set -e
set -o noclobber

# Import smitty.
source script/functions

say Create autostager image.
base_tag="jumanjiman/autostager"
hash_tag="${base_tag}:${short_hash}"
late_tag="${base_tag}:latest"
pushd autostager
smitty docker build --rm -t $hash_tag . 2>&1 | tee /tmp/build-autostager.out
smitty docker tag $hash_tag $late_tag
popd
