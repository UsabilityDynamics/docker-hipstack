#!/bin/sh
##
## This is a configuration file for /etc/init.d/hhvm.
## Overwrite start up configuration of the hhvm service.
##
CONFIG_FILE="/etc/hhvm/server.ini"

## User to run the service as.
RUN_AS_USER=${HHVM_RUN_USER:=hhvm}
RUN_AS_GROUP=${HHVM_RUN_USER:=hhvm}

#ADDITIONAL_ARGS="-vServer.Port=9000 -vServer.FileSocket=/var/run/hhvm.sock -vLog.Level=Debug -vServer.DefaultDocument=index.php"

## PID file location.
#PIDFILE="/var/run/hhvm/hhvm.pid"

