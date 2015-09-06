Overview
--------

This repo contains scripts and source to build docker images for:

* [![](https://badge.imagelayers.io/jumanjiman/puppetagent.svg)](https://imagelayers.io/?images=jumanjiman/puppetagent:latest 'Size') Puppet Agent
* [![](https://badge.imagelayers.io/jumanjiman/puppetmaster.svg)](https://imagelayers.io/?images=jumanjiman/puppetmaster:latest 'Size') Puppet Master
* [![](https://badge.imagelayers.io/jumanjiman/puppetdb.svg)](https://imagelayers.io/?images=jumanjiman/puppetdb:latest 'Size') Puppet DB
* [![](https://badge.imagelayers.io/jumanjiman/puppetboard.svg)](https://imagelayers.io/?images=jumanjiman/puppetboard:latest 'Size') PuppetBoard (dashboard)

Build status: [![Circle CI](https://circleci.com/gh/jumanjihouse/docker-puppet/tree/master.svg?style=svg&circle-token=ac0d72e97fa5b75ba775ba8d12994f09d036ae7b)](https://circleci.com/gh/jumanjihouse/docker-puppet/tree/master)

The build and test harness also pushes these images
to the docker hub. Each image has two tags:

* DateTime of build plus commit hash of this repo at the time of build, and
* "latest", which points to the latest commit hash tag.


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


Troubleshooting
---------------

### Outside a container

```bash
# List active containers.
docker ps

# List all containers.
docker ps -a

# Follow logs from a container.
docker logs -f <container-id>
```


### Inside a container

```bash
# This examples assumes the puppetmaster.service container.
PID=$(docker inspect --format {{.State.Pid}} puppetmaster.service)
sudo nsenter --target $PID --mount --uts --ipc --net --pid

# Run various commands, then
# Press CTRL-D to exit.
```


OVAL vulnerability scan
-----------------------

You can perform the scan inside a running container via:

    /oval/vulnerability-scan.sh

See https://github.com/jumanjihouse/oval for details.

TODO: Implement some sort of CD system to poll the OVAL feed and rebuild
the image on any update. https://github.com/jumanjiman/docker-gocd may be
a candidate for the solution.


Contributing
------------

### Diff churn

Please minimize diff churn to enhance git history commands.

* Arrays should usually be multi-line with trailing commas.

* Use 2-space soft tabs and trim trailing whitespace.<br/>
  http://editorconfig.org provides editor plugins to handle this
  for you automatically based on the `.editorconfig` in this repo.


### Linear history

Use `git rebase upstream/master` to update your branch.
The primary reason for this is to maintain a clean, linear history
via "fast-forward" merges to master.
A clean, linear history in master makes it easier
to troubleshoot regressions and follow the timeline.


### Commit messages

Please provide good commit messages, such as<br/>
http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html


### Topic branch + pull request (PR)

To submit a patch, fork the repo and work within
a [topic branch](http://progit.org/book/ch3-4.html) of your fork.

1. Bootstrap your dev environment

   ```bash
   git submodule update --init --recursive
   git remote add upstream https://github.com/jumanjihouse/docker-puppet.git
   ```

1. Set up a remote tracking branch

    ```bash
    git checkout -b <branch_name>

    # Initial push with `-u` option sets remote tracking branch.
    git push -u origin <branch_name>
    ```

1. Ensure your branch is up-to-date:

    ```bash
    git fetch --prune upstream
    git rebase upstream/master
    git push -f
    ```

1. Submit a [Pull Request](https://help.github.com/articles/using-pull-requests)
   - Participate in [code review](https://github.com/features/projects/codereview)
   - Participate in [code comments](https://github.com/blog/42-commit-comments)


### Testing

You can run tests **locally** via:

    script/build.sh && script/test

Trigger a rebuild-and-test cycle to get latest package updates:

    date > REBUILD
    git add REBUILD
    git commit -m 'build with latest package updates'
    # Open pull request.


License
-------

See LICENSE in this repo.


References
----------

* https://docs.puppetlabs.com/
* https://docs.docker.com/
* https://coreos.com/docs/
* https://github.com/jpetazzo/nsenter
* https://github.com/puppet-community/puppetboard


:warning: Warning
-----------------

Use CoreOS to build this since CoreOS uses BTRFS, not AUFS.
See https://github.com/dotcloud/docker/issues/6980 for relevant bug.
