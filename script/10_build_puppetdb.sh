#!/bin/bash
set -e
set -o noclobber

# Import smitty.
source script/functions

say Build puppetdb image.
pushd puppetdb
cp -r ../ssl .
smitty docker build --rm -t jumanjiman/puppetdb .
popd
