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
. /etc/environment

export APACHE_RUN_USER=hipstack
export APACHE_RUN_GROUP=hipstack
export APACHE_PID_FILE=/var/run/apache2/apache2$SUFFIX.pid
export APACHE_RUN_DIR=/var/run/apache2$SUFFIX
export APACHE_LOCK_DIR=/var/lock/apache2$SUFFIX
export APACHE_LOG_DIR=/var/log/apache2$SUFFIX
export LANG=C
export LANG

# export APACHE_LYNX='www-browser -dump'
# export APACHE_ULIMIT_MAX_FILES='ulimit -n 65536'
# export APACHE_ARGUMENTS=''
# export APACHE2_MAINTSCRIPT_DEBUG=1
