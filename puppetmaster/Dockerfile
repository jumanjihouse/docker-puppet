FROM jumanjiman/puppetagent

# Install puppet master.
RUN puppet module install puppetlabs/puppetdb --version 4.2.1
RUN puppet module install stephenrjohnson/puppet
RUN puppet module install puppetlabs/vcsrepo

# https://bugzilla.redhat.com/show_bug.cgi?id=1213602#c13
RUN yum clean all && touch /var/lib/rpm/*

ADD install.pp /tmp/install.pp
RUN puppet apply /tmp/install.pp
ADD auth.conf.patch /etc/puppet/auth.conf.patch
RUN cd /etc/puppet; patch -p0 < auth.conf.patch

# Fix up for Passenger 4.x
# https://ask.puppetlabs.com/question/1210/do-puppet-and-puppet-dashboard-work-with-passenger-40x/
RUN sed -i 's/^.*AutoDetect.*/# &/' /etc/httpd/conf.d/puppet_passenger.conf

# Log to stdout.
RUN sed -i 's/CustomLog.*/CustomLog "|cat" common/g' /etc/httpd/conf.d/40-puppet-puppet.inf.ise.com.conf
RUN sed -i 's/ErrorLog.*/ErrorLog "|cat"/g' /etc/httpd/conf.d/40-puppet-puppet.inf.ise.com.conf

ADD start.sh /usr/local/sbin/start.sh
ADD ssl /var/lib/puppet/ssl
RUN chown -R puppet:puppet /var/lib/puppet/ssl

# We use separate data container for SSL certs.
# (Or, we would like to.)
VOLUME ["/var/lib/puppet/ssl/"]

# We use dynamic environments.
VOLUME ["/opt/puppet/environments/"]

EXPOSE 8140
CMD ["/usr/local/sbin/start.sh"]
