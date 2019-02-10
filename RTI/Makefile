#
#  RTI Makefile
#
###############################################################################
#                                                                             #
# Copyright (c) 2014 - 2019                                                   #
# Adrien H .L . All rights reserved.                                          #
#                                                                             #
# Permission to use, copy, modify, and distribute this software and its       #
# documentation for any purpose, without fee, and without written agreement   #
# is hereby granted, provided that the above copyright notice and the         #
# following two paragraphs appear in all copies of this software.             #
#                                                                             #
# IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR   #
# DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT #
# OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY   #
# OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.           #
#                                                                             #
# THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,         #
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY    #
# AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS   #
# ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO  #
# PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.      #
#                                                                             #
###############################################################################
# courtesy to https://github.com/Casecommons/intake_accelerator/blob/master/Makefile

.DEFAULT_GOAL := help

PROJECT_VERSION     =\"$(shell git describe)\"
GITHUB_USER         := doevelopper
DOCKER_REGISTRY     ?= docker.io
DOCKER_SHELL        := /bin/sh
BUILDER_TAG         := build-id-$(SHORT_SHA1)
RUNTIME_TAG         := dev-id-$(SHORT_SHA1)
DEV_IMAGE           ?= $(DOCKER_REGISTRY)/$(IMAGE_PREFIX)/$(shell basename $(CURDIR))-dev
PROD_IMAGE          ?= $(DOCKER_REGISTRY)/$(IMAGE_PREFIX)/$(shell basename $(CURDIR))
                      # FQIN - fully qualified image name
                      # Builder - Contains all the build artifacts and depedencies
                      # Runtime - Contains only the minimum necessary artifacts to run the microservice
BUILDER_FQIN        := $(DOCKER_REGISTRY)/$(IMAGE_PREFIX):$(BUILDER_TAG)
RUNTIME_FQIN        := $(DOCKER_REGISTRY)/$(IMAGE_PREFIX)/$(IMAGE_NAME):$(RUNTIME_TAG)
DEV_ENV_WORK_DIR    := /home/$(USER)/workspace
DEV_ENV_OPTS        := --rm -v ${CURDIR}:${DEV_ENV_WORK_DIR} -w ${DEV_ENV_WORK_DIR}
DEV_ENV_CMD         := docker run ${DEV_ENV_OPTS} ${DEV_ENV_IMAGE}
DEV_ENV_CMD_INT     := docker run -it ${DEV_ENV_OPTS} ${RUNTIME_FQIN}
DOCKER              = docker
DOCKERFILE          ?= Dockerfile
DOCKER_LABEL        := \
                      	--label org.label-schema.authors="Adrien H." \
                      	--label org.label-schema.documentation="Adrien H." \
                      	--label org.label-schema.description="Docker image for build Real Time Innovation`s Data Distribution Services" \
                      	--label org.label-schema.build-date=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
                      	--label org.label-schema.name=$(OPSYS)_$(SVCNAME) \
                      	--label org.label-schema.schema-version="$(VERSION)" \
                      	--label org.label-schema.url="https://scm.host.com/$(GITHUB_USER)/$(OPSYS)_$(SVCNAME)" \
                      	--label org.label-schema.usage="https://scm.host.com/$(GITHUB_USER)/$(OPSYS)_$(SVCNAME)" \
                      	--label org.label-schema.vcs-ref="$(SHORT_SHA1)" \
                      	--label org.label-schema.vcs-url="https://scm.host.com/$(GITHUB_USER)/$(OPSYS)_$(SVCNAME)" \
                      	--label org.label-schema.vendor= "A.H.L Systems." \
                      	--label org.label-schema.homepage= "www.tbd.acme" \
                      	--label org.label-schema.howtouseit= "docker run --rm -ti -v \"$PWD:/home/$(USER)/rti-workspace\" $(BUILDER_FQIN)" \
                      	--label org.label-schema.version=$(PROJECT_VERSION)

.PHONY: check-docker
check-docker:
	@if [ -z $$(which docker) ]; then \
	 echo "Missing docker client which is required for development"; \
	exit 22222; \
	fi

# Allow developers to step into the containerized development environment

# Containerized build of the binary
.PHONY: build-with-container
build-with-container: check-docker
	

.PHONY: help
help:  ## Disply this help and exit.
	@echo '-----------------------------------------------  $(GIT_REPOS_URL)'
	@echo
	@echo "Please use \`make <target>' where <target> is one of:"
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


