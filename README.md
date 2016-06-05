Overview
--------

PuppetMaster, PuppetDB, PuppetBoard, and Autostager

Source: https://github.com/jumanjihouse/docker-puppet

Build status: [![Circle CI](https://circleci.com/gh/jumanjihouse/docker-puppet/tree/master.svg?style=svg&circle-token=ac0d72e97fa5b75ba775ba8d12994f09d036ae7b)](https://circleci.com/gh/jumanjihouse/docker-puppet/tree/master)

Docker hub:

* https://hub.docker.com/r/jumanjiman/autostager/<br/>
  [![](https://imagelayers.io/badge/jumanjiman/autostager:latest.svg)](https://imagelayers.io/?images=jumanjiman/autostager:latest 'View on imagelayers.io')&nbsp;
  [![Docker Registry](https://img.shields.io/docker/pulls/jumanjiman/autostager.svg)](https://registry.hub.docker.com/u/jumanjiman/autostager 'Docker Hub')&nbsp;

* https://hub.docker.com/r/jumanjiman/puppetmaster/<br/>
  [![](https://imagelayers.io/badge/jumanjiman/puppetmaster:latest.svg)](https://imagelayers.io/?images=jumanjiman/puppetmaster:latest 'View on imagelayers.io')&nbsp;
  [![Docker Registry](https://img.shields.io/docker/pulls/jumanjiman/puppetmaster.svg)](https://registry.hub.docker.com/u/jumanjiman/puppetmaster 'Docker Hub')&nbsp;

* https://hub.docker.com/r/jumanjiman/puppetdb/<br/>
  [![](https://imagelayers.io/badge/jumanjiman/puppetdb:latest.svg)](https://imagelayers.io/?images=jumanjiman/puppetdb:latest 'View on imagelayers.io')&nbsp;
  [![Docker Registry](https://img.shields.io/docker/pulls/jumanjiman/puppetdb.svg)](https://registry.hub.docker.com/u/jumanjiman/puppetdb 'Docker Hub')&nbsp;

* https://hub.docker.com/r/jumanjiman/puppetboard/<br/>
  [![](https://imagelayers.io/badge/jumanjiman/puppetboard:latest.svg)](https://imagelayers.io/?images=jumanjiman/puppetboard:latest 'View on imagelayers.io')&nbsp;
  [![Docker Registry](https://img.shields.io/docker/pulls/jumanjiman/puppetboard.svg)](https://registry.hub.docker.com/u/jumanjiman/puppetboard 'Docker Hub')&nbsp;

Docker tags:

* optimistic: `latest`
* pessimistic: `${build-date}-git-${hash}`

Note: See [jumanjihouse/puppet-on-coreos](https://github.com/jumanjihouse/puppet-on-coreos)
for a Puppet Agent inside Docker.

Deployment
----------

These instructions are for the repo as-is.

You need either one or two CoreOS hosts.
One host should resolve to **puppet.inf.ise.com**.
The other host should resolve to both **puppetdb.inf.ise.com**
and **puppetboard.inf.ise.com**.

1. On each host:

   ```bash
   # Public repo. No credentials are required.
   git clone https://github.com/jumanjihouse/docker-puppet.git
   cd docker-puppet
   ```

1. On each host, create `/etc/autostager.env`:

   ```
   access_token=<your 40 char oauth token>
   repo_slug=ISEexchange/puppet
   sleep_interval=60
   tag=latest
   # Optionally, use a specific tagged build.
   # tag=<hash>
   ```

1. If using a single host for deployment: `script/deploy-single`

1. If using two hosts for deployment...

   * On **puppetdb.inf.ise.com**: `script/deploy-db`
   * On **puppet.inf.ise.com**: `script/deploy-master`

1. Open http://puppetdb.inf.ise.com:8080.
   You should see the JVM Heap sparkleline.

1. Open http://puppetboard.inf.ise.com/puppetboard/.
   You should see the handsome dashboard.


Contributing
------------

See [`CONTRIBUTING.md`](CONTRIBUTING.md) in this repo.


License
-------

See [`LICENSE`](LICENSE) in this repo.


References
----------

* https://docs.puppetlabs.com/
* https://docs.docker.com/
* https://coreos.com/docs/
* https://github.com/puppet-community/puppetboard


:warning: Warning
-----------------

Use CoreOS to build this since CoreOS uses BTRFS, not AUFS.
See https://github.com/dotcloud/docker/issues/6980 for relevant bug.
