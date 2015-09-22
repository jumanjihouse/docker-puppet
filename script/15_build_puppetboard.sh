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
(
cp -r ../ssl .

# Build an image that creates a pip package.
smitty docker build --rm -t puppetboard:build -f Dockerfile.build .

# Create a container from which to copy files.
docker rm -f puppetboard_build || :
smitty docker create --name puppetboard_build puppetboard:build true

# Grab the pip tarball.
smitty docker cp puppetboard_build:/puppetboard/dist/puppetboard-master.tar.gz files/

# Grab a copy of default_settings.py from master branch for local review if necessary.
smitty docker cp puppetboard_build:/puppetboard/puppetboard/default_settings.py files/var/www/puppetboard/

# Build the runtime image.
smitty docker build --rm -t $hash_tag -f Dockerfile .
) 2>&1 | tee /tmp/build-puppetboard.out
smitty docker tag -f $hash_tag $late_tag
popd
