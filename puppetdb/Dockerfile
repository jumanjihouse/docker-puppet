FROM jumanjiman/puppetagent

# We need this before install.
ADD ssl /var/lib/puppet/ssl
RUN chown -R puppet:puppet /var/lib/puppet/ssl

# Install puppetdb.
RUN puppet module install puppetlabs/puppetdb
ADD install.pp /tmp/install.pp
RUN puppet apply /tmp/install.pp

ADD start.sh /usr/local/sbin/start.sh

EXPOSE 8080
EXPOSE 8081
CMD ["/usr/local/sbin/start.sh"]
