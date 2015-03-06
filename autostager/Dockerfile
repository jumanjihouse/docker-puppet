# https://github.com/gliderlabs/docker-alpine
FROM gliderlabs/alpine:latest

# http://jumanjiman.github.io/
MAINTAINER Paul Morgan <jumanjiman@gmail.com>

RUN apk-install ruby ca-certificates ruby-dev
RUN gem install --no-rdoc --no-ri puppet-autostager

# Do not track changes in volumes.
RUN mkdir -p /opt/puppet/environments
VOLUME ["/opt/puppet/environments"]

CMD autostager
