Package {
  allow_virtual => false,
}

package { 'rsyslog':
  ensure        => latest,
  allow_virtual => false,
}

$cname = 'puppetdb.inf.ise.com'

# Hard-code the certname or else puppetdb-ssl-setup fails.
#
ini_setting { 'certname':
  ensure  => present,
  path    => '/etc/puppet/puppet.conf',
  section => 'main',
  setting => 'certname',
  value   => $cname,
}

# Use postgresql for backend db.
# http://docs.puppetlabs.com/puppetdb/2.1/configure.html
#
class { 'puppetdb':
  listen_address     => '0.0.0.0',
  listen_port        => '8080',
  disable_ssl        => false,
  ssl_listen_address => '0.0.0.0',
  ssl_listen_port    => '8081',
  node_ttl           => '7d',
  node_purge_ttl     => '7d',
  report_ttl         => '14d',
  gc_interval        => '60',
  require            => Ini_setting['certname'],
}

# Update puppetdb keystore.
# Note: it's a bit hackish to require Service[puppetdb],
# but we need to ensure all the bits are in place before
# we try to run puppetdb-ssl-setup.
#
exec { 'puppetdb-ssl-setup':
  command => '/usr/sbin/puppetdb ssl-setup',
  require => Service['puppetdb'],
}
