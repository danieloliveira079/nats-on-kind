.PHONY: build load install destroy

REPO ?= danieloliv
IMAGE ?= nats-on-kind-setup
TAG ?= $(shell git rev-parse --short HEAD)
CLUSTER_NAME ?= nats-cluster

default: install

build:
		docker build -t $(REPO)/$(IMAGE):$(TAG) .

load:
		kind load docker-image $(REPO)/$(IMAGE):$(TAG) --name $(CLUSTER_NAME)

install: build load
		./setup.sh

destroy:
		./destroy.sh

push:
		docker push $(REPO)/$(IMAGE):$(TAG)

docker: build push
		