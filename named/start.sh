#!/bin/bash

# Adjust the zone file in case we started the container
# with `-e FACTER_public_ipaddress`. This allows to use
# this container on any given test host without rebuilding
# the image. For more info about env vars as facter facts:
# http://puppetlabs.com/blog/facter-part-1-facter-101
#
puppet apply /tmp/install.pp

# The bind::service class currently starts named
# and does not allow to override, therefore we
# just stop the service, then manually start it
# in the foreground so that systemd can accurately
# detect if named fails (and subsequently restart).
#
/etc/init.d/named stop
/usr/sbin/named -g
