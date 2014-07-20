include bind

$forwarders = [
  '8.8.8.8',
  '8.8.4.4',
]

$allow_query = [
  'localnets',
  'any',
]

$listen_on_addr = [
  'any',
]

$listen_on_v6_addr = [
  'any',
]

$zones = {
  'inf.ise.com.' => [
    'type master',
    'file "inf.ise.com.zone"',
  ],
}

bind::server::conf { '/etc/named.conf':
  listen_on_addr    => $listen_on_addr,
  listen_on_v6_addr => $listen_on_v6_addr,
  forwarders        => $forwarders,
  allow_query       => $allow_query,
  zones             => $zones,
}

bind::server::file { 'inf.ise.com.zone':
  content => template('/tmp/inf.ise.com.zone.erb'),
}
