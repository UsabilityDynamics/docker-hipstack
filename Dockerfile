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
              wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add - && \
              echo deb http://dl.hhvm.com/ubuntu trusty main | tee /etc/apt/sources.list.d/hhvm.list && \
              echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list && \
              wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
              apt-get -y update && \
              apt-get -y upgrade

RUN           \
              export DEBIAN_FRONTEND=noninteractive && \
              apt-get -y -f install hhvm supervisor nano apache2 apache2-mpm-prefork apache2-utils libapache2-mod-php5 php-pear php5-dev mysql-client php5-mysql libpcre3-dev memcached && \
              apt-get -y -f install curl libcurl3 libcurl3-dev php5-curl && \
              npm install -g grunt-cli && \
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
              /usr/share/hhvm/install_fastcgi.sh && \
              update-rc.d hhvm defaults

RUN           \
              cd /tmp && \
              wget -O /tmp/mod-pagespeed.deb https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb && \
              dpkg -i /tmp/mod-pagespeed.deb && \
              apt-get -f install

ADD           / /usr/local/src/hipstack

RUN           \
              cd /usr/local/src/hipstack && \
              npm install --global

RUN           \
              ln -fs /usr/local/src/hipstack/static/etc/environment /etc/environment && \
              ln -fs /usr/local/src/hipstack/static/etc/apache2/apache2.conf /etc/apache2/apache2.conf && \
              ln -fs /usr/local/src/hipstack/static/etc/apache2/envvars.sh /etc/apache2/envvars && \
              ln -fs /usr/local/src/hipstack/static/etc/apache2/hhvm_proxy_fcgi.conf /etc/apache2/mods-available/hhvm_proxy_fcgi.conf && \
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
              mkdir -p /var/log/supervisor && \
              mkdir -p /var/log/memcached && \
              chown -R memcache:memcache   /var/log/memcached && \
              chown -R apache:apache     /var/log/pagespeed && \
              chown -R apache:apache     /var/log/apache2 && \
              chown -R hhvm:hhvm       /var/log/hhvm && \
              chown -R hhvm:hhvm   /var/run/hhvm && \
              chown -R apache:apache   /var/run/apache2 && \
              chown -R www-data:www-data   /var/www && \
              chmod +x /etc/default/*

# ONBUILD       RUN apt-get autoremove
# ONBUILD       RUN apt-get autoclean
# ONBUILD       RUN apt-get clean all
# ONBUILD       RUN npm cache clean
# ONBUILD       RUN rm -rf /var/run/**/*.pid /var/run/*.pid
# ONBUILD       RUN rm -rf /var/log/hhvm/* /var/log/apache2/* /var/log/supervisor/* /var/log/memcached/* /var/log/pagespeed/*

RUN           rm -rf /var/log/bootstrap.log /var/log/dpkg.log  /var/log/alternatives.log /var/log/faillog
RUN           rm -rf /tmp/* /tmp/** /var/tmp/* /var/tmp/**

EXPOSE        80

# ENV           NODE_ENV                        production
# ENV           PHP_ENV                         production

VOLUME        [ "/var/lib/memcached" ]
VOLUME        [ "/var/cache/apache2/mod_cache_disk" ]

WORKDIR       /var/www

ENTRYPOINT    [ "/usr/local/src/hipstack/bin/hipstack.entrypoint.sh" ]

CMD           [ "/bin/bash" ]

