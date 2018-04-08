FROM alpine:3.6

ENV PUPPET_VERSION 3.8.7

# Must match puppetdb container version.
ENV PUPPETDB_VERSION 2.3.8

# Dependencies:
#   shadow - puppet
#   util-linux - uuidgen for puppet
#   ruby < 2.2 (from alpine 3.1) to avoid syck errors in puppet 3.x
#   git - to calculate config_version of puppet repo
#
# https://tickets.puppetlabs.com/browse/PUP-3796 (syck error in ruby 2.2)
#
# http://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management#Holding_a_specific_package_back
#
RUN apk add --no-cache -X http://dl-4.alpinelinux.org/alpine/v3.1/main \
      'ruby<2.2' \
      ruby-unicorn \
    && \
    apk add --no-cache \
      ca-certificates \
      gettext \
      git \
      nginx \
      'openssl>=1.0.2j-r0' \
      s6 \
      s6-portable-utils \
      util-linux \
    && \
    apk add --no-cache -X http://dl-4.alpinelinux.org/alpine/edge/community/ \
      shadow \
    && \
    :

# Install gems compatible with ruby < 2.2
RUN gem install -N \
      mixlib-log:=1.7.1 \
      etcd \
      facter \
      rack:=1.6.4 \
      puppet:=${PUPPET_VERSION} \
    && \
    rm -fr /root/.gem*

RUN adduser -D puppet

# Install appropriate version of puppetdb-terminus and hiera-etcd backend.
# https://github.com/puppetlabs/puppetdb/blob/2.3.x/documentation/connect_puppet_master.markdown
# https://docs.puppetlabs.com/puppetdb/2.3/connect_puppet_master.html#on-platforms-without-packages
RUN apk add -U curl && \
    curl -L -O https://github.com/puppetlabs/puppetdb/archive/${PUPPETDB_VERSION}.tar.gz && \
    tar xzf ${PUPPETDB_VERSION}.tar.gz -C /tmp && \
    cp -r /tmp/puppetdb-${PUPPETDB_VERSION}/puppet/lib/puppet /usr/lib/ruby/2.1.0/puppet && \
    rm -fr /tmp/${PUPPETDB_VERSION}.tar.gz && \
    rm -fr /tmp/puppetdb-${PUPPETDB_VERSON} && \
    cd /tmp/ && \
    curl -sS -L -O https://raw.githubusercontent.com/garethr/hiera-etcd/master/lib/hiera/backend/etcd_backend.rb && \
    cp etcd_backend.rb /usr/lib/ruby/gems/2.1.0/gems/puppet-${PUPPET_VERSION}/lib/hiera/backend && \
    cp etcd_backend.rb /usr/lib/ruby/gems/2.1.0/gems/hiera-*/lib/hiera/backend && \
    apk del --purge curl && \
    rm -f /var/cache/apk/*

# Put configs and scripts in place.
COPY . /

# Harden the image.
# This must be done *before* we configure volumes.
RUN /usr/sbin/prepare.sh
RUN /usr/sbin/harden.sh

# Do not persist anything in these dirs.
VOLUME ["/var/lib/", "/var/log", "/tmp", "/etc/s6", "/var/tmp/nginx/"]

# We use dynamic environments.
VOLUME ["/opt/puppet/environments/"]

EXPOSE 8140

USER puppet
ENTRYPOINT ["s6-svscan", "/etc/s6/"]
