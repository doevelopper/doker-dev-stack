# %W% %G% %U%
#
#  Root Makefile
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

.DEFAULT_GOAL := help

YELLOW            := "\e[1;33m"
NC                := "\e[0m"
RED               := "\e[91m"
BLUE              := "\e[36m"
ERR               := "\e[31;01m"
WARN              := "\e[33;01m"
OK                := "\e[32;01m"
INFO              := @bash -c ' printf $(YELLOW); echo "=> $$1"; printf $(NC)'

VERSION           := 0.1.0
MAJOR             := $(word 1, $(subst ., ,$(VERSION)))
MINOR             := $(word 2, $(subst ., ,$(VERSION)))
PATCH             := $(word 3, $(subst ., ,$(VERSION)))
STAGE             := $(word 4, $(subst ., ,$(VERSION)))

GID               := $(shell id -g)
UID               := $(shell id -u)
USER              := $(shell id -u -n)
USER_GRP_ID       ?= $(UID):$(GID)

DATE              := $(shell date -u "+%b-%d-%Y")
SHA1              := $(shell git rev-parse HEAD)
SHORT_SHA1        := $(shell git rev-parse --short=5 HEAD)
GIT_STATUS        := $(shell git status --porcelain)
GIT_BRANCH        ?= $(shell git rev-parse --abbrev-ref HEAD)
GIT_BRANCH        := $(shell git rev-parse --abbrev-ref HEAD)
GIT_BRANCH_STR    := $(shell git rev-parse --abbrev-ref HEAD | tr '/' '_')
GIT_REPOS_URL     := $(shell git config --get remote.origin.url)
GIT_COMMIT        = $(strip $(shell git rev-parse --short HEAD))
COVERITY_STREAM   := $(GIT_REPO)_$(GIT_BRANCH)


ENVDIR            := "./envs/"
LOGDIR            = "./logs/"
OUTPUT            = $(shell pwd)/output
REGISTRY_USER     = doevelopper

DOCKER_IMAGE      ?= doevelopper/developmentplatform

ifeq ($(GIT_BRANCH), master)
	DOCKER_TAG     = latest
else
	DOCKER_TAG     = $(GIT_BRANCH)
endif


TARGETS           ?= rtps/amd64 rtps/aarch64  vortex/amd64 vortex/aarch64 omg/amd64 omg/aarch64 rti/amd64 rti/aarch64

.PHONY: all $(TARGETS)

#all: $(TARGETS)
#	$(MAKE) -C $@


.PHONY: rti/amd64
rti/amd64:  ## Build RTI DDS docker images and deployment charts.
	${INFO} "Building RTI DDS Connext Docker Images and deployment charts"	

.PHONY: rti
rti: rti/amd64

.PHONY: rti/aarch64
rti/aarch64:  ## Build RTI DDS docker images for AARCH64 Architectures.
	${INFO} "Building RTI DDS Connext Docker Images for AMR64 Architectures"	

.PHONY: rti-arm
rti-arm: rti/aarch64

.PHONY: omg/amd64
omg/amd64:  ## Build Object Coputing Group DDS docker images and deployment charts.
	${INFO} "Building Object Coputing Group DDS Docker Images and deployment charts"	

.PHONY: omg
omg: omg/amd64

.PHONY: omg/aarch64
omg/aarch64:  ## Build Object Coputing Group DDS docker images for AARCH64 Architectures.
	${INFO} "Building Object Coputing Group Docker Images for AMR64 Architectures"	

.PHONY: omg-arm
omg-arm: omg/aarch64


.PHONY: vortex/amd64
vortex/amd64:  ## Build OpenSPlice DDS docker images and deployment charts.
	${INFO} "Building OpenSPlice DDS Docker Images and deployment charts"	

.PHONY: vortex
vortex: vortex/amd64

.PHONY: vortex/aarch64
vortex/aarch64:  ## Build OpenSPlice DDS docker images for AARCH64 Architectures.
	${INFO} "Building OpenSPlice DDS Connext Docker Images for AARCH64 Architectures"	

.PHONY: vortex-arm
vortex-qrm: vortex/aarch64


.PHONY: rtps/amd64
rtps/amd64:  ## Build eProsima DDS docker images and deployment charts.
	${INFO} "Building eProsima DDS Docker Images and deployment charts"	

.PHONY: rtps
rtps: rtps/amd64

.PHONY: rtps/aarch64
rtps/aarch64:  ## Build eProsima DDS docker images for AARCH64 Architectures.
	${INFO} "Building eProsima DDS Connext Docker Images for AARCH64 Architectures"	

.PHONY: rtps-arm
rtps-arm: rtps/aarch64

.PHONY: help
help:  ## Disply this help and exit.
	@echo '-----------------------------------------------  $(GIT_REPOS_URL)'
	@echo
	@echo "Please use \`make <target>' where <target> is one of:"
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
