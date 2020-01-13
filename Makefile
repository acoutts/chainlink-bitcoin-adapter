.DEFAULT_GOAL := build
.PHONY: build install docker dockerpush

REPO=acoutts/chainlink-adapter-btcd
LDFLAGS=-ldflags "-X $(REPO)/store.Sha=`git rev-parse HEAD`"

build:
	@go build $(LDFLAGS) -o chainlink-adapter-btcd

install:
	@go install $(LDFLAGS)

docker:
	@docker build . -t $(REPO)

dockerpush:
	@docker push $(REPO)