Package {
  allow_virtual => false,
}

$packages = [
  'bind-utils', # host and dig commands
  'diffutils',
  'elinks',
  'git',
  'net-tools',  # hostname command
  'man',
  'mlocate',
  'patch',
  'redhat-lsb',
  'redhat-rpm-config',
  'tree',
]

package { $packages:
  ensure => latest,
} ->

exec { 'updates':
  command => '/usr/bin/yum -y update && /usr/bin/yum clean all',
} ->

exec { '/usr/sbin/makewhatis':
} ->

exec { '/usr/bin/updatedb':
}

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
