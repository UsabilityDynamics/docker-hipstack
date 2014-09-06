#################################################################
## UD HHVM
##
## docker build -t usabilitydynamics/hhvm:0.1.0 --rm .
##
## * http://ryansechrest.com/2013/08/managing-file-and-folder-permissions-when-deploying-with-git/
##
## @ver 0.2.1
## @author potanin@UD
#################################################################

FROM          dockerfile/nodejs
MAINTAINER    Usability Dynamics, Inc. "http://usabilitydynamics.com"
USER          root

VOLUME        /var/log
VOLUME        /var/www

ADD           bin                                   /usr/local/src/hipstack/bin
ADD           lib                                   /usr/local/src/hipstack/lib
ADD           node_modules                          /usr/local/src/hipstack/node_modules
ADD           static/etc                            /usr/local/src/hipstack/static/etc
ADD           static/public                         /usr/local/src/hipstack/static/public
ADD           package.json                          /usr/local/src/hipstack/package.json
ADD           readme.md                             /usr/local/src/hipstack/readme.md

RUN           \
              groupadd --gid 500 hipstack && \
              useradd --create-home --shell /bin/bash --groups adm,sudo --uid 500 -g hipstack hipstack && \
              mkdir /home/hipstack/.ssh

RUN           \
              export DEBIAN_FRONTEND=noninteractive && \
              export NODE_ENV=development && \
              wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add - && \
              echo deb http://dl.hhvm.com/ubuntu trusty main | tee /etc/apt/sources.list.d/hhvm.list && \
              apt-get -y update && \
              apt-get -y upgrade

RUN           \
              apt-get -y -f install hhvm supervisor nano apache2 apache2-mpm-prefork apache2-utils libapache2-mod-php5 && \
              npm install -g forever mocha should chai grunt-cli express && \
              a2enmod rewrite && \
              useradd -G hipstack apache && \
              useradd -G hipstack hhvm

RUN           \
              cd /tmp && \
              wget -O /tmp/mod-pagespeed.deb https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb && \
              dpkg -i /tmp/mod-pagespeed.deb && \
              apt-get -f install

ADD           static/etc/apache2/apache2.conf       /etc/apache2/sites-enabled/apache2.conf
ADD           static/etc/apache2/default.conf       /etc/apache2/sites-enabled/default.conf
ADD           static/etc/supervisord.conf           /etc/supervisor/supervisord.conf
ADD           static/etc/default/apache2.sh         /etc/default/apache2
ADD           static/etc/default/hipstack.sh        /etc/default/hipstack
ADD           static/etc/init.d/hipstack.sh         /etc/init.d/hipstack

RUN           \
              export NODE_ENV=production && \
              mkdir -p /var/run/hhvm && \
              mkdir -p /var/log/hhvm && \
              mkdir -p /var/log/pagespeed && \
              mkdir -p /etc/hipstack && \
              mkdir -p /etc/hipstack/ssl && \
              mkdir -p /var/lib/hipstack && \
              mkdir -p /var/log/hipstack && \
              mkdir -p /var/cache/hipstack && \
              mkdir -p /var/run/hipstack && \
              mkdir -p /var/run/supervisor && \
              mkdir -p /var/log/supervisor && \
              chgrp -R hipstack /var/lib/hipstack && \
              chgrp -R hipstack /var/www && \
              chmod g-w /var/www && \
              chmod g+s /var/www && \
              chgrp hipstack /var/log/pagespeed && \
              chgrp hipstack /var/log/hipstack && \
              chgrp hipstack /var/run/hipstack && \
              chgrp hipstack /var/cache/hipstack && \
              chgrp hipstack /tmp && \
              npm link /usr/local/src/hipstack

RUN           \
              update-rc.d hhvm defaults && \
              update-rc.d supervisor defaults && \
              update-rc.d apache2 defaults && \
              update-rc.d hipstack defaults

RUN           \
              npm cache clean && apt-get autoremove && apt-get autoclean && apt-get clean && \
              rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
              chmod +x /etc/default/** && \
              chmod +x /etc/init.d/**

EXPOSE        80

ENV           NODE_ENV                        production
ENV           PHP_ENV                         production
ENV           APACHE_RUN_USER                 hipstack
ENV           APACHE_RUN_GROUP                hipstack
ENV           HHVM_RUN_GROUP                  hipstack
ENV           HHVM_RUN_USER                   hipstack

WORKDIR       /home/hipstack

ENTRYPOINT    [ "/usr/local/bin/hipstack.entrypoint" ]
CMD           [ "/bin/bash" ]

