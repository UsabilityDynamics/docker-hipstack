* If HHVM isn't starting try removing /var/run/hhvm.sock and /var/run/hhvm.pid.

### Environment Settings
```
export BUILD_ORGANIZATION=usabilitydynamics
export BUILD_REPOSITORY=wordpress
export BUILD_VERSION=0.1.1
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