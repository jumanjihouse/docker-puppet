Package {
  allow_virtual => false,
}

$packages = [
  'elinks',
  'net-tools',  # hostname command
  'redhat-lsb',
  'redhat-rpm-config',
]

package { $packages:
  ensure => latest,
} ->

exec { 'updates':
  command => '/usr/bin/yum -y update && /usr/bin/yum clean all',
} ->

# If /etc/securetty exists and is zero-length,
# then root cannot login directly.
#
# Disabling direct root logins ensures proper accountability and multifactor
# authentication to privileged accounts. Users will first login, then escalate
# to privileged (root) access via su / sudo.
#
# References:
#
# - IA-2(1): http://csrc.nist.gov/publications/nistpubs/800-53-Rev3/sp800-53-rev3-final.pdf
# - AC-6(2): http://csrc.nist.gov/publications/nistpubs/800-53-Rev3/sp800-53-rev3-final.pdf
# - 770: http://iase.disa.mil/cci/index.html
#
file { '/etc/securetty':
  ensure  => file,
  content => '',
  backup  => false,
}
