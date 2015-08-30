FROM alpine:3.2

ENV PUPPET_VERSION 3.8.2
ENV PUPPETDB_VERSION 2.3.6

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
RUN echo http://dl-4.alpinelinux.org/alpine/edge/testing/ >> /etc/apk/repositories && \
    echo http://dl-4.alpinelinux.org/alpine/v3.1/main >> /etc/apk/repositories && \
    apk add --update \
      ca-certificates \
      git \
      make \
      nginx \
      openssl \
      'ruby<2.2' \
      shadow \
      util-linux \
    && \
    rm -f /var/cache/apk/*

RUN gem install -N \
      etcd \
      facter \
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

# Put configs in place.
COPY etc/puppet /etc/puppet

ADD ssl /var/lib/puppet/ssl

# Puppet needs RW privileges for certdir.
RUN chown -R puppet:puppet /var/lib/puppet/ssl

# We use separate data container for SSL certs.
# (Or, we would like to.)
VOLUME ["/var/lib/puppet/ssl/"]

# We use dynamic environments.
VOLUME ["/opt/puppet/environments/"]

EXPOSE 8140
ENTRYPOINT ["puppet"]
CMD ["master", "--no-daemonize", "--confdir=/etc/puppet/", "--vardir=/var/lib/puppet/"]
