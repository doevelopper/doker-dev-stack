.DEFAULT_GOAL := help
OUTPUT = $(shell pwd)/output
USER = $(shell id -u):$(shell id -g)
REGISTRY_USER=doevelopper
NS ?= doevelopper
DOCKERFILES=$(shell find * -type f -name Dockerfile)
NAMES=$(subst /,\:,$(subst /Dockerfile,,$(DOCKERFILES)))
REGISTRY?=r.docker.io
IMAGES=$(addprefix $(REGISTRY)/,$(NAMES))
DOCKER_IMAGE = doevelopper/developmentplatform
MAKEFLAGS += -rR

#.PHONY: all clean push pull run exec check checkrebuild $(NAMES) $(IMAGES)

.PHONY: build build-arm push push-arm shell shell-arm run run-arm start start-arm stop stop-arm rm rm-arm release release-arm

all: $(NAMES)

.PHONY: docker
docker:  ## Build the Docker image
	docker build -q -t $(DOCKER_IMAGE) -f docker/Dockerfile .

.PHONY: help
help:  ## This help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

	@echo "  A smart Makefile for your dockerfiles"
	@echo ""
	@echo "  Read all Dockerfile within the current directory and generate dependendies automatically."
	@echo ""
	@echo "  make all               build all images"
	@echo "  make push all          build and push all images"
	@echo "  make exec $(IMAGES)    build and start interactive shell in $(IMAGES)  image (for debugging)"
	@echo "  make push $(IMAGES)    build and push $(IMAGES) image"
	@echo "  make run $(IMAGES)     build and run $(IMAGES) image (for testing)"
	@echo "  make exec $(IMAGES)    build and start interactive shell in $(IMAGES) image (for debugging)"
	@echo '  build/<image dirname>  builds the latest image and all prerequisite images'
	@echo '  push/<image dirname>   pushes the latest image to $(REGISTRY_URL)'
	@echo "  make checkrebuild all  build and check if image has update availables (using apk or apt-get)"
	@echo "                        and rebuild with --no-cache is image has updates"
	@echo ""
	@echo "You can chain actions, typically in CI environment you want make checkrebuild push all"
	@echo "which rebuild and push only images having updates availables."

build: Dockerfile
	docker build -t $(NS)/$(IMAGE_NAME):$(VERSION) -f Dockerfile .

build-arm: Dockerfile.arm
	docker build -t $(NS)/rpi-$(IMAGE_NAME):$(VERSION) -f Dockerfile.arm .

push:
	docker push $(NS)/$(IMAGE_NAME):$(VERSION)

push-arm:
	docker push $(NS)/rpi-$(IMAGE_NAME):$(VERSION)

release: build
	make push -e VERSION=$(VERSION)

release-arm: build-arm
	make push-arm -e VERSION=$(VERSION)

default: help
