FROM jumanjiman/puppetagent

# We need this before install.
ADD ssl /var/lib/puppet/ssl
RUN chown -R puppet:puppet /var/lib/puppet/ssl

# Install puppetdb.
RUN puppet module install puppetlabs/puppetdb --version 4.2.1
ADD install.pp /tmp/install.pp
# Run puppet twice if necessary to work around rpmdb error
# https://bugzilla.redhat.com/show_bug.cgi?id=1213602#c13
RUN puppet apply /tmp/install.pp 2>&1 | tee /tmp/install.out; \
    grep -i skip /tmp/install.out && puppet apply /tmp/install.pp; \
    rm -f /tmp/install.out

ADD start.sh /usr/local/sbin/start.sh

EXPOSE 8080
EXPOSE 8081
CMD ["/usr/local/sbin/start.sh"]
