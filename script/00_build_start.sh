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

# Download and start etcd.
smitty curl -L -O -sS https://github.com/coreos/etcd/releases/download/v0.4.6/etcd-v0.4.6-linux-amd64.tar.gz
smitty tar -zxf etcd-v0.4.6-linux-amd64.tar.gz
ps -ef | grep '[e]tcd' || nohup etcd-v0.4.6-linux-amd64/etcd &

# Publish two simple key/value pairs.
smitty curl -L -X PUT http://127.0.0.1:4001/v2/keys/configuration/common/bar -d value="baz"
smitty curl -L -X PUT http://127.0.0.1:4001/v2/keys/configuration/common/baz -d value="baz"

# Publish key "hash" with a nested hash as its value.
smitty curl -L -X PUT http://127.0.0.1:4001/v2/keys/configuration/common/hash \
  -d value='{"nested_hash":{"msg_a":"Bob Schneider","msg_b":"Tarantula!"}}'

# Always exit true.
exit 0
