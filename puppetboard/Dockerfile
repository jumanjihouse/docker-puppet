FROM jumanjiman/puppetagent

# Install puppetboard.
RUN puppet module install nibalizer/puppetboard
RUN puppet module install puppetlabs/apache
RUN puppet module install puppetlabs/inifile
ADD install.pp /tmp/install.pp
RUN puppet apply /tmp/install.pp

ADD start.sh /usr/local/sbin/start.sh
ADD ssl /var/lib/puppet/ssl
RUN chown -R puppet:puppet /var/lib/puppet/ssl

# Put certs in place.
RUN mkdir -p /etc/puppetboard/private; \
    cp /var/lib/puppet/ssl/private_keys/puppetboard.inf.ise.com.pem /etc/puppetboard/private/; \
    cp /var/lib/puppet/ssl/certs/puppetboard.inf.ise.com.pem /etc/puppetboard/; \
    cp /var/lib/puppet/ssl/certs/ca.pem /etc/puppetboard/; \
    chmod -R a+r /etc/puppetboard; \
    :

EXPOSE 80

CMD ["/usr/local/sbin/start.sh"]
