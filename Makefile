DOCKER_REGISTRY :=
APP_VERSION:=
PLATFORM :=

# This version-strategy uses git tags to set the version string
APP_VERSION := $(shell git describe --tags --always --dirty)
GIT_COMMIT := $(shell git log --pretty=format:'%h' -n 1)
GO_VERSION := 1.14
TIMESTAMP := $(shell date +%s)
TIMESTAMP_RFC3339 := $(shell date +%Y-%m-%dT%T%z)

DOCKER_TAG_PUSH ?= $(APP_VERSION)

help: ## Prints help for targets with comments
	@grep -E '^[a-zA-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Builds the container with the executable
	DOCKER_BUILDKIT=1 \
	docker build \
		--build-arg APP_NAME="acmesolver" \
		--build-arg GO_VERSION="$(GO_VERSION)" \
		--build-arg APP_VERSION="$(APP_VERSION)" \
		--build-arg GIT_COMMIT="$(GIT_COMMIT)" \
		--build-arg BUILD_DATE="$(TIMESTAMP_RFC3339)" \
		-t "acmesolve::$(DOCKER_TAG_PUSH)" \
		.
	DOCKER_BUILDKIT=1 \
	docker build \
		--build-arg APP_NAME="cainjector" \
		--build-arg GO_VERSION="$(GO_VERSION)" \
		--build-arg APP_VERSION="$(APP_VERSION)" \
		--build-arg GIT_COMMIT="$(GIT_COMMIT)" \
		--build-arg BUILD_DATE="$(TIMESTAMP_RFC3339)" \
		-t "cainjector:$(DOCKER_TAG_PUSH)" \
		.
	DOCKER_BUILDKIT=1 \
	docker build \
		--build-arg APP_NAME="controller" \
		--build-arg GO_VERSION="$(GO_VERSION)" \
		--build-arg APP_VERSION="$(APP_VERSION)" \
		--build-arg GIT_COMMIT="$(GIT_COMMIT)" \
		--build-arg BUILD_DATE="$(TIMESTAMP_RFC3339)" \
		-t "controller:$(DOCKER_TAG_PUSH)" \
		.
	DOCKER_BUILDKIT=1 \
	docker build \
		--build-arg APP_NAME="webhook" \
		--build-arg GO_VERSION="$(GO_VERSION)" \
		--build-arg APP_VERSION="$(APP_VERSION)" \
		--build-arg GIT_COMMIT="$(GIT_COMMIT)" \
		--build-arg BUILD_DATE="$(TIMESTAMP_RFC3339)" \
		-t "webhook:$(DOCKER_TAG_PUSH)" \
		.
	DOCKER_BUILDKIT=1 \
	docker build \
		--build-arg APP_NAME="ctl" \
		--build-arg GO_VERSION="$(GO_VERSION)" \
		--build-arg APP_VERSION="$(APP_VERSION)" \
		--build-arg GIT_COMMIT="$(GIT_COMMIT)" \
		--build-arg BUILD_DATE="$(TIMESTAMP_RFC3339)" \
		-t "ctl:$(DOCKER_TAG_PUSH)" \
		.
