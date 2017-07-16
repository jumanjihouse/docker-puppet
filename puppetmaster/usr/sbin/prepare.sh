#!/bin/sh
set -x
set -e
#
# Docker build calls this script to prepare the image during build.
#
# NOTE: To build on CircleCI, you must take care to keep the `find`
# command out of the /proc filesystem to avoid errors like:
#
#    find: /proc/tty/driver: Permission denied
#    lxc-start: The container failed to start.
#    lxc-start: Additional information can be obtained by \
#        setting the --logfile and --logpriority options.

# Setup paths for nginx to run with read-only root fs.
mkdir -p /tmp/nginx/
mkdir -p /var/log/nginx/
mkdir -p /usr/share/nginx
ln -fs /tmp /usr/uwsgi_temp
ln -fs /tmp /usr/scgi_temp
chown puppet:puppet /tmp/nginx /var/log/nginx /usr/uwsgi_temp /usr/scgi_temp /usr/share/nginx

# Setup paths for s6.
# This enables to start s6 as an unprivileged user.
s6_dirs="
/etc/s6/.s6-svscan
/etc/s6/nginx/supervise
/etc/s6/nginx/event
/etc/s6/unicorn/supervise
"
for dir in ${s6_dirs}; do
  mkdir -p ${dir}
  chown puppet:puppet ${dir}
done

# Ensure correct permissions for puppet dirs.
mkdir -p /var/lib/puppet/ssl
mkdir -p /var/log/puppet
chown -R puppet:puppet /var/lib/puppet
chmod 0755 /var/lib/puppet
chown -R puppet:puppet /var/log/puppet
chmod 0755 /var/log/puppet
chown -R puppet:puppet /var/lib/puppet/ssl

# nginx buffers client request body here.
mkdir -p /var/lib/nginx/
chown -R puppet:puppet /var/lib/nginx
mkdir -p /var/tmp/nginx/
chown -R puppet:puppet /var/tmp/nginx

#cp -f /usr/lib/ruby/gems/2.1.0/gems/puppet-${PUPPET_VERSION}/ext/rack/config.ru /etc/puppet/

mkdir -p /var/run/puppet || :
chown puppet:puppet /var/run/puppet

chown -R puppet:puppet /etc/puppet
