# https://index.docker.io/_/fedora/
FROM fedora:20

# http://jumanjiman.github.io/
MAINTAINER Paul Morgan <jumanjiman@gmail.com>

RUN yum update -y; yum clean all

RUN rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-fedora-20.noarch.rpm
RUN yum -y install puppet; yum clean all

ADD install.pp /tmp/
RUN puppet apply /tmp/install.pp

# Do not track changes in volumes.
RUN mkdir -p /opt/puppet/environments
VOLUME ["/opt/puppet/environments"]

CMD autostager
