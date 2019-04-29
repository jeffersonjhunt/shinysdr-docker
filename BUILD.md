# Readme

This document covers the building of the Docker multi-platform images.

## Docker image

__squish__ requires that the Docker experimental settings be enabled. Add the following to `/etc/docker/daemon.json`
```
{ 
    "experimental": true 
} 
```

The build can be completed without __squish__ but it will result in much larger image. The default will build amd64 based images.
```
docker build --squash -t jeffersonjhunt/shinysdr .
```

## Patches

### gr-radioteletype

There are `char` narrowing errors in the current *master* branch of [gr-radioteletype](https://github.com/bitglue/gr-radioteletype "gr-radioteletype master branch") for `arm` architectures. The [radioteletype.patch](https://github.com/jeffersonjhunt/shinysdr-docker/blob/devel/patches/radioteletype.patch "radioteletype.patch") in `patches` will add `signed char` and correct the issue in `ascii_to_letters` and `ascii_to_figures`.

## Alternate architectures

The following instructions are for building platform specific images. The currently supported images (PLATFORM) types are:

  `amd64`, `i386`, `arm32v7`

In theory any platform supported by [Docker](https://github.com/docker-library/official-images#architectures-other-than-amd64 "Alternate Architectures") and [Debian](https://hub.docker.com/_/debian "Debian Platforms") would work, but only the aforementioned ones have been tested.

### 32 bit support (i386)

To build the image requires the additional `--build-arg` to be passed set to `i386`.

```
docker build --squash --build-arg PLATFORM=i386 -t jeffersonjhunt/shinysdr .
```

### Raspberry PI (arm32v7)

In order to build `arm32v7` based containers the build will need to be performed on an Raspberry PI or using Qemu on a Linux machine with [`binfmt-support`](https://en.wikipedia.org/wiki/Binfmt_misc "binfmt").

This page [Debian Wiki](https://wiki.debian.org/RaspberryPi/qemu-user-static "Debian Qemu Raspberry") used for creating an Raspbian image for local building/testing goes further than necessary, but provides excellent background information. The minimum supporting packages can be installed with:

```
sudo apt-get update
sudo apt-get install qemu-user
sudo apt-get install qemu-user-static
```

To build the image requires the additional `--build-arg` to be passed set to `arm32v7`. *__NOTE:__ on an i7-6600 this process takes several hours to complete.*

```
docker build --squash --build-arg PLATFORM=arm32v7 -t jeffersonjhunt/shinysdr .
```