#!/bin/sh

OCI_ENGINE="${OCI_ENGINE:-podman}"
OCI_CONTAINER_FILE="${OCI_CONTAINER_FILE:-Containerfile}"

echo "aaaaaa"
echo "${OCI_ARG_LOCAL_TAG}"

eval "set -- "$(set | sed -n -e 's/^OCI_ARG_[^=]*=// p')""
exec ${OCI_ENGINE} image build \
  --secret id=pip_secret,src="${HOME}/.config/pip/pip.conf" \
  --build-arg pip_creds=".config/pip/pip.conf" \
  --secret id=twine_secret,src="${HOME}/.pypirc" \
  --build-arg twine_creds=".pypirc" \
  --secret id=npm_secret,src="${HOME}/.npmrc" \
  --build-arg npm_creds=".npmrc" \
  --build-arg REGISTRY_NAME="${AWS_ECR_NAME}" \
  "${@}" \
  --file ${OCI_CONTAINER_FILE} \
  .
