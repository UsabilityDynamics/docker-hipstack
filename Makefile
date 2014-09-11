#################################################################
## Make Docker HipStack
##
##  export BUILD_ORGANIZATION=hipstack
##  export BUILD_REPOSITORY=hipstack
##  export BUILD_VERSION=$(hipstack -V)
##
##  docker build -t ${BUILD_ORGANIZATION}/${BUILD_REPOSITORY}:latest .
##
##  docker run \
##    --rm \
##    --volume=$(pwd):/data$( pwd) \
##    --workdir=/data$(pwd) \
##    --env=NODE_ENV=development \
##    --env=GIT_BRANCH=$(git branch | sed -n '/\* /s///p') \
##    node npm install
##
#################################################################

BUILD_ORGANIZATION	          ?=hipstack
BUILD_REPOSITORY		          ?=hipstack
BUILD_VERSION				          ?=$(shell hipstack -V)
BUILD_BRANCH		              ?=$(shell git branch | sed -n '/\* /s///p')
CONTAINER_NAME			          ?=hipstack.test
CONTAINER_HOSTNAME	          ?=hipstack.test

default: dockerImage

install:
	@echo "Installing ${BUILD_ORGANIZATION}/${BUILD_REPOSITORY}:${BUILD_VERSION}."
	@npm install

dockerImage:
	@echo "Building ${BUILD_ORGANIZATION}/${BUILD_REPOSITORY}:${BUILD_VERSION}."
	@sudo docker build -t $(BUILD_ORGANIZATION)/$(BUILD_REPOSITORY):latest .

restart:
	@sudo docker restart ${CONTAINER_NAME}

stop:
	@sudo docker stop ${CONTAINER_NAME}

start:
	@sudo docker rm -f ${CONTAINER_NAME}
	run

run:
	@echo "Running ${CONTAINER_NAME}."
	@echo "Checking and dumping previous runtime. $(shell sudo docker rm -f ${CONTAINER_NAME} 2>/dev/null; true)"
	@sudo docker run -itd \
		--name=${CONTAINER_NAME} \
		--hostname=${CONTAINER_HOSTNAME} \
		--env=NODE_ENV=${NODE_ENV} \
		--env=PHP_ENV=${PHP_ENV} \
		$(BUILD_ORGANIZATION)/$(BUILD_REPOSITORY):latest
	@sudo docker logs ${CONTAINER_NAME}

runTestContainer:
	@echo "Running test container."
	@echo "Checking and dumping previous runtime. $(shell sudo docker rm -f ${CONTAINER_NAME} 2>/dev/null; true)"
	@sudo docker run -itd \
		--name=${CONTAINER_NAME} \
		--hostname=${CONTAINER_HOSTNAME} \
		--publish=80 \
		--env=NODE_ENV=${NODE_ENV} \
		--env=PHP_ENV=${PHP_ENV} \
		--volume=/home/ubuntu/docker-hipstack/test:/var/www/test \
		$(BUILD_ORGANIZATION)/$(BUILD_REPOSITORY):latest /bin/bash
	@echo "Running on $(shell sudo docker port ${CONTAINER_NAME} 80)."

dockerRelease:
	@echo "Releasing ${BUILD_ORGANIZATION}/${BUILD_REPOSITORY}:${BUILD_VERSION}."
	sudo docker tag $(BUILD_ORGANIZATION)/$(BUILD_REPOSITORY):latest $(BUILD_ORGANIZATION)/$(BUILD_REPOSITORY):$(BUILD_VERSION)
	sudo docker push $(BUILD_ORGANIZATION)/$(BUILD_REPOSITORY):$(BUILD_VERSION)
	#sudo docker rmi $(BUILD_ORGANIZATION)/$(BUILD_REPOSITORY):$(BUILD_VERSION)
