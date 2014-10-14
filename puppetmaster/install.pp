Package {
  allow_virtual => false,
}

# https://tickets.puppetlabs.com/browse/SERVER-24
#
file { '/var/lib/puppet/cli':
  ensure   => link,
  target   => '/usr/share/puppetserver/cli',
}

# https://github.com/puppetlabs/puppet-server/blob/master/documentation/gems.markdown
#
exec { 'install jruby gems':
  command  => 'puppetserver gem install etcd',
  path     => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  require  => [
    File['/var/lib/puppet/cli'],
    Package['puppetserver'],
  ],
}

# We build the docker image with latest version of puppet master.
# We can then A/B test the resulting container.
#
$version = 'latest'

# Master cert contains several names.
#
$cname = 'puppet.inf.ise.com'
$fqdns = [
  'ic-kix01.inf.ise.com',
  'ic-kix02.inf.ise.com',
  'ic-kix03.inf.ise.com',
  'ic-kix04.inf.ise.com',
]

# We use dynamic environments and store hiera.yaml in the repo.
# Each subdir of /opt/puppet/environments is an environment (git branch).
# Too bad puppet3 does not yet support per-environment `hiera_config`.
#
$environments    = 'directory'
$environmentpath = '/opt/puppet/environments'
$hiera_config    = '/opt/puppet/environments/production/hiera.yaml'

# We store every report in two, independetly verifiable places:
#
# * locally on the puppet master, and
# * centrally on the puppetdb.
#
$reports = 'store,puppetdb'

# storeconfigs: We explicitly disable stored configs and do not use
# exported resources because we consider it an anti-pattern to trust
# a host's current resources to be an input to other configurations.
# Also, using exported resources to configure other services means
# the puppetdb becomes a second source of truth that must be available
# and yet cannot deliver the level of record-level integrity that we
# demand via cryptographic hashes of the data. Additionally, stored
# configs and exported resources require manual, non-reproducible
# action to purge in case a node is deactivated. Here's a quote from
# http://docs.puppetlabs.com/puppetdb/2.1/maintain_and_tune.html
#
# > Deactivating a node does not remove (e.g. ensure => absent)
# > exported resources from other systems; it only stops managing
# > those resources. If you want to actively destroy resources from
# > deactivated nodes, you will probably need to purge that resource
# > type using the resources metatype. Note that some types cannot
# > be purged (e.g. ssh authorized keys), and several others usually
# > should not be purged (e.g. users).
#
$storeconfigs = false

package { 'puppetserver':
  ensure  => $version,
}

# Create /etc/puppet/puppet.conf and a passenger configuration to
# run puppetmaster within apache. See tuning recommendations at
# https://docs.puppetlabs.com/guides/passenger.html
#
class { 'puppet::master':
  autosign        => true,
  certname        => $cname,
  dns_alt_names   => $fqdns,
  environments    => $environments,
  environmentpath => $environmentpath,
  hiera_config    => $hiera_config,
  version         => $version,
  reports         => $reports,
  storeconfigs    => $storeconfigs,
}

# Add puppetdb params to /etc/puppet/puppet.conf.
#
class { 'puppetdb::master::config':
  puppetdb_server             => 'puppetdb.inf.ise.com',
  puppetdb_port               => '8081',
  puppetdb_soft_write_failure => true,  # puppetdb is for convenience; we don't rely on it.
  manage_report_processor     => false, # Do not interfere with puppet::master class above.
  manage_storeconfigs         => false, # Do not interfere with puppet::master class above.
  strict_validation           => false, # Allow docker images to build if puppetdb is down.
}

# Install hiera-etcd backend.
#
$url = 'https://raw.githubusercontent.com/garethr/hiera-etcd/master/lib/hiera/backend/etcd_backend.rb'
exec { 'install hiera-etcd':
  command => "/usr/bin/curl -sS -L -O $url",
  cwd     => '/usr/lib/ruby/site_ruby/1.8/hiera/backend',
  require => Package['puppet-server'],
}
