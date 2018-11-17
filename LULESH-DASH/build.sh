#!/bin/sh

export PATH="$PATH:/home/dpasqualin/opt/openmpi-4.0.0/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/dpasqualin/opt/openmpi-4.0.0/lib/"

BUILD_DIR=./build

FORCE_BUILD=false
if [ "$1" = "-f" ]; then
  FORCE_BUILD=true
fi

await_confirm() {
  if ! $FORCE_BUILD; then
    echo ""
    echo "   To build using these settings, hit ENTER"
    read confirm
  fi
}

mkdir -p $BUILD_DIR
rm -Rf $BUILD_DIR/*
(cd $BUILD_DIR && \
    cmake -DCMAKE_BUILD_TYPE=release \
           -DMPI_C_COMPILER=/home/dpasqualin/opt/openmpi-4.0.0/bin/mpicc \
           -DMPI_CXX_COMPILER=/home/dpasqualin/opt/openmpi-4.0.0/bin/mpiCC \
           ../ && \
    await_confirm && \
    make VERBOSE=1 2>&1 | tee make.log)
