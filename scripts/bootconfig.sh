#!/bin/sh

if [ -n "${KUBERNETES_NODE_IP}" ]; then
  printf "\nclient_advertise = \"%s\"\n\n" ${KUBERNETES_NODE_IP}  > /etc/nats-config/advertise/client_advertise.conf
  printf "\nadvertise = \"%s\"\n\n" ${KUBERNETES_NODE_IP}  > /etc/nats-config/advertise/gateway_advertise.conf
fi