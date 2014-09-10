#################################################################
## HipStack Dockerfile.
##
##  export BUILD_ORGANIZATION=hipstack
##  export BUILD_REPOSITORY=hipstack
##  export BUILD_VERSION=0.1.2
##
##  docker build -t ${BUILD_ORGANIZATION}/${BUILD_REPOSITORY}:${BUILD_VERSION} .
##  docker run --rm --volume=$(pwd):/data$(pwd) --workdir=/data$(pwd) --env=NODE_ENV=development node npm install
##
## @ver 0.2.1
## @author potanin@UD
#################################################################


FROM          dockerfile/nodejs
MAINTAINER    Usability Dynamics, Inc. "http://usabilitydynamics.com"
USER          root

VOLUME        /home/hipstack/.packages
VOLUME        /home/hipstack/.composer
VOLUME        /home/hipstack/.composer/cache
VOLUME        /var/log
VOLUME        /var/www
VOLUME        /var/data

RUN           \
              groupadd --gid 500 hipstack && \
              useradd --create-home --shell /bin/bash --groups adm,sudo,users,www-data,root,ssh --uid 500 -g hipstack hipstack && \
              mkdir /home/hipstack/.ssh && \
              useradd -G hipstack apache && \
              useradd -G hipstack hhvm

RUN           \
              export DEBIAN_FRONTEND=noninteractive && \
              export NODE_ENV=development && \
              wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add - && \
              echo deb http://dl.hhvm.com/ubuntu trusty main | tee /etc/apt/sources.list.d/hhvm.list && \
              apt-get -y update && \
              apt-get -y upgrade

RUN           \
              export DEBIAN_FRONTEND=noninteractive && \
              export NODE_ENV=development && \
              apt-get -y -f install hhvm supervisor nano apache2 apache2-mpm-prefork apache2-utils libapache2-mod-php5 php-pear php5-dev graphviz php5-mysql && \
              apt-get -y -f install curl libcurl3 libcurl3-dev php5-curl && \
              npm install -g forever mocha should chai grunt-cli express && \
              a2enmod \
                dbd \
                rewrite \
                ssl \
                headers \
                remoteip \
                proxy \
                vhost_alias

RUN           \
              curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN           \
              pear channel-update pear.php.net && \
              pear upgrade-all && \
              pear channel-discover pear.phpunit.de && \
              pear channel-discover components.ez.no && \
              pear channel-discover pear.symfony-project.com && \
              pecl install -f xhprof

RUN           \
              cd /tmp && \
              wget -O /tmp/mod-pagespeed.deb https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb && \
              dpkg -i /tmp/mod-pagespeed.deb && \
              apt-get -f install

ADD           bin                                   /usr/local/src/hipstack/bin
ADD           lib                                   /usr/local/src/hipstack/lib
ADD           static/etc                            /usr/local/src/hipstack/static/etc
ADD           static/public                         /usr/local/src/hipstack/static/public
ADD           package.json                          /usr/local/src/hipstack/package.json
ADD           readme.md                             /usr/local/src/hipstack/readme.md

ADD           static/etc/apache2/apache2.conf       /etc/apache2/apache2.conf
ADD           static/etc/apache2/default.conf       /etc/apache2/sites-enabled/000-default.conf
ADD           static/etc/supervisord.conf           /etc/supervisor/supervisord.conf
ADD           static/etc/default/apache2.sh         /etc/default/apache2
ADD           static/etc/default/hipstack.sh        /etc/default/hipstack
ADD           static/etc/init.d/hipstack.sh         /etc/init.d/hipstack
ADD           static/public                         /var/www

RUN           \
              mkdir -p /var/run/hhvm && \
              mkdir -p /var/log/hhvm && \
              mkdir -p /var/log/apache2 && \
              mkdir -p /var/run/apache2 && \
              mkdir -p /var/log/pagespeed && \
              mkdir -p /etc/hipstack && \
              mkdir -p /etc/hipstack/ssl && \
              mkdir -p /var/lib/hipstack && \
              mkdir -p /var/log/hipstack && \
              mkdir -p /var/cache/hipstack && \
              mkdir -p /var/run/hipstack && \
              mkdir -p /var/run/supervisord && \
              mkdir -p /var/log/supervisor && \
              chown -R hipstack:hipstack   /var/log/supervisor && \
              chown -R apache:hipstack     /var/log/pagespeed && \
              chown -R apache:hipstack     /var/log/apache2 && \
              chown -R hhvm:hipstack       /var/log/hhvm && \
              chown -R hipstack:hipstack   /var/run/hhvm && \
              chown -R hipstack:hipstack   /var/run/supervisord && \
              chown -R hipstack:hipstack   /var/run/apache2 && \
              chown -R hipstack:hipstack   /var/run/hipstack && \
              chown -R hipstack:hipstack   /var/www && \
              chown -R hipstack:hipstack   /home/hipstack && \
              chmod g-w /var/www && \
              chmod g+s /var/www && \
              chown hipstack /var/log/pagespeed && \
              chown hipstack /var/log/hipstack && \
              chown hipstack /var/run && \
              chgrp hipstack /var/log && \
              chgrp hipstack /var/lib/hipstack && \
              chgrp hipstack /var/cache/hipstack && \
              chgrp hipstack /tmp

RUN           \
              export NODE_ENV=production && \
              npm link /usr/local/src/hipstack && \
              update-rc.d hhvm defaults && \
              update-rc.d hipstack defaults

RUN           \
              npm cache clean && apt-get autoremove && apt-get autoclean && apt-get clean && \
              rm -rf /var/log/*.log /var/log/lastlog /var/log/faillog && \
              rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
              rm -rf /var/run/hhvm/** && \
              chmod +x /etc/default/** && \
              chmod +x /etc/init.d/**

EXPOSE        80
EXPOSE        9000

ENV           NODE_ENV                        production
ENV           PHP_ENV                         production
ENV           APACHE_RUN_USER                 apache
ENV           APACHE_RUN_GROUP                hipstack
ENV           HHVM_RUN_GROUP                  hhvm
ENV           HHVM_RUN_USER                   hipstack
ENV           COMPOSER_HOME                   /home/hipstack/.composer
ENV           COMPOSER_NO_INTERACTION         true

WORKDIR       /var/www

ENTRYPOINT    /usr/local/bin/hipstack.entrypoint
CMD           /bin/bash

