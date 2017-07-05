#!/bin/bash
set -e
set -o noclobber

# Import smitty.
source script/functions

say Build puppetdb image.
base_tag="jumanjiman/puppetdb"
hash_tag="${base_tag}:${short_hash}"
late_tag="${base_tag}:latest"
pushd puppetdb
cp -r ../ssl .
smitty docker build --rm -t $hash_tag . 2>&1 | tee /tmp/build-puppetdb.out
smitty docker tag $hash_tag $late_tag
popd
