# tensorflow-lite-raspberrypi

[![GitHub Release](https://img.shields.io/github/v/release/prepkg/tensorflow-lite-raspberrypi)](https://github.com/prepkg/tensorflow-lite-raspberrypi/releases/latest)
[![License](https://img.shields.io/github/license/prepkg/tensorflow-lite-raspberrypi)](https://github.com/prepkg/tensorflow-lite-raspberrypi/blob/master/LICENSE)
[![Downloads](https://img.shields.io/github/downloads/prepkg/tensorflow-lite-raspberrypi/total)](https://github.com/prepkg/tensorflow-lite-raspberrypi/releases)

> ⚠️ **LiteRT replaces TensorFlow Lite.** There are no plans to publish LiteRT packages, and this repository will be removed in the future.

TensorFlow Lite binaries are compiled with the [GCC Toolchain](https://github.com/prepkg/gcc-toolchain) targeting older
glibc versions, ensuring compatibility across a wide range of Raspberry Pi boards running Raspberry Pi OS 64-bit.

## Why?

* **No official TensorFlow Lite packages.** There are no prebuilt official TensorFlow Lite packages for Raspberry Pi OS,
  forcing users to compile it from source themselves.
* **Slow compilation on Raspberry Pi.** Building TensorFlow Lite directly on a Raspberry Pi can take hours and often
  runs into the limited RAM available on the device.
* **No extra dependencies.** The required libraries are statically linked, so the TensorFlow Lite binaries only depend
  on the base system libraries already present on Raspberry Pi OS.

## Build Information

* Dynamically linked with an older glibc version. For details, see the [GCC Toolchain](https://github.com/prepkg/gcc-toolchain).
* Statically linked with libstdc++, and libgcc.

## Precompiled Binaries

If you prefer not to build the TensorFlow Lite yourself, a precompiled TensorFlow Lite can be downloaded from the [releases page](https://github.com/prepkg/tensorflow-lite-raspberrypi/releases).

```shell
curl -sSLo tensorflow-lite.deb https://github.com/prepkg/tensorflow-lite-raspberrypi/releases/latest/download/tensorflow-lite-aarch64-linux-gnu.deb \
  && sudo apt install -y ./tensorflow-lite.deb \
  && rm -rf tensorflow-lite.deb
```

## Compilation

### Requirements

* Git
* Docker

### Instructions

* Clone the repository:

```shell
git clone https://github.com/prepkg/tensorflow-lite-raspberrypi.git && cd tensorflow-lite-raspberrypi
```

* Build the Docker image:

```shell
./setup.sh build-image
```

* Build the library:

```shell
./setup.sh build-lib
```

After compilation, the `deb` package will be available in the `build` directory.

* (Optional) Run the test to verify that the library links correctly and the resulting binary runs under QEMU:

```shell
./setup.sh test-lib
```
