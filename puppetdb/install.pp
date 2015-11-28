Package {
  allow_virtual => false,
}

package { 'rsyslog':
  ensure        => latest,
  allow_virtual => false,
}

$cname = 'puppetdb.inf.ise.com'

# Merge these java args into the args that live in
# /etc/sysconfig/puppetdb.
#
# This replaces individual args, so we don't have
# to specify the complete set.
#
# If you leave this empty, you get the default set.
# If you add one item, it either clobbers the default item of same name
# or gets added into the set with /etc/sysconfig/puppetdb.
#
# https://docs.puppetlabs.com/puppetdb/2.2/configure.html
# https://github.com/puppetlabs/puppetlabs-puppetdb#java_args
#
$java_args = {
  '-Xms'      => '192m', # initial memory allocation pool (java heap)
  '-Xmx'      => '512m', # maximum memory allocation pool (java heap)
  '-XX:OnOutOfMemoryError' => "='kill -9 %p'", # not idempotent
}

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
  confdir            => '/etc/puppetdb/conf.d',
  listen_address     => '0.0.0.0',
  listen_port        => '8080',
  disable_ssl        => false,
  ssl_listen_address => '0.0.0.0',
  ssl_listen_port    => '8081',
  node_ttl           => '7d',
  node_purge_ttl     => '7d',
  report_ttl         => '14d',
  gc_interval        => '60',
  java_args          => $java_args,
  puppetdb_version   => '2.3.8-1.el6', # must match version in puppetmaster/Dockerfile
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

# Allow to build this image on a host that has larger
# kernel.shmmax than the target deployment host.
# During build, postgres `initdb` automatically determines
# tunables, so we have to override them if we want to
# deploy the image to a host with different resources.
#
# https://github.com/jumanjihouse/docker-puppet/issues/15
#
postgresql::server::config_entry { 'shared_buffers':
  value   => '3580',
  require => Class['puppetdb'],
}
