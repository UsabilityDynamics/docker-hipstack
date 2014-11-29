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
[ -d /var/log/supervisor ]    ||  mkdir /var/log/supervisor     2> /dev/null
[ -d /var/log/pagespeed ]     ||  mkdir /var/log/pagespeed      2> /dev/null
[ -d /var/www ]               ||  mkdir /var/www                2> /dev/null

## Fix Ownership (may be read-only)
find /var/www -type d -exec chmod 755 {} +
find /var/www -type f -exec chmod 644 {} +
chmod -R u+rwX,go+rX,go-w /var/www
# chown -R 33 /var/www && \
# chmod g-w /var/www && \
# chmod g+s /var/www

## No Arguments, start service and bash.
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
