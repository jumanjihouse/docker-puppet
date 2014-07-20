# I want to use centos7, but epel7 lacks mod_passenger atm.
FROM tianon/centos:6.5

# Install EPEL yum repo.
#RUN rpm -Uvh http://ftp.linux.ncsu.edu/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Install puppet agent.
RUN rpm -Uvh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
RUN yum -y install puppet tar; yum clean all

# Install other useful stuff.
ADD files/ /files/
RUN puppet apply /files/install.pp

# Remediate security after all packages are installed.
RUN /files/remediate-oscap.sh

# Run oval security scan after remediation.
# This script exits non-zero if container is non-compliant,
# so 'docker build' fails if container has known vulnerabilities.
# IOW it's impossible to build an image with known vulnerabilities.
RUN /files/oval-vulnerability-scan.sh
