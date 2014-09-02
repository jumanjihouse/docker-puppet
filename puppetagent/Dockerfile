# I want to use centos7, but epel7 lacks mod_passenger atm.
FROM tianon/centos:6.5

# Install EPEL yum repo.
#RUN rpm -Uvh http://ftp.linux.ncsu.edu/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Add oval vulnerability scan script(s).
ADD oval /oval

# Install puppet agent.
RUN rpm -Uvh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
RUN yum -y install puppet tar; yum clean all

# Install other useful stuff.
ADD files/ /files/
RUN puppet apply /files/install.pp

# Remediate security after all packages are installed.
RUN /files/remediate-oscap.sh
