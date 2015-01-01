# https://index.docker.io/_/fedora/
FROM fedora:21

# http://jumanjiman.github.io/
MAINTAINER Paul Morgan <jumanjiman@gmail.com>

RUN yum update -y; yum clean all

RUN yum -y install git ruby rubygems; yum clean all
RUN gem install --no-rdoc --no-ri puppet-autostager

# Do not track changes in volumes.
RUN mkdir -p /opt/puppet/environments
VOLUME ["/opt/puppet/environments"]

CMD autostager
