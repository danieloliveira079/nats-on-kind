#!/bin/sh

set -eu

NATS_K8S_VERSION=${PWD}
NATS_BOOTSTRAP_YML=${DEFAULT_NATS_BOOTSTRAP_YML:=$NATS_K8S_VERSION/bootstrap-policy.yml}
NATS_SETUP_IMAGE=${DEFAULT_NATS_SETUP_IMAGE:=danieloliv/nats-on-kind-setup:v0.1}

# Apply policy required to be able to create the resources.
kubectl apply -f "$NATS_BOOTSTRAP_YML"

# Run nats-setup container containing the latest set of manifests.
kubectl run nats-setup --generator=run-pod/v1 --image-pull-policy=IfNotPresent --serviceaccount=nats-setup --image=$NATS_SETUP_IMAGE --restart=Never

# Wait for the setup container to start or bail.
kubectl wait --for=condition=Ready pod/nats-setup --timeout=30s

# Pass the custom parameters to the nats-setup container image.
kubectl exec nats-setup -- nats-setup.sh "$@"

# Get a local copy of the nsc directory with the accounts.
kubectl cp nats-setup:/nsc nsc

# Remove the required policy for setup purposes.
kubectl delete -f "$NATS_BOOTSTRAP_YML"

# Remove the setup pod.
kubectl delete pod nats-setup --grace-period=0 --force
