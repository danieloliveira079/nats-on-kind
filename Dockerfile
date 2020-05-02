FROM synadia/nats-box:latest

WORKDIR /setup

ENV KUBECTL_VERSION 1.16.2
ENV DEFAULT_NSC_DIR /nsc

RUN set -eux; \
	wget -O /kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl; \
	chmod +x /kubectl && mv /kubectl /usr/local/bin/kubectl

COPY nats-server /setup/nats-server
COPY nats-streaming-server /setup/nats-streaming-server
COPY tools /setup/tools

COPY nats-setup.sh nsc-setup.sh bootconfig.sh /usr/local/bin/

ENTRYPOINT []
CMD ["/bin/sleep", "300"]