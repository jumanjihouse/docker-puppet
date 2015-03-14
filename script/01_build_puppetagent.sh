#!/bin/bash
set -e
set -o noclobber

# Import smitty.
source script/functions

say Create puppet-agent base image.
base_tag="jumanjiman/puppetagent"
hash_tag="${base_tag}:${short_hash}"
late_tag="${base_tag}:latest"
pushd puppetagent
smitty docker build --rm --no-cache -t $hash_tag . 2>&1 | tee /tmp/build-puppetagent.out
smitty docker tag -f $hash_tag $late_tag
popd
