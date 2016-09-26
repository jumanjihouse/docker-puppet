#!/bin/bash
set -e
set -o noclobber

# Import smitty.
source script/functions

# Discover which network docker uses.
dummy_cid=$(docker run -d alpine:3.4 sh -c 'while true; do sleep 1; done')
gateway_ip=$(docker inspect --format '{{ .NetworkSettings.Gateway }}' ${dummy_cid})
docker rm -f ${dummy_cid} || :
say "Docker gateway is ${gateway_ip}"
sed -i "s/ETCD_IP/${gateway_ip}/g" spec/fixtures/production/hiera.yaml

say Create fixtures image.
base_tag="jumanjiman/fixtures"
hash_tag="${base_tag}:${short_hash}"
late_tag="${base_tag}:latest"
pushd spec/fixtures/
smitty docker build --rm -t $hash_tag . 2>&1 | tee /tmp/build-fixtures.out
smitty docker tag -f $hash_tag $late_tag
popd
