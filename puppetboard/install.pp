Package {
  allow_virtual => false,
}

# Access puppetboard at http://puppetboard.inf.ise.com/
$cname = 'puppetboard.inf.ise.com'

# How many hours after which a node is considered
# "unresponsive" or "unreported". We only enforce
# prod puppet runs once per day, so we allow this
# to go over a day.
$unreported = 25

# Hard-code the certname.
#
ini_setting { 'certname':
  ensure  => present,
  path    => '/etc/puppet/puppet.conf',
  section => 'main',
  setting => 'certname',
  value   => $cname,
}

class { 'puppetboard':
  puppetdb_host     => 'puppetdb.inf.ise.com',
  puppetdb_port     => '8081',
  puppetdb_ssl      => false,
  puppetdb_cert     => '/etc/puppetboard/puppetboard.inf.ise.com.pem',
  puppetdb_key      => '/etc/puppetboard/private/puppetboard.inf.ise.com.pem',
  python_loglevel   => 'debug',
  experimental      => false,
  manage_git        => false,
  manage_virtualenv => true,
  unresponsive      => $unreported,
}

# Configure apache.
#
class { 'apache':
  purge_configs => false,
  mpm_module    => 'prefork',
  default_vhost => true,
  default_mods  => false,
  trace_enable  => 'Off',     # CVE-2004-2320
}

class { 'apache::mod::wsgi':
  wsgi_socket_prefix => '/var/run/wsgi',
}

# Configure a name-based apache virtual host.
#
class { 'puppetboard::apache::vhost':
  vhost_name => $cname,
  port       => 80,
}
