GOMOD?=on

IMAGE_SETUP=-v $(shell pwd)/.cpkg:/root/go/pkg -v $(shell pwd):/src -e BUILD_ENV="$(shell env | grep 'USER\|TRAVIS\|ATSU\|GITHUB')"
IMAGE=$(IMAGE_SETUP) ghcr.io/atsu/centosgobuilder:latest

all: build

build:
	docker run --rm $(IMAGE) sqrl make

cbuild: ctest
	GO111MODULE=$(GOMOD) go build ./...

ctest:
	GO111MODULE=$(GOMOD) go test ./...

tag:
	git tag $(shell docker run --rm $(IMAGE) sqrl info -v version)

clean:
	rm -rf .cpkg traceout

.PHONY: all build cbuild ctest tag clean
