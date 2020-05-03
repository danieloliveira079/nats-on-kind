# Nats-on-Kind

Running [NATS](https://nats.io/) on a Kubernetes cluster that has been provisioned using [Kind](https://kind.sigs.k8s.io/).

> NATS.io is a simple, secure and high performance open source messaging system for cloud native applications, IoT messaging, and microservices architectures. https://nats.io

This work was heavily inspired by the original tutorial from https://docs.nats.io/nats-on-kubernetes/nats-kubernetes.

***All the manifests, scripts and original content can be found on https://github.com/nats-io/k8s.***

The former instructions and configs were meant to be used on a cluster that was provisioned using a cloud provider. This project here explores the possibility of doing the same but using a local Kubernetes cluster, more specifically, one provisioned using Kind.

Before running this project, you will need a local Kubernetes cluster running. Although the solution here may work with any local cluster, it has been only tested using a cluster provisioned using Kind.

Practically speaking, the only requirement is a running cluster and a valid `$KUBECONFIG`. Just be aware of how you will be interacting with the NATS services using either `port-forward` or `node port`, depending on your underlying infrastructure.

### How to create a cluster using Kind?

You can find detailed instructions on how to install Kind on https://kind.sigs.k8s.io/docs/user/quick-start/.

If Kind is already present on your system you can run the following command:

```bash
$ kind create cluster --name nats-cluster --kubeconfig ${PWD}/nats.config
```

Use the context from the generated `nats.config` file and check current-context:

```bash
$ export KUBECONFIG=${PWD}/nats.config
$ config current-context # output: kind-nats-cluster
```

If everything went well, you are all set to continue.

### How to deploy the NATS cluster using this project?

Assuming that you have access to a Kubernetes cluster you have to:

1. Build the docker image used by the setup process
2. Load it into the Kind cluster
3. Start the setup process

The `Makefile` part of this project provides some shortcuts.

```bash
# this command will execute all the 3 steps above
$ make install
```

After the install is completed it may take a couple of minutes until all the components are ready, especially the `nats-surveyor` pod. This pod will stay in a `CrashLoopback` state until it can successfully communicate with the `nats server`.

You can watch their statuses running:
```bash
$ watch kubectl get pods
```

Alternatively, you can execute each step individually. Feel free to explore the `Makefile`.

### How to clean up all the installed components?

```bash
$ make destroy
```

### Interacting with NATS

The output from the setup process will show you some possibilities of how to interact with the NATS server that has been deployed. Additionally, you can open the Grafana dashboard for checking metrics. If the setup completed successfully the output should be something similar to:

```
=== Getting started

You can now start receiving and sending messages using 
the nats-box instance deployed into your namespace:

  kubectl exec -it nats-box -- /bin/sh -l 

Using the test account user:
  
  nats-sub test &
  nats-pub test 'Hello World'
  
Or try using the system account user to inspect all events in the cluster:
  
  nats-sub -creds /var/run/nats/creds/sys/sys.creds '>'
  
To create a sample service and a requestor, tracking service latency:
  
  nats-rply test 'I can help!' &
  nats-sub latency.on.test &
  nats-req test 'help!'
  
The nats-box also includes nats-top which you can use to
inspect the flow of messages from one of the members
of the cluster (press 'q' to exit).

  nats-top

NATS Streaming with persistence is also available as part of your cluster.
It is installed under the STAN account so you can use the following credentials:
 
  stan-pub test 'Hello World'
  stan-sub test -all
 
You can also connect to your monitoring dashboard:
 
  kubectl port-forward deployments/nats-surveyor-grafana 3000:3000
 
Then open the following in your browser:
 
  http://127.0.0.1:3000/d/nats/nats-surveyor?refresh=5s&orgId=1
```

## Extras

### Build and Push the docker image

***Important***: The steps below are not require for the setup to work locally. The required image will be loaded into the Kind cluster from the local docker images. Check the content of the `Makefile` for a clear understanding.


You can build the docker image with a different tag and push it to your own repo by doing the following:

- Update the `.env` file adding the desired information
- Export the new values: `source .env`
- Build and push: `make docker`

