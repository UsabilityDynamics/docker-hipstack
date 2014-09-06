* If HHVM isn't starting try removing /var/run/hhvm.sock and /var/run/hhvm.pid.



    docker run -itd \
      --name=www.site1.com \
      --hostname=www.site1.com \
      --publish=80 \
      --entrypoint=/etc/entrypoints/hhvm \
      --volume=/home/core/entrypoints:/etc/entrypoints \
      --volume=/home/core/tmp/www:/var/www \
      --env=APACHE_LOG_DIR=/var/log/apache2 \
      --env=APACHE_RUN_USER=docker \
      --env=APACHE_RUN_GROUP=docker \
      --env=RUN_AS_USER=docker \
      --env=RUN_AS_GROUP=docker \
      --env=PHP_ENV=production \
      andypotanin/hhvm /bin/bash
