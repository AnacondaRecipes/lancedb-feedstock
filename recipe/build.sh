#!/bin/bash

set -euxo pipefail

export OPENSSL_DIR=$PREFIX

# error "The CPU Jitter random number generator must not be compiled with optimizations..." — it must see -O0 as the effective optimization.
# Strip the conda injected -O2 flags
for v in CFLAGS CXXFLAGS $(printenv | grep -E '^(CFLAGS|CXXFLAGS)_' | cut -d= -f1); do
  export "$v=${!v//-O2/}"
done

pushd python

cargo-bundle-licenses \
    --format yaml \
    --output ${SRC_DIR}/THIRDPARTY.yml

${PYTHON} -m pip install . -vv --no-deps --no-build-isolation
