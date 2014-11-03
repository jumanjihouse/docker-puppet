# I want to use centos7, but epel7 lacks mod_passenger atm.
FROM tianon/centos:6.5

# http://superuser.com/a/817649
RUN sed -i '/excludedocs/d' /etc/rpm/macros.imgcreate; \
    sed -i '/nodocs/d' /etc/yum.conf

# Install EPEL yum repo.
RUN yum -y install epel-release; yum clean all

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
