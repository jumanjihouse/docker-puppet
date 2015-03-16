#!/bin/sh

if [ -z "${public_ipaddress}" ]; then
  echo env var public_ipaddress is not set >&2
  exit 1
fi

# Adjust the zone file in case we started the container
# with `-e public_ipaddress`. This allows to use
# this container on any given test host without rebuilding
# the image.
#
sed -i "s/public_ipaddress/${public_ipaddress}/g" /etc/bind/master/inf.ise.com.zone

exec /usr/sbin/named -g
