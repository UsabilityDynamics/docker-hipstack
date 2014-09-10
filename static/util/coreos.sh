#!/bin/sh
##
## Notes:
## * Make sure that DOCKER_HOST is in /etc/environment so "docker" commands will work.
## * We volue-mount /core:/core and /root:/root to make sure all SSH, configs, caches are shared with container.
##
## Start Terminal:
## * docker run --rm -it --env-file=/etc/environment --volume=$(pwd):/data$(pwd) --workdir=/data$(pwd) andypotanin/node /bin/bash
##

## Execute Makefile.
alias make="docker run --rm \
  --env-file=/etc/environment \
  --env=HOME=/root \
  --env=WP_ENV=development \
  --env=NODE_ENV=development \
  --env=PHP_ENV=development \
  --volume=/root:/root \
  --volume=$(pwd):/data$(pwd) \
  --workdir=/data$(pwd) \
  andypotanin/builder make ${@}"

## NPM commands
alias npm="docker run --rm \
  --env-file=/etc/environment \
  --volume=$(pwd):/data$(pwd) \
  --workdir=/data$(pwd) \
  andypotanin/builder npm ${@}"

## Node commands
alias node="docker run --rm \
  --env-file=/etc/environment \
  --volume=$(pwd):/data$(pwd) \
  --workdir=/data$(pwd) \
  andypotanin/builder node ${@}"

## Creates container and keeps it while Nano is open.
alias nano="docker run --rm -ti \
  --env-file=/etc/environment \
  --volume=$(pwd):/data$(pwd) \
  --workdir=/data$(pwd) \
  andypotanin/builder nano ${@}"

## Mocha Tests
alias mocha="docker run --rm \
  --env-file=/etc/environment \
  --volume=$(pwd):/data$(pwd) \
  --workdir=/data$(pwd) \
  andypotanin/builder mocha ${@}"

## ComposerJS
alias composer="docker run --rm \
  --volume=/core:/core \
  --volume=/root:/root \
  --env-file=/etc/environment \
  --volume=$(pwd):/data$(pwd) \
  --workdir=/data$(pwd) \
  hipstack/hipstack composer ${@}"

## HipStack CLI
alias hipstack="docker run --rm \
  --env-file=/etc/environment \
  --volume=$(pwd):/var/www \
  --workdir=/var/www \
  hipstack/hipstack hipstack ${@}"

## PHP CLI
alias hhvm="docker run --rm \
  --env-file=/etc/environment \
  --volume=$(pwd):/var/www \
  --workdir=/var/www \
  hipstack/hipstack hhvm ${@}"
