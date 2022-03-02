# tensorflow-lite-raspberrypi

![tensorflow-lite-raspberrypi](https://i.ibb.co/T43zRmZ/tensorflow-lite-raspberrypi.png)

Precompiled **TensorFlow Lite 2.8.0** binaries for **Raspberry Pi 3 & 4**.
Read the following [blog post](https://lindevs.com/install-precompiled-tensorflow-lite-on-raspberry-pi) for additional information.

## Supported features

* NEON optimization
* VFPv4 optimization
* XNNPACK delegate
* Ruy matrix multiplication library
* MMAP-based allocation
* C and C++ APIs

## Prerequisites

### Supported Boards

* Raspberry Pi 3 Model A+
* Raspberry Pi 3 Model B+
* Raspberry Pi 4 Model B

Tested on Raspberry Pi 4 Model B (8 GB).

### Supported OS

* Raspberry Pi OS Bullseye (32-bit)

## Install

```shell
wget https://github.com/prepkg/tensorflow-lite-raspberrypi/releases/latest/download/tensorflow-lite.deb
```

```shell
sudo apt install -y ./tensorflow-lite.deb
```

## Uninstall

```shell
sudo apt purge --autoremove -y tensorflow-lite
```

## Debian Package

Debian package contains the following shared libraries:

| Library                     | Description                                                            |
|:----------------------------|:-----------------------------------------------------------------------|
| libtensorflowlite_c.so      | C API to access TensorFlow Lite interpreter and perform an inference   |
| libtensorflow-lite.so       | C++ API to access TensorFlow Lite interpreter and perform an inference |

## Reference

1. [TensorFlow Lite repository](https://github.com/tensorflow/tensorflow/tree/master/tensorflow/lite)
