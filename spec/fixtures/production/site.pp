node default {
  notice('log a message on puppetmaster but otherwise do nothing')
  notify { "log a message on puppet agent ${::fqdn}": }

  # foo exists in yaml backend.
  $foo = hiera('foo')
  notify { "foo is ${foo}": }
  if $foo != 'bar' { fail('foo not found') }

  # bar exists in etcd backend.
  $bar = hiera('bar')
  notify { "bar is ${bar}": }
  if $bar != 'baz' { fail('bar not found') }

  # baz exists in both, but we should read etcd first based on hiera.yaml.
  $baz = hiera('baz')
  notify { "baz is ${baz}": }
  if $baz != 'baz' { fail('baz is not baz') }

  # The hash exists in both, but we should read etcd first based on hiera.yaml.
  # The purpose of this is to demonstrate how to publish a complex data structure
  # in etcd (see script/00_build_start.sh) and read it via puppet manifest.
  #
  $hash = hiera_hash('hash')
  notify { $hash[nested_hash][msg_a]: }
  notify { $hash[nested_hash][msg_b]: }
  if $hash[nested_hash][msg_a] != 'Bob Schneider' { fail('msg_a is wrong') }
  if $hash[nested_hash][msg_b] != 'Tarantula!' { fail('msg_b is wrong') }
}
