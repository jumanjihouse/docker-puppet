#!/bin/bash
set -e
set -o noclobber

# Import smitty.
source script/functions

say Build dns server image.
smitty docker build --rm -t jumanjiman/named named/ 2>&1 | tee /tmp/build-named.out
