#!/usr/bin/env bash

if [ ${#} -ne 3 ]; then
  echo "Usage: ${0} <Automation Hub> <Username> <Target-Name[:Tag]>" >&2
  exit 1
fi

AAH=${1}
USR=${2}
IMG=${3}
IMG_L=${IMG@L}

read -s -p "Type the ${USR}'s password to push the image to ${AAH}: " PWD

# Build the container
ansible-builder build --build-arg venv_name="${IMG%:*}" --tag ${AAH}/${IMG_L%:*}_legacy:${IMG_L#*:} || exit 2

# Publish the container
podman login "${AAH}" -u "${USR}" -p "${PWD}" --tls-verify=false || exit 3
podman push "${AAH}/${IMG_L%:*}_legacy:${IMG_L#*:}" --tls-verify=false
