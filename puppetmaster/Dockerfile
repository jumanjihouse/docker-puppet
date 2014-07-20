FROM jumanjiman/puppetagent

# Install puppet master.
RUN puppet module install stephenrjohnson/puppet
RUN puppet module install puppetlabs/puppetdb
ADD install.pp /tmp/install.pp
RUN puppet apply /tmp/install.pp

# Fix up for Passenger 4.x
# https://ask.puppetlabs.com/question/1210/do-puppet-and-puppet-dashboard-work-with-passenger-40x/
RUN sed -i 's/^.*AutoDetect.*/# &/' /etc/httpd/conf.d/puppet_passenger.conf

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
