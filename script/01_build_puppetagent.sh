#!/bin/bash
set -e
set -o noclobber

# Import smitty.
source script/functions

say Create puppet-agent base image.
pushd puppetagent
smitty docker build --rm --no-cache -t jumanjiman/puppetagent . 2>&1 | tee /tmp/build-puppetagent.out
popd
