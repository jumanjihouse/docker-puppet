node default {
  notice('log a message on puppetmaster but otherwise do nothing')
  notify { "log a message on puppet agent ${::fqdn}": }
}
