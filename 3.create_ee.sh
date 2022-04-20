#!/usr/bin/env bash

if [ ${#} -ne 3 ]; then
  echo "Usage: ${0} <Automation Hub> <Username> <Target-Name[:Tag]>" >&2
  exit 1
fi

AAH=${1}
USR=${2}
IMG=${3}

read -s -p "Type the ${USR}'s password to push the image to ${AAH}: " PWD

# Build the container
ansible-builder build --tag ${AAH}/${IMG} || exit 2

# Publish the container
podman login "${AAH}" -u "${USR}" -p "${PWD}" --tls-verify=false || exit 3
podman push "${AAH}/${IMG}" --tls-verify=false
