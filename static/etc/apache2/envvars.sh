#!/bin/sh
##
##
##
##
##
# for supporting multiple apache2 instances
if [ "${APACHE_CONFDIR##/etc/apache2-}" != "${APACHE_CONFDIR}" ] ; then
  SUFFIX="-${APACHE_CONFDIR##/etc/apache2-}"
else
  SUFFIX=
fi

# Load all the system environment variables.
if [ -f "/etc/environment" ]; then
  . /etc/environment
fi;

## Common
export PHP_ENV
export NODE_ENV
export WP_ENV
export APP_ENV

export DB_NAME
export DB_HOST
export DB_USER
export DB_PREFIX
export DB_PASSWORD

export DOCKER_HOST
export DOCKER_PORT

export WP_DEBUG
export WP_SITEURL
export WP_HOME

## Default
export APACHE_RUN_USER=hipstack
export APACHE_RUN_GROUP=hipstack
export APACHE_PID_FILE=/var/run/apache2/apache2$SUFFIX.pid
export APACHE_RUN_DIR=/var/run/apache2$SUFFIX
export APACHE_LOCK_DIR=/var/lock/apache2$SUFFIX
export APACHE_LOG_DIR=/var/log/apache2$SUFFIX
export LANG=C
export LANG