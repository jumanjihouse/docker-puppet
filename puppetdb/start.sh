#!/bin/bash
set -x

# Protect against dirty shutdown.
rm -fr /var/run/puppetdb*
rm -fr /var/lock/subsys/puppetdb*

/etc/init.d/rsyslog start
/etc/init.d/postgresql start
/etc/init.d/puppetdb start

# Ugly!
sleep 60

tail -f /var/log/messages /var/log/puppetdb/*
