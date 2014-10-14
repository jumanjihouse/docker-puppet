#!/bin/bash

. /etc/sysconfig/puppetserver

logfile=/var/log/puppetserver/puppetserver.log
touch $logfile

/usr/bin/java $JAVA_ARGS \
  -XX:OnOutOfMemoryError=kill\ -9\ %p \
  -XX:+HeapDumpOnOutOfMemoryError \
  -XX:HeapDumpPath=/var/log/puppetserver \
  -cp "${INSTALL_DIR}/puppet-server-release.jar" clojure.main \
  -m puppetlabs.trapperkeeper.main --config "${CONFIG}" \
  -b "${BOOTSTRAP_CONFIG}" &

tail -f $logfile
