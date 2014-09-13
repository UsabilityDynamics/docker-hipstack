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
function make {

  docker run --rm \
    --env-file=/etc/environment \
    --env=HOME=/root \
    --env=WP_ENV=development \
    --env=NODE_ENV=development \
    --env=PHP_ENV=development \
    --env=DOCKER_HOST=172.17.42.1:16423 \
    --volume=/tmp:/tmp \
    --volume=/opt/sources:/opt/sources \
    --volume=/var/lib/docker:/var/lib/docker \
    --volume=/var/run/:/var/run \
    --volume=/root:/root \
    --volume=$(pwd):/data$(pwd) \
    --workdir=/data$(pwd) \
    andypotanin/builder make ${@}

}

## NPM commands
function npm {
  docker run --rm \
    --env-file=/etc/environment \
    --volume=$(pwd):/data$(pwd) \
    --workdir=/data$(pwd) \
    andypotanin/builder npm ${@}
}

## Node commands
function node {

  docker run --rm \
    --env-file=/etc/environment \
    --volume=$(pwd):/data$(pwd) \
    --workdir=/data$(pwd) \
    andypotanin/builder node ${@}

}

## Creates container and keeps it while Nano is open.
function nano {

  docker run --rm -ti \
    --env-file=/etc/environment \
    --volume=$(pwd):/data$(pwd) \
    --workdir=/data$(pwd) \
    andypotanin/builder nano ${@}

}

## Mocha Tests
function mocha {

  docker run --rm \
    --env-file=/etc/environment \
    --volume=$(pwd):/data$(pwd) \
    --workdir=/data$(pwd) \
    andypotanin/builder mocha ${@}

}

## ComposerJS
function composer {

  docker run --rm \
    --volume=/core:/core \
    --volume=/root:/root \
    --env-file=/etc/environment \
    --volume=$(pwd):/data$(pwd) \
    --workdir=/data$(pwd) \
    andypotanin/builder composer ${@}

}

## WP CLI
function wp {

  docker run --rm \
    --user=apache \
    --env-file=/etc/environment \
    --volume=$(pwd):/var/www \
    --workdir=/var/www \
    --env=PHP_ENV=production \
    --env=WP_ENV=production \
    hipstack/wordpress wp ${@}
}

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias ls='ls -hFG'
alias l='ls -lF'
alias ll='ls -alF'
alias lt='ls -ltrF'
alias ll='ls -alF'
alias lls='ls -alSrF'
alias llt='ls -altrF'

alias tarc='tar cvf'
alias tarcz='tar czvf'
alias tarx='tar xvf'
alias tarxz='tar xvzf'

alias g='git'
alias less='less -R'
alias os='lsb_release -a'
alias vi='vim'

# Colorize directory listing
alias ls="ls -ph --color=auto"

# Colorize grep
if echo hello|grep --color=auto l >/dev/null 2>&1; then
  export GREP_OPTIONS="--color=auto" GREP_COLOR="1;31"
fi

# Shell
export CLICOLOR="1"
export PS1="\[\033[40m\]\[\033[33m\][ \u@\H:\[\033[32m\]\w\[\033[33m\] ]$\[\033[0m\] "
export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=1;40:bd=34;40:cd=34;40:su=0;40:sg=0;40:tw=0;40:ow=0;40:"