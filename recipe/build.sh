#!/bin/bash

set -euxo pipefail

export OPENSSL_DIR=$PREFIX

# error "The CPU Jitter random number generator must not be compiled with optimizations..." — it must see -O0 as the effective optimization.
# Strip the conda injected -O2 flags
for v in CFLAGS CXXFLAGS $(printenv | grep -E '^(CFLAGS|CXXFLAGS)_' | cut -d= -f1); do
  export "$v=${!v//-O2/}"
done

# Limit parallel Rust codegen to avoid OOM on memory-constrained workers.
# lancedb pulls in ~300+ crates (datafusion, lance, opendal, aws-sdk-*);
# each codegen unit consumes significant RAM under full parallelism.
if [[ "${target_platform}" == "linux-aarch64" ]]; then
  CPU_COUNT=${CPU_COUNT:-$(nproc)}
  export CARGO_BUILD_JOBS=$(( CPU_COUNT > 4 ? 4 : CPU_COUNT ))
fi

pushd python

cargo-bundle-licenses \
    --format yaml \
    --output ${SRC_DIR}/THIRDPARTY.yml

${PYTHON} -m pip install . -vv --no-deps --no-build-isolation

popd