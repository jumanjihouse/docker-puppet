#!/bin/bash

rm -fr /var/run/httpd/*
rm -fr /var/lock/subsys/httpd
exec /usr/sbin/apachectl -D FOREGROUND
