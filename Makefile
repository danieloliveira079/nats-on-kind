.PHONY: build load install destroy

REPO ?= danieloliv079
IMAGE ?= nats-on-kind-setup
TAG ?= v0.1
CLUSTER_NAME ?= kind

default: install

build:
		docker build -t $(REPO)/$(IMAGE):$(TAG) .

load:
		kind load docker-image $(REPO)/$(IMAGE):$(TAG) --name $(CLUSTER_NAME)

install: build load
		./setup.sh

destroy:
		./destroy.sh