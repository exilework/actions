FROM --platform=linux/arm64 ubuntu:24.04

ARG RUNNER_VERSION="2.335.1"
ARG DEBIAN_FRONTEND=noninteractive

RUN useradd -m -s /bin/bash runner

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git jq unzip tar ca-certificates sudo ssh iputils-ping \
    build-essential libssl-dev libffi-dev pkg-config \
    python3 python3-venv python3-dev python3-pip \
    docker.io postgresql-client redis-tools netcat-openbsd \
    libicu-dev libkrb5-3 zlib1g \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN usermod -aG docker runner \
    && echo "runner ALL=(root) NOPASSWD: /usr/bin/chmod" >> /etc/sudoers

WORKDIR /home/runner

RUN mkdir -p /home/runner/actions-runner && cd /home/runner/actions-runner \
    && curl -o actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz \
    && tar xzf actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz

RUN chown -R runner:runner /home/runner \
    && cd /home/runner/actions-runner \
    && ./bin/installdependencies.sh

COPY --chmod=+x start.sh /home/runner/start.sh
RUN chown runner:runner /home/runner/start.sh

USER runner

ENTRYPOINT ["/home/runner/start.sh"]
