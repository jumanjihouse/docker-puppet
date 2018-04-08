#!/bin/sh
set -x
set -e
#
# Docker build calls this script to harden the image during build.
#
# NOTE: To build on CircleCI, you must take care to keep the `find`
# command out of the /proc filesystem to avoid errors like:
#
#    find: /proc/tty/driver: Permission denied
#    lxc-start: The container failed to start.
#    lxc-start: Additional information can be obtained by \
#        setting the --logfile and --logpriority options.

# Remove existing crontabs, if any.
rm -fr /var/spool/cron

# Remove world-writable permissions.
# This breaks apps that need to write to /tmp.
find / -xdev -type d -perm +0002 -exec chmod o-w {} +
find / -xdev -type f -perm +0002 -exec chmod o-w {} +

# Remove unnecessary user accounts.
sed -i -r '/^(root|puppet|nginx)/!d' /etc/group
sed -i -r '/^(root|puppet|nginx)/!d' /etc/passwd

# Remove interactive login shell for everybody.
sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd

sysdirs="
  /bin
  /lib
  /sbin
  /usr
"

# Ensure system dirs are owned by root and not writable by anybody else.
# shellcheck disable=SC2086
find $sysdirs -xdev -type d \
  -exec chown root:root {} \; \
  -exec chmod 0755 {} \;

# But let puppet own /etc/s6 to `mkfifodir event`.
chown -R puppet:puppet /etc/s6/nginx
chown -R puppet:puppet /etc/s6/unicorn
chown -R puppet:puppet /usr/share/nginx

# We need `chage' but not suid.
chmod u-s /usr/bin/chage

# Remove all suid files.
# shellcheck disable=SC2086
find $sysdirs -xdev -type f -a -perm +4000 -delete

# Remove other programs that could be dangerous.
# shellcheck disable=SC2086
find $sysdirs -xdev \( \
  -name hexdump -o \
  -name chgrp -o \
  -name chmod -o \
  -name chown -o \
  -name ln -o \
  -name od -o \
  -name strings -o \
  -name su \
  \) -delete

# Remove init scripts since we do not use them.
rm -fr /etc/init.d
rm -fr /lib/rc

# Remove root homedir since we do not need it.
rm -fr /root

# Remove broken symlinks (because we removed the targets above).
# shellcheck disable=SC2086
find $sysdirs -xdev -type l -exec test ! -e {} \; -delete
