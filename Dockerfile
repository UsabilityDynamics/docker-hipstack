#################################################################
## HipStack Dockerfile.
##
## @ver 0.2.1
## @author potanin@UD
#################################################################


FROM          dockerfile/nodejs
MAINTAINER    Usability Dynamics, Inc. "http://usabilitydynamics.com"
USER          root

RUN           \
              groupadd --gid 500 hipstack && \
              useradd --create-home --shell /bin/bash --groups adm,sudo,users,www-data,root,ssh --uid 500 -g hipstack hipstack && \
              mkdir -p /home/hipstack/.ssh && \
              useradd -G hipstack apache && \
              useradd -G hipstack hhvm

RUN           \
              export DEBIAN_FRONTEND=noninteractive && \
              export NODE_ENV=development && \
              wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add - && \
              echo deb http://dl.hhvm.com/ubuntu trusty main | tee /etc/apt/sources.list.d/hhvm.list && \
              echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list && \
              wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
              apt-get -y update && \
              apt-get -y upgrade

RUN           \
              export DEBIAN_FRONTEND=noninteractive && \
              export NODE_ENV=development && \
              apt-get -y -f install hhvm supervisor nano apache2 apache2-mpm-prefork apache2-utils libapache2-mod-php5 php-pear php5-dev mysql-client php5-mysql make libpcre3-dev memcached && \
              apt-get -y -f install curl libcurl3 libcurl3-dev php5-curl && \
              npm install -g mocha should grunt-cli && \
              a2enmod \
                dbd \
                rewrite \
                ssl \
                headers \
                expires \
                remoteip \
                proxy \
                vhost_alias

RUN           \
              /usr/share/hhvm/install_fastcgi.sh

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

ADD           bin /usr/local/src/hipstack/bin
ADD           lib /usr/local/src/hipstack/lib
ADD           static /usr/local/src/hipstack/static
ADD           package.json /usr/local/src/hipstack/package.json
ADD           readme.md /usr/local/src/hipstack/readme.md
ADD           static/public /var/www

ADD           https://gist.github.com/andypotanin/54238c5d0f439e781215/raw/bash.utils.sh /etc/profile.d/bash.utils.sh

RUN           \
              export NODE_ENV=production && \
              cd /usr/local/src/hipstack && \
              npm install --global

#ADD           bin/ lib/ test/ static/ package.json readme.md /usr/local/src/hipstack

RUN           \
              ln -fs /usr/local/src/hipstack/static/etc/apache2/apache2.conf /etc/apache2/apache2.conf && \
              ln -fs /usr/local/src/hipstack/static/etc/hhvm/php.ini /etc/hhvm/php.ini && \
              ln -fs /usr/local/src/hipstack/static/etc/hhvm/server.ini /etc/hhvm/server.ini && \
              ln -fs /usr/local/src/hipstack/static/etc/supervisord.conf /etc/supervisor/supervisord.conf && \
              ln -fs /usr/local/src/hipstack/static/etc/default/apache2.sh /etc/default/apache2 && \
              ln -fs /usr/local/src/hipstack/static/etc/default/hipstack.sh /etc/default/hipstack && \
              ln -fs /usr/local/src/hipstack/static/etc/default/mod-pagespeed.sh /etc/default/mod-pagespeed

RUN           \
              mkdir -p /var/www && \
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
              chmod +x /etc/default && \
              chown hipstack /var/log/pagespeed && \
              chown hipstack /var/log/hipstack && \
              chown hipstack /var/run && \
              chgrp hipstack /var/log && \
              chgrp hipstack /var/lib/hipstack && \
              chgrp hipstack /var/cache/hipstack && \
              chgrp hipstack /tmp

ONBUILD       RUN apt-get autoremove
ONBUILD       RUN apt-get autoclean
ONBUILD       RUN apt-get clean all
ONBUILD       RUN npm cache clean
ONBUILD       RUN rm -rf /tmp/* /tmp/** /var/tmp/* /var/tmp/**
ONBUILD       RUN rm -rf /var/run/**/*.pid /var/run/*.pid

EXPOSE        80

ENV           NODE_ENV                        production
ENV           PHP_ENV                         production

VOLUME        [ "/var/lib/memcached" ]
VOLUME        [ "/var/lib/hipstack" ]

WORKDIR       /var/www

ENTRYPOINT    [ "/usr/local/src/hipstack/bin/hipstack.entrypoint.sh" ]

CMD           [ "/bin/bash" ]

