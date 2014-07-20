#!/bin/bash
set -e

dirs="
/lib64
/usr/lib
/usr/lib64
/usr/bin
/usr/local/bin
/sbin
/usr/sbin
/usr/local/sbin
"
for dir in $dirs; do
  # If any file has group or world write privilege, remove that privilege.
  find $dir -type f -perm /go=w -exec chmod go-w {} +
done

# Disable empty password support from PAM.
sed -r -i 's/\<nullok\>//g' /etc/pam.d/*
