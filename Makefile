
PROJECT := p4

SELENIUM_REPO 	?= https://github.com/greenpeace/planet4-selenium-tests
SELENIUM_BRANCH ?= master

EXEC ?= vendor/bin/phpunit -c tests

BUILD_NAMESPACE 	?= gcr.io
GOOGLE_PROJECT_ID ?= planet-4-151612
CONTAINER_NAME 		?= selenium

ALLOWED_CHARACTERS := a-zA-Z0-9._-

ifeq ($(CIRCLECI),true)
# Configure build variables based on CircleCI environment vars
BUILD_NUM = build-$(CIRCLE_BUILD_NUM)
BRANCH_NAME ?= $(shell sed 's/[^$(ALLOWED_CHARACTERS)]/-/g' <<< "$(CIRCLE_BRANCH)")
BUILD_TAG 	?= $(shell sed 's/[^$(ALLOWED_CHARACTERS)]/-/g' <<< "$(CIRCLE_TAG)")
PUSH := true
else
# Not in CircleCI environment, try to set sane defaults
BUILD_NUM = build-local
BRANCH_NAME ?= $(shell git rev-parse --abbrev-ref HEAD | sed 's/[^$(ALLOWED_CHARACTERS)]/-/g')
BUILD_TAG 	?= $(shell git tag -l --points-at HEAD | tail -n1 | sed 's/[^$(ALLOWED_CHARACTERS)]/-/g')
PUSH := false
endif

# If BUILD_TAG is blank there's no tag on this commit
ifeq ($(strip $(BUILD_TAG)),)
# Default to branch name
BUILD_TAG := $(BRANCH_NAME)
else
# Consider this the new :latest image
# FIXME: implement build tests before tagging with :latest
ifeq ($(PUSH),true)
PUSH_LATEST := true
endif
endif

SHELL := /bin/bash
.DEFAULT_GOAL := all

all: src build run

clean:
	rm -fr src
	docker-compose -p $(PROJECT) -T -f docker-compose.yml down -v --remove-orphans
	docker-compose -p tests -f tests/docker-compose.yml down -v --remove-orphans

.PHONY: pull
pull:
src:
	git clone $(SELENIUM_REPO) -b $(SELENIUM_BRANCH) src
	pushd src && composer -v --profile install && popd

build:
	docker build \
		--tag=$(BUILD_NAMESPACE)/$(GOOGLE_PROJECT_ID)/$(CONTAINER_NAME):$(BUILD_NUM) \
		.

test:
	$(MAKE) -C tests all

tag:
	docker tag $(BUILD_NAMESPACE)/$(GOOGLE_PROJECT_ID)/$(CONTAINER_NAME):$(BUILD_NUM) $(BUILD_NAMESPACE)/$(GOOGLE_PROJECT_ID)/$(CONTAINER_NAME):$(BUILD_TAG)

push: push-tag push-latest

push-tag:
	@if [ "$(PUSH)" = "true" ]; then { \
		docker push $(BUILD_NAMESPACE)/$(GOOGLE_PROJECT_ID)/$(CONTAINER_NAME):$(BUILD_TAG); \
		docker push $(BUILD_NAMESPACE)/$(GOOGLE_PROJECT_ID)/$(CONTAINER_NAME):$(BUILD_NUM); \
	} else { echo "Not in CI.. not pushing images"; } fi

push-latest:
	@if [ "$(PUSH_LATEST)" = "true" ]; then { \
		docker tag $(BUILD_NAMESPACE)/$(GOOGLE_PROJECT_ID)/$(CONTAINER_NAME):$(BUILD_NUM) $(BUILD_NAMESPACE)/$(GOOGLE_PROJECT_ID)/$(CONTAINER_NAME):latest; \
		docker push $(BUILD_NAMESPACE)/$(GOOGLE_PROJECT_ID)/$(CONTAINER_NAME):latest; \
	}	else { echo "Not tagged.. skipping latest"; } fi
