#!/bin/bash

: "${REPO:?REPO env var required}"
: "${REG_TOKEN:?REG_TOKEN env var required}"
: "${NAME:?NAME env var required}"

if [ -S /var/run/docker.sock ]; then
    sudo chmod 666 /var/run/docker.sock
fi

# erlef/setup-beam reads ImageOS to pick the right precompiled OTP/Elixir build
. /etc/os-release
export ImageOS="ubuntu${VERSION_ID%%.*}"

cd /home/docker/actions-runner || exit

RUNNER_NAME="${NAME}-$(hostname)"

CONFIG_ARGS=(--url "https://github.com/${REPO}" --token "${REG_TOKEN}" --name "${RUNNER_NAME}")

[ -n "${LABELS}" ]       && CONFIG_ARGS+=(--labels "${LABELS}")
[ -n "${RUNNER_GROUP}" ] && CONFIG_ARGS+=(--runnergroup "${RUNNER_GROUP}")
[ -n "${WORK_DIR}" ]     && CONFIG_ARGS+=(--work "${WORK_DIR}")
[ "${EPHEMERAL}" = "true" ]            && CONFIG_ARGS+=(--ephemeral)
[ "${DISABLE_AUTO_UPDATE}" = "true" ]  && CONFIG_ARGS+=(--disableupdate)

./config.sh "${CONFIG_ARGS[@]}"

cleanup() {
  echo "Removing runner..."
  ./config.sh remove --unattended --token "${REG_TOKEN}"
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
