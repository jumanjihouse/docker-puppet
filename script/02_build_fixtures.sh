#!/bin/bash
set -e
set -o noclobber

# Import smitty.
source script/functions

say Create fixtures image.
base_tag="jumanjiman/fixtures"
hash_tag="${base_tag}:${short_hash}"
late_tag="${base_tag}:latest"
pushd spec/fixtures/
smitty docker build --rm -t $hash_tag . 2>&1 | tee /tmp/build-fixtures.out
smitty docker tag -f $hash_tag $late_tag
popd
