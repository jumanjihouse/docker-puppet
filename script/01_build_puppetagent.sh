#!/bin/bash
set -e
set -o noclobber

# Import smitty.
source script/functions

say Create puppet-agent base image.
pushd puppetagent
smitty docker build --rm -t jumanjiman/puppetagent .
popd
