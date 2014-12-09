* If HHVM isn't starting try removing /var/run/hhvm.sock and /var/run/hhvm.pid.


### To Do
* Switch to sock-based FCGI proxy. (http://blakepetersen.io/how-to-set-up-and-configure-hhvm-on-ubuntu-14-04/)

### Users & Services

* newrelic - (103) - newrelic-sysmond
* apache - (1000) - Apache2, PageSpeed
* hhvm - (1001) - HHVM
* memcache - (103) - Memcached 
* www-data - (33) -
* root - Supervisord
* hipstack - (500)


### Ports

* localhost:80 - Apache w/ PageSpeed
* localhost:8080 - Apache w/o PageSpeed
* localhost:9000 - HHVM
* localhost:11211 - MemcacheD

### Build Runtime Site

```
docker run -it --rm \
  --name=www.financialsocialwork.com \
  --volume=/root/.ssh:/root/.ssh \
  --volume=/opt/sources/UsabilityDynamics/www.financialsocialwork.com:/var/www \
  --volume=/opt/storage/UsabilityDynamics/www.financialsocialwork.com:/var/storage \
  --add-host=www.financialsocialwork.com:127.0.0.1 \
  --add-host=www.financialtherapynetwork.com:127.0.0.1 \
  --add-host=financialtherapynetwork.com:127.0.0.1 \
  --add-host=financialsocialwork.com:127.0.0.1 \
  --publish=49164:80 \
  --env=DOCKER_NAME=www.financialsocialwork.com \
  --env=DOCKER_IMAGE=usabilitydynamics/www.financialsocialwork.com \
  --env=DOCKER_HOST=$(hostname -f) \
  --env=DOCKER_MACHINE=$(hostname -f) \
  hipstack/hipstack
```

### Environment Variables
```
X-HIPSTACK-CONSTANTS={"DB_HOST":"localhost","DB_USER":"user","DB_PASSWORD":"password"}
```

### Environment Settings
```
export BUILD_ORGANIZATION=usabilitydynamics
export BUILD_REPOSITORY=wordpress
export BUILD_VERSION=0.1.2
```

### Run Commands
```
docker run -it --rm -v $(pwd):/var/www usabilitydynamics/hipstack ls
docker run -it --rm -v $(pwd):/var/www usabilitydynamics/hipstack cat /etc/apache2/apache2.conf
docker run -it --rm -v $(pwd):/var/www usabilitydynamics/hipstack cat /etc/apache2/apache2.conf
docker run -it --rm -v $(pwd):/var/www usabilitydynamics/hipstack
docker run -it --rm -v $(pwd):/var/www usabilitydynamics/hipstack pwd
docker run -it --rm -v $(pwd):/var/www usabilitydynamics/hipstack:latest
docker run -it --rm -v $(pwd):/var/www usabilitydynamics/hipstack hipstack info
docker run -it --rm -v $(pwd):/var/www usabilitydynamics/hipstack hipstack start
docker run -it --rm -v $(pwd):/var/www usabilitydynamics/hipstack hipstack list
docker run -it --rm -v $(pwd):/var/www usabilitydynamics/hipstack hipstack --help
```

### CLI Tool
```
hipstack info -e development
```

### Build, tag and Push
```
docker build -t ${BUILD_ORGANIZATION}/${BUILD_REPOSITORY}:latest ~/hipstack
docker tag ${BUILD_ORGANIZATION}/${BUILD_REPOSITORY}:latest ${BUILD_ORGANIZATION}/${BUILD_REPOSITORY}:${BUILD_VERSION}
docker push ${BUILD_ORGANIZATION}/${BUILD_REPOSITORY}:${BUILD_VERSION}
```

### Debugging
```
export APACHE_LOG_DIR="/var/log/apache2"
export APACHE_LOCK_DIR="/var/lock/apache2"
export APACHE_RUN_USER="apache"
export APACHE_RUN_GROUP="hipstack"
export APACHE_PID_FILE="/var/run/apache2/apache.pid"
export APACHE_RUN_DIR="/var/run/apache2",
export NODE_ENV="$(echo ${NODE_ENV})"
export PHP_ENV="$(echo ${PHP_ENV})"
export WP_DEBUG="$(echo ${WP_DEBUG})"
```

### CI Make Commands
```
make dockerImage;
make runTestContainer;
mocha test/functional
mocha test/acceptance
```