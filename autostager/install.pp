Package {
  allow_virtual => false,
  ensure        => latest,
}

$rpms = [
  'git',
  'ruby',
  'rubygems',
]

$gems = [
  'puppet-autostager',
]

package { $rpms:
}

package { $gems:
  provider => gem,
}
