FROM ubuntu:24.04

ARG RUNNER_VERSION="2.335.1"
ARG DEBIAN_FRONTEND=noninteractive

# Update and upgrade the system
RUN apt update -y && apt upgrade -y && rm -rf /var/lib/apt/lists/*

RUN useradd -m docker

RUN apt-get update && apt install -y --no-install-recommends \
    curl wget git jq unzip tar ca-certificates sudo ssh \
    build-essential libssl-dev libffi-dev pkg-config \
    python3 python3-venv python3-dev python3-pip \
    docker.io postgresql-client redis-tools netcat-openbsd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN usermod -aG docker docker \
    && echo "docker ALL=(root) NOPASSWD: /usr/bin/chmod" >> /etc/sudoers

RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R docker /home/docker && /home/docker/actions-runner/bin/installdependencies.sh

COPY --chmod=+x start.sh /start.sh

USER docker

# Define the entrypoint
ENTRYPOINT ["/start.sh"]