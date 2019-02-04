GOMOD?=on

IMAGE_SETUP=-v $(shell pwd)/.cpkg:/root/go/pkg -v $(shell pwd):/src -e BUILD_ENV="$(shell env | grep 'USER\|TRAVIS\|ATSU\|GITHUB')"
IMAGE=$(IMAGE_SETUP) atsuio/centosgobuilder:latest

all: build

build: traceout
	docker run --rm $(IMAGE) sqrl make -a

cbuild: ctest
	GO111MODULE=$(GOMOD) go build ./...

ctest:
	GO111MODULE=$(GOMOD) go test ./...

tag:
	git tag $(shell docker run --rm $(IMAGE) sqrl info -v version)

clean:
	rm -rf .cpkg traceout

.PHONY: all cbuild ctest tag clean
