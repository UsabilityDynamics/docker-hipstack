##
#
# $(git branch | sed -n '/\* /s///p')
#
#
# ### Running
# * We volume-mount that docker unix sock file using the DOCKER_SOCK_PATH environment variable, which we set to /var/run/docker.sock by default.
#
##

BUILD_ORGANIZATION	          ?=usabilitydynamics
BUILD_REPOSITORY		          ?=hipstack
BUILD_VERSION				          ?=0.1.0
BUILD_BRANCH		              ?=$(shell git branch | sed -n '/\* /s///p')

CONTAINER_NAME			          ?=hipstack
CONTAINER_HOSTNAME	          ?=hipstack.internal
CONTAINER_ENTRYPOINT	        ?=/usr/local/bin/hipstack.entrypoint


default: image

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
	@echo "Testing Docker Proxy <${BUILD_BRANCH}> branch."
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
		--env=HOME=/home/hipstack \
		--env=NODE_ENV=${NODE_ENV} \
		--env=PHP_ENV=${PHP_ENV} \
		$(BUILD_ORGANIZATION)/$(BUILD_REPOSITORY):$(BUILD_VERSION)
	@docker logs ${CONTAINER_NAME}

release:
	docker push $(BUILD_ORGANIZATION)/$(BUILD_REPOSITORY):$(BUILD_VERSION)
