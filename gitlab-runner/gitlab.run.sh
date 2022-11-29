#!/bin/bash

# This will be the directory to save our artifacts
TEMPDIR=$(mktemp -p . -d)

# You can choose to run a different job
[[ -z "$1" ]] && JOB="run-build" || JOB="$1"

# GitLab Runner - docker
gitlab-runner exec docker \
    --docker-dns=1.1.1.1  \
    --docker-volumes=$PWD/${TEMPDIR}:/builds:rw \
        ${JOB}

# Fix perms in artifacts directory
sudo chown -R $(id -u):$(id -g) ${TEMPDIR}
