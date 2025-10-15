FROM docker:28-dind

# Install system dependencies
RUN apk add --no-cache \
      python3 py3-pip \
      openssh-client \
      git \
      curl \
      bash

# Install Ansible and Jinja2 via pip
RUN pip install --no-cache-dir --break-system-packages ansible jinja2

# Verify installations
RUN ansible --version && python3 --version && pip --version

ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD []