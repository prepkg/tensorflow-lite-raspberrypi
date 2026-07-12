#!/bin/bash
set -eo pipefail

APP=$(pwd)
INSTALL_PATH=/opt/install/usr/local
mkdir -p $APP/build /tmp/tensorflow $INSTALL_PATH/{include,lib}

VERSION=v2.20.0
curl -sSL https://github.com/tensorflow/tensorflow/archive/refs/tags/$VERSION.tar.gz | tar xz --strip-components=1 -C /tmp/tensorflow
cd /tmp/tensorflow/tensorflow/lite

# Set default log level to WARNING
sed -i 's/minimum_log_severity_ = TFLITE_LOG_INFO;/minimum_log_severity_ = TFLITE_LOG_WARNING;/' minimal_logging_default.cc
# https://github.com/protocolbuffers/protobuf/issues/12292
sed -i '/^    absl::variant/a\    absl::log' CMakeLists.txt
# Set version
IFS='.' read -ra VERSION_ARRAY <<< "${VERSION#v}"
sed -i \
  -e "s/#error \"TF_MAJOR_VERSION is not defined\!\"/#define TF_MAJOR_VERSION ${VERSION_ARRAY[0]}/" \
  -e "s/#error \"TF_MINOR_VERSION is not defined\!\"/#define TF_MINOR_VERSION ${VERSION_ARRAY[1]}/" \
  -e "s/#error \"TF_PATCH_VERSION is not defined\!\"/#define TF_PATCH_VERSION ${VERSION_ARRAY[2]}/" \
  -e "s/#error \"TF_VERSION_SUFFIX is not defined\!\"/#define TF_VERSION_SUFFIX/" \
  ../core/public/release_version.h

{
  echo $VERSION

  rm -rf build
  cmake -S c -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=$APP/scripts/pi.cmake \
    -DCMAKE_SHARED_LINKER_FLAGS='-static-libstdc++ -static-libgcc' \
    -DCMAKE_CXX_FLAGS='-w' \
    -DTFLITE_HOST_TOOLS_DIR=/usr/local/bin \
    -DTFLITE_ENABLE_RUY=ON \
    -DTFLITE_ENABLE_NNAPI=OFF
  cmake --build build -j$(nproc)
  /opt/aarch64-linux-gnu/bin/aarch64-linux-gnu-strip -s build/libtensorflowlite_c.so
  cp build/libtensorflowlite_c.so $INSTALL_PATH/lib

  # Used to compile shared C++ library
  sed -i 's/add_library(tensorflow-lite/add_library(tensorflow-lite SHARED/' CMakeLists.txt

  rm -rf build
  cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=$APP/scripts/pi.cmake \
    -DCMAKE_SHARED_LINKER_FLAGS='-static-libstdc++ -static-libgcc' \
    -DCMAKE_CXX_FLAGS='-w' \
    -DTFLITE_HOST_TOOLS_DIR=/usr/local/bin \
    -DTFLITE_ENABLE_RUY=ON \
    -DTFLITE_ENABLE_NNAPI=OFF
  cmake --build build -j$(nproc)
  /opt/aarch64-linux-gnu/bin/aarch64-linux-gnu-strip -s build/libtensorflow-lite.so
  cp build/libtensorflow-lite.so $INSTALL_PATH/lib

  cp -r build/flatbuffers/include/flatbuffers $INSTALL_PATH/include
  rm -rf build

  cd /tmp/tensorflow
  find tensorflow/lite -name '*.h' -exec cp --parents {} $INSTALL_PATH/include \;
  rm -rf $INSTALL_PATH/include/tensorflow/lite/{examples,java,micro,nnapi,objc,python,testing,tools}
  rm -rf $INSTALL_PATH/include/tensorflow/lite/delegates/{coreml,gpu,hexagon,nnapi}
  cp --parents tensorflow/core/public/{version.h,release_version.h} $INSTALL_PATH/include
  find tensorflow/compiler/mlir/lite -name '*.h' -exec cp --parents {} $INSTALL_PATH/include \;
} 2>&1 | tee $APP/build/tensorflow-lite-aarch64-linux-gnu.txt

cd /opt && mkdir install/DEBIAN

cat << EOF > install/DEBIAN/control
Package: tensorflow-lite
Version: ${VERSION#v}-2
Architecture: arm64
Maintainer: prepkg <precompiledpkg@gmail.com>
Description: Deep learning framework for on-device inference
EOF

cat << EOF > install/DEBIAN/postinst
#!/bin/bash

ldconfig
EOF

chmod 755 install/DEBIAN/postinst
dpkg-deb -Zxz --build install $APP/build/tensorflow-lite-aarch64-linux-gnu.deb
