FROM docker:28-dind

# Install system dependencies
RUN apk add --no-cache \
      python3 py3-pip \
      openssh-client \
      git \
      curl \
      bash

# Install Ansible and Jinja2 via pip
RUN pip install --no-cache-dir --break-system-packages ansible jinja2 && \
    ansible --version && python3 --version && pip --version

# Install vault
ARG VAULT_VERSION=1.20.4

RUN apk add --no-cache shadow && \
    addgroup app && adduser -D -h /digital-collections -s /bin/sh -G app app

RUN apk add --update --virtual .deps --no-cache gnupg && \
    cd /tmp && \
    wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS && \
    wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig && \
    wget -qO- https://www.hashicorp.com/.well-known/pgp-key.txt | gpg --import && \
    gpg --verify vault_${VAULT_VERSION}_SHA256SUMS.sig vault_${VAULT_VERSION}_SHA256SUMS && \
    grep vault_${VAULT_VERSION}_linux_amd64.zip vault_${VAULT_VERSION}_SHA256SUMS | sha256sum -c && \
    unzip /tmp/vault_${VAULT_VERSION}_linux_amd64.zip -d /tmp && \
    mv /tmp/vault /usr/local/bin/vault && \
    rm -f /tmp/vault_${VAULT_VERSION}_linux_amd64.zip vault_${VAULT_VERSION}_SHA256SUMS ${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig && \
    apk del .deps && \
    vault --version

COPY dockerd-entrypoint.sh /usr/local/bin/dockerd-entrypoint.sh
RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh"]