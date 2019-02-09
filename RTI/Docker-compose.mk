# courtesy to https://github.com/Casecommons/intake_accelerator/blob/master/Makefile
#
#
#
PROJECT_VERSION     =\"$(shell git describe)\"
GITHUB_USER         := doevelopper
DOCKER_REGISTRY     ?= docker.io
DOCKER_SHELL        := /bin/sh
DOCKER              = docker
DOCKERFILE          ?= Dockerfile
DOCKER_LABEL        := \
                      	--label org.label-schema.build-date=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
                      	--label org.label-schema.name=$(OPSYS)_$(SVCNAME) \
                      	--label org.label-schema.schema-version="$(VERSION)" \
                      	--label org.label-schema.url="https://scm.host.com/$(GITHUB_USER)/$(OPSYS)_$(SVCNAME)" \
                      	--label org.label-schema.usage="https://scm.host.com/$(GITHUB_USER)/$(OPSYS)_$(SVCNAME)" \
                      	--label org.label-schema.vcs-ref="$(SHORT_SHA1)" \
                      	--label org.label-schema.vcs-url="https://scm.host.com/$(GITHUB_USER)/$(OPSYS)_$(SVCNAME)" \
                      	--label org.label-schema.vendor= "A.H.L Systems." \
                      	--label org.label-schema.version=$(DOCKER_USER)

REL_PROJECT := $(PROJECT_NAME)$(BUILD_ID)
TEST_PROJECT := $(PROJECT_NAME)_test
BUILD_TAG_EXPRESSION ?= date -u +%m%d%Y%H%M%S
BUILD_EXPRESSION := $(shell $(BUILD_TAG_EXPRESSION))
BUILD_TAG ?= $(BUILD_EXPRESSION)
# WARNING: Set DOCKER_REGISTRY_AUTH to empty for Docker Hub
# Set DOCKER_REGISTRY_AUTH to auth endpoint for private Docker registry
DOCKER_REGISTRY_AUTH ?=
VERSION ?= $(shell git describe --tags --always --dirty)
USEr_NAME ?= doevelopper
IMAGE_NAME ?= rti-dds-dev
RELEASE_IMAGE_NAME ?= rti-dds-image-deploy

.PHONY: test build release clean tag buildtag login logout publish

test:
	${INFO} "Pulling latest images..."
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) pull
	${INFO} "Building images..."
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) build --pull cache
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) build --pull rspec_test
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) build --pull lint
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) build --pull javascript_test
	${INFO} "Building cache..."
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) up cache
	${INFO} "Running tests..."
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) up rspec_test
	@ docker cp $$(docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) ps -q rspec_test):/reports/. reports
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) up lint
	@ docker cp $$(docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) ps -q lint):/reports/. reports
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) up javascript_test
	@ docker cp $$(docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) ps -q javascript_test):/reports/. reports
	${CHECK} $(TEST_PROJECT) $(TEST_COMPOSE_FILE) rspec_test
	${CHECK} $(TEST_PROJECT) $(TEST_COMPOSE_FILE) lint
	${CHECK} $(TEST_PROJECT) $(TEST_COMPOSE_FILE) javascript_test
	${INFO} "Testing complete"

build:
	${INFO} "Creating builder image..."
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) build builder
	${INFO} "Building application artifacts..."
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) up builder
	${CHECK} $(TEST_PROJECT) $(TEST_COMPOSE_FILE) builder
	${INFO} "Deleting old application artifacts..."
	@ rm -rf release
	${INFO} "Copying application artifacts..."
	@ docker cp $$(docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) ps -q builder):/ca_intake_build/. release
	${INFO} "Build complete"

release:
	${INFO} "Pulling latest images..."
	@ docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) pull
	${INFO} "Building images..."
	@ docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) build app
	@ docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) build --pull nginx
	@ docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) up -d nginx
	${INFO} "Release image build complete"

