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
}
