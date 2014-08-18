# I want to use centos7, but epel7 lacks mod_passenger atm.
#FROM tianon/centos:6.5
# RHEL 7 based container
FROM rhel
ENV http_proxy http://proxy.inf.ise.com:3128/

# Install EPEL yum repo.
#RUN rpm -Uvh http://ftp.linux.ncsu.edu/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm
#RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
# Not sure if required. Should inherit from Atomic host

# Install puppet agent.
#RUN rpm -Uvh http://yum.puppetlabs.com/puppetlabs-release-el-5.noarch.rpm
RUN rpm -Uvh --httpproxy=proxy.inf.ise.com --httpport=3128 http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
RUN yum -y install puppet tar; yum clean all

# Install other useful stuff.
# Commented out for now. Working on one thing at a time.
#ADD files/ /files/
#RUN puppet apply /files/install.pp
#RUN /files/remediate-oscap.sh
