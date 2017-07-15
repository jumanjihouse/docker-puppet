#!/bin/bash
set +e

# Import smitty.
source script/functions

say Remove existing containers if necessary.
for c in board-test db-test master-test named-test; do
  smitty docker rm -f $c
done
smitty docker rm puppet-ca

# Publish two simple key/value pairs.
smitty docker-compose run curl -L -X PUT http://192.168.254.254:2379/v2/keys/configuration/common/bar -d value="baz"
smitty docker-compose run curl -L -X PUT http://192.168.254.254:2379/v2/keys/configuration/common/baz -d value="baz"

# Publish key "hash" with a nested hash as its value.
smitty docker-compose run curl -L -X PUT http://192.168.254.254:2379/v2/keys/configuration/common/hash \
  -d value='{"nested_hash":{"msg_a":"Bob Schneider","msg_b":"Tarantula!"}}'
echo

# Always exit true.
exit 0
