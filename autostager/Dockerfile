# https://github.com/gliderlabs/docker-alpine
FROM gliderlabs/alpine:latest

# http://jumanjiman.github.io/
MAINTAINER Paul Morgan <jumanjiman@gmail.com>

ENV VERSION 0.0.10

RUN apk-install ruby ca-certificates ruby-dev git perl
RUN gem install --no-rdoc --no-ri "puppet-autostager:=${VERSION}"

# Do not track changes in volumes.
RUN mkdir -p /opt/puppet/environments
VOLUME ["/opt/puppet/environments"]

CMD autostager
