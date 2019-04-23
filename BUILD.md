# Readme

This document covers the building of the Docker multi-platform images.

## Docker image

__squish__ requires that the Docker expiermental settings be enabled. Add the following to `/etc/docker/daemon.json`
```
{ 
    "experimental": true 
} 
```

The build can be completed without __squish__ but it will result in much larger image.
```
docker build --squash -t jeffersonjhunt/shinysdr .
```

## Local build environment

The following will build a local environment for creating platform specific images.

### Raspberry PI

[Debian Wiki](https://wiki.debian.org/RaspberryPi/qemu-user-static "Debian Qemu Raspberry") used for creating an Raspbian image for local building/testing.

Only alterations to the instructions will be listed here.

Download the image:
```
wget https://downloads.raspberrypi.org/raspbian/images/raspbian-2019-04-09/2019-04-08-raspbian-stretch.zip
```

__WARNING!!!__ be sure to select the correct loopback device!

Increase disk size by 4GB
```
dd if=/dev/zero bs=1M count=4096 >> 2019-04-08-raspbian-stretch.img 
sudo losetup -f -P --show 2019-04-08-raspbian-stretch.img
```

Fix partitioning... 
```
sudo parted /dev/loop5
GNU Parted 3.2
Using /dev/loop5

(parted) print                                                           
Number  Start   End     Size    Type     File system  Flags
 1      4194kB  49.2MB  45.0MB  primary  fat32        lba
 2      50.3MB  3481MB  3431MB  primary  ext4

(parted) rm 2                  
(parted) mkpart primary 50.3
End? 100%                                                                 
(parted) quit
```

After completing the resize enter CHROOT jail
```
mkdir mount
sudo losetup -f -P --show 2019-04-08-raspbian-stretch.img
sudo mount /dev/loop5p2 -o rw mount
cd mount
sudo mount --bind /dev dev/
sudo mount --bind /sys sys/
sudo mount --bind /proc proc/
sudo mount --bind /dev/pts dev/pts
```