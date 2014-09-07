#!/bin/bash
############################################################
##
## Allows for follow-through of commands.
## /usr/local/bin/hipstack.entrypoint pwd
## will run the entrypoint scripts and then execute "pwd"
##
## * SupervisorD is ran as root otherwise won't be able to bind to port 80.
##
## /usr/local/bin/hipstack.entrypoint
##
############################################################

## Ensure these essential directories exist
[ -d /var/log/hhvm ]          ||  mkdir /var/log/hhvm           2> /dev/null
[ -d /var/log/apache2 ]       ||  mkdir /var/log/apache2        2> /dev/null
[ -d /var/log/supervisord ]   ||  mkdir /var/log/supervisord    2> /dev/null
[ -d /var/log/pagespeed ]     ||  mkdir /var/log/pagespeed      2> /dev/null

## Fix ownership on web files
chown -R hipstack:hipstack    /home/hipstack
chown -R hipstack:hipstack    /var/www
chown -R apache:hipstack      /var/log/apache2
chown -R apache:hipstack      /var/log/pagespeed
chown -R apache:hipstack      /var/log/supervisord
chown -R hhvm:hipstack        /var/log/hhvm

## Cleanup
rm -rf /var/run/hhvm/**       2>  /dev/null
rm -rv /var/log/hhvm/**       2>  /dev/null
rm -rf /var/run/apache2/**    2>  /dev/null
rm -rv /var/log/apache2/**    2>  /dev/null

## No Argumens, start service and bash.
if [ "$*" == "" ] || [ ${1} == "/bin/bash" ]; then

  if [ -f "/usr/bin/supervisord" ]; then
    echo " - Starting Supervisor Service."
    supervisord -c /etc/supervisor/supervisord.conf -u root
  else
    echo " - Unable to start Supervisor, binary missing."
  fi

fi

## Pipe/Follow-through other commands.
exec "$@"
