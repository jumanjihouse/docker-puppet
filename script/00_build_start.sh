#!/bin/bash
set +e

# Import smitty.
source script/functions

say Remove existing containers if necessary.
for c in board-test db-test master-test named-test; do
  smitty docker stop $c
  smitty docker rm $c
done
smitty docker rm puppet-ca

# Always exit true.
exit 0
