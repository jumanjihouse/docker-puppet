#!/bin/bash
# vim: set sw=2 ts=2 ai et:
set -e

if [[ $# -lt 1 ]]; then
  echo "ERR: you must pass 1 or more tags as arguments" >&2
  exit 1
fi

tags=$@

# The names of the images as built.
build_names="
jumanjiman/autostager
jumanjiman/puppetboard
jumanjiman/puppetdb
jumanjiman/puppetmaster
"

smitty() {
  echo "[INFO] $@"
  eval $@
}

docker login -e $ROBOT_EMAIL -u $ROBOT_USER -p $ROBOT_PASS

for build_name in $build_names; do
  echo "===== ${build_name} ====="
  for tag in $tags; do
    tagged_name="${build_name}:${tag}"

    # Ensure the image-to-be-tagged exists.
    docker images | grep ${build_name}

    # Create a new tag.
    smitty docker tag -f ${build_name} ${tagged_name}

    # Ensure the tagged image exists.
    docker images | grep ${build_name} | grep ${tag}

    # Publish the tagged image.
    smitty docker push ${tagged_name}

    echo
    echo
  done
done

docker logout
