#!/bin/bash
############################################################
##
## Allows for follow-through of commands.
## sh entrypoint.sh pwd
## will run the entrypoint scripts and then execute "pwd"
##
############################################################

[ -d /var/log/hhvm ]        || sudo mkdir /var/log/hhvm         2> /dev/null
[ -d /var/log/apache2 ]     || sudo mkdir /var/log/apache2      2> /dev/null
[ -d /var/log/supervisor ]  || sudo mkdir /var/log/supervisor   2> /dev/null

##sudo chown veneer /var/log/supervisor

rm -rf /var/run/hhvm.sock 2> /dev/null
rm -rv /var/log/hhvm/** 2> /dev/null

## Run SupervisorD
if [ -f "/usr/bin/supervisord" ]; then
  echo Starting Supervisor Service.
  supervisord -c /etc/supervisor/supervisord.conf -u root
fi

## Pipe/Follow-through other commands.
exec "$@"
