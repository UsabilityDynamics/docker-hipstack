#################################################################
## Make Docker HipStack
##
##
##  export BUILD_ORGANIZATION=usabilitydynamics
##  export BUILD_REPOSITORY=hipstack
##  export BUILD_VERSION=0.1.0
##
##  docker build -t ${BUILD_ORGANIZATION}/${BUILD_REPOSITORY}:${BUILD_VERSION} .
##  docker run --rm --volume=$(pwd):/data$(pwd) --workdir=/data$(pwd) --env=NODE_ENV=development node npm install
##
##  ##  $(git branch | sed -n '/\* /s///p')
##
##
#################################################################

BUILD_ORGANIZATION	          ?=usabilitydynamics
BUILD_REPOSITORY		          ?=hipstack
BUILD_VERSION				          ?=0.1.0
BUILD_BRANCH		              ?=$(shell git branch | sed -n '/\* /s///p')

CONTAINER_NAME			          ?=hipstack
CONTAINER_HOSTNAME	          ?=hipstack.internal
CONTAINER_ENTRYPOINT	        ?=/usr/local/bin/hipstack.entrypoint

default: image

install:
	@docker run --rm --volume=$(pwd):/data$(pwd) --workdir=/data$(pwd) --env=NODE_ENV=development node npm install

image:
	docker build -t $(BUILD_ORGANIZATION)/$(BUILD_REPOSITORY):$(BUILD_VERSION) .

restart:
	@docker restart hipstack

stop:
	@docker stop hipstack

start:
	@docker rm -f hipstack
	run

tests:
	@echo "Testing HipStack <${BUILD_BRANCH}> branch."
	@mocha test/unit
	@mocha test/functional
	@mocha test/integration

run:
	@echo "Running ${CONTAINER_NAME}."
	@echo "Checking and dumping previous runtime. $(shell docker rm -f ${CONTAINER_NAME} 2>/dev/null; true)"
	@sudo docker run -itd \
		--name=${CONTAINER_NAME} \
		--hostname=${CONTAINER_HOSTNAME} \
		--entrypoint=${CONTAINER_ENTRYPOINT} \
		--publish=80 \
		--workdir=/var/www \
		--env=HOME=/home/hipstack \
		--env=NODE_ENV=${NODE_ENV} \
		--env=PHP_ENV=${PHP_ENV} \
		$(BUILD_ORGANIZATION)/$(BUILD_REPOSITORY):$(BUILD_VERSION)
	@docker logs ${CONTAINER_NAME}

release:
	docker push $(BUILD_ORGANIZATION)/$(BUILD_REPOSITORY):$(BUILD_VERSION)
