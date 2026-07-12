FROM ubuntu:26.04

WORKDIR /app

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        curl ca-certificates git make ninja-build qemu-user unzip \
    && VERSION=$(basename $(curl -sILo /dev/null -w '%{url_effective}' https://github.com/Kitware/CMake/releases/latest)) \
    && curl -sSL https://github.com/Kitware/CMake/releases/latest/download/cmake-${VERSION#v}-linux-x86_64.tar.gz | tar xz --strip-components=1 -C /usr/local \
    && curl -sSLo flatc.zip https://github.com/google/flatbuffers/releases/download/v24.3.25/Linux.flatc.binary.g++-13.zip \
    && unzip -q flatc.zip flatc -d /usr/local/bin && rm -rf flatc.zip \
    && curl -sSLo protoc.zip https://github.com/protocolbuffers/protobuf/releases/download/v21.9/protoc-21.9-linux-x86_64.zip \
    && unzip -q protoc.zip bin/protoc -d /usr/local && rm -rf protoc.zip \
    && curl -sSL https://github.com/prepkg/gcc-toolchain/releases/latest/download/gcc-aarch64-linux-gnu.tar.gz | tar xz -C /opt \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash"]
