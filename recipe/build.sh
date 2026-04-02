#!/bin/bash

set -euxo pipefail

export OPENSSL_DIR=$PREFIX

pushd python

cargo-bundle-licenses \
    --format yaml \
    --output ${SRC_DIR}/THIRDPARTY.yml

${PYTHON} -m pip install . -vv --no-deps --no-build-isolation
