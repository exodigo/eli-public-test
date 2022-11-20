#!/bin/sh

die() {
	local m="$1"
	echo "FATAL: ${m}" >&2
	exit 1
}

OCI_ENGINE="${OCI_ENGINE:-podman}"
OCI_LOCAL_TAG="${OCI_LOCAL_TAG:-"localhost/container:tmp"}"

eval "set -- "$(set | sed -n -e 's/^OCI_ARG_[^=]*=// p')""
exec ${OCI_ENGINE} image build \
  --secret id=pip_secret,src="${HOME}/.config/pip/pip.conf" \
  --build-arg pip_creds=".config/pip/pip.conf" \
  --secret id=twine_secret,src="${HOME}/.pypirc" \
  --build-arg twine_creds=".pypirc" \
  --secret id=npm_secret,src="${HOME}/.npmrc" \
  --build-arg npm_creds=".npmrc" \
  --build-arg AWS_ECR_NAME="${AWS_ECR_NAME}" \
  "${@}" \
  --file Containerfile \
  --tag ${OCI_LOCAL_TAG} \
  . \
	|| die "Image build failed"