clean:
	${INFO} "Destroying development environment..."
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) down --volumes
	${INFO} "Destroying release environment..."
	@ docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) down --volumes
	${INFO} "Removing dangling images..."
	@ docker images -q -f dangling=true -f label=application=$(REPO_NAME) | xargs -I ARGS docker rmi -f ARGS
	${INFO} "Clean complete"

tag:
	${INFO} "Tagging release image with tags $(TAG_ARGS)..."
	@ $(foreach tag,$(TAG_ARGS), docker tag $(IMAGE_ID) $(DOCKER_REGISTRY)/$(ORG_NAME)/$(REPO_NAME):$(tag);)
	${INFO} "Tagging complete"

buildtag:
	${INFO} "Tagging release image with suffix $(BUILD_TAG) and build tags $(BUILDTAG_ARGS)..."
	@ $(foreach tag,$(BUILDTAG_ARGS), docker tag $(IMAGE_ID) $(DOCKER_REGISTRY)/$(ORG_NAME)/$(REPO_NAME):$(tag).$(BUILD_TAG);)
	${INFO} "Tagging complete"


login:
	${INFO} "Logging in to Docker registry $$DOCKER_REGISTRY..."
	@ docker login -u $$DOCKER_USER -p $$DOCKER_PASSWORD $(DOCKER_REGISTRY_AUTH)
	${INFO} "Logged in to Docker registry $$DOCKER_REGISTRY"

logout:
	${INFO} "Logging out of Docker registry $$DOCKER_REGISTRY..."
	@ docker logout
	${INFO} "Logged out of Docker registry $$DOCKER_REGISTRY"

publish:
	${INFO} "Publishing release image $(IMAGE_ID) to $(DOCKER_REGISTRY)/$(ORG_NAME)/$(REPO_NAME)..."
	@ $(foreach tag,$(shell echo $(REPO_EXPR)), docker push $(tag);)
	${INFO} "Publish complete"

generate:
	@echo "Generation make build system..."
	cmake -DNDDSHOME=/opt/rti_connext_dds-5.3.1 -DCONNEXTDDS_ARCH=x64Linux3gcc5.4.0 -DRTICODEGEN_DIR=$NDDSHOME/bin ..

docker container run \
       --rm \
       -d \
       -v $Open3D_HOST:$Open3D_DOCK \
       -p 5920:5900 \
       -h $NAME \
       --name $NAME \
       $NAME

docker container exec -it -w $Open3D_DOCK $NAME bash -c 'mkdir -p build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=~/open3d_install && make -j && make install && bash'

.PHONY: generate
generate:
	@echo "Generation make build system..."
	cmake -E make_directory build
	cmake -E chdir build cmake -DNDDSHOME=/opt/rti_connext_dds-5.3.1 -DCONNEXTDDS_ARCH=x64Linux3gcc5.4.0 -DRTICODEGEN_DIR=$NDDSHOME/bin -DCMAKE_BUILD_TYPE=DEBUG ..
#	cmake -DNDDSHOME=/opt/rti_connext_dds-5.3.1 -DCONNEXTDDS_ARCH=x64Linux3gcc5.4.0 -DRTICODEGEN_DIR=$NDDSHOME/bin -DCMAKE_BUILD_TYPE=DEBUG ..
	cmake -G"Unix Makefiles" -Bbuild -DNDDSHOME=/opt/rti_connext_dds-5.3.1 -DCONNEXTDDS_ARCH=x64Linux3gcc5.4.0 -DRTICODEGEN_DIR=$NDDSHOME/bin -DCMAKE_BUILD_TYPE=DEBUG  -H.
.PHONY: build
build:
	cmake --build build --target all --config Debug -- -j8

all:
	@echo "Silent goal use make generate instead"


YELLOW := "\e[1;33m"
NC := "\e[0m"

# Shell Functions
INFO := @bash -c '\
  printf $(YELLOW); \
  echo "=> $$1"; \
printf $(NC)' SOME_VALUE

