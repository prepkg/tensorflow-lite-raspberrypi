#!/bin/bash
set -eo pipefail

APP=$(pwd)
TARGET_ROOT=/opt/target
QEMU="qemu-aarch64 -L /opt/aarch64-linux-gnu/aarch64-linux-gnu/sysroot -E LD_LIBRARY_PATH=$TARGET_ROOT/usr/local/lib"

dpkg -x $APP/build/tensorflow-lite-aarch64-linux-gnu.deb $TARGET_ROOT

/opt/aarch64-linux-gnu/bin/aarch64-linux-gnu-gcc $APP/scripts/test/main.c -o /tmp/test-c \
  -I$TARGET_ROOT/usr/local/include \
  -L$TARGET_ROOT/usr/local/lib \
  -ltensorflowlite_c

$QEMU /tmp/test-c

/opt/aarch64-linux-gnu/bin/aarch64-linux-gnu-g++ $APP/scripts/test/main.cpp -o /tmp/test-cpp \
  -I$TARGET_ROOT/usr/local/include \
  -L$TARGET_ROOT/usr/local/lib \
  -static-libstdc++ \
  -static-libgcc \
  -ltensorflow-lite

$QEMU /tmp/test-cpp

for f in /opt/target/usr/local/lib/*.so /tmp/test*; do
  echo "File: $f"
  /opt/aarch64-linux-gnu/bin/aarch64-linux-gnu-readelf -d "$f" | grep NEEDED
done
