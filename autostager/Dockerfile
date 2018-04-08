# https://github.com/gliderlabs/docker-alpine
FROM alpine:3.7

# http://jumanjiman.github.io/
MAINTAINER Paul Morgan <jumanjiman@gmail.com>

ENV VERSION 0.0.14

RUN apk add --no-cache ruby ca-certificates git perl && \
    apk add --no-cache -t DEV alpine-sdk ruby-dev && \
    gem install --no-rdoc --no-ri "puppet-autostager:=${VERSION}" && \
    apk del DEV

RUN adduser -D puppet

# Do not track changes in volumes.
RUN mkdir -p /opt/puppet/environments && \
    chown puppet:puppet /opt/puppet/environments
VOLUME ["/opt/puppet/environments"]

USER puppet
ENTRYPOINT ["autostager"]
