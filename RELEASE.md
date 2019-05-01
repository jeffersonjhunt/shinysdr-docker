### v1.3.1 (TBD)

* add arm64v8 multi-platform support

### v1.3.0 (Mon Apr 29 14:47:54 CDT 2019)

* repackage with __squish__ to reduce image size by >30%
* create multi-platform releases
  * amd64
  * i386
  * arm32v7 (armhf)
* create patches for gr-radioteletype for ARM architectures
* latest debian-slim image and patches (as of 4/29/2019)

### v1.2.1 (Thu Apr 18 10:48:53 CDT 2019)

* minor documentation updates
* support for hamlib 3.3 and hamlib wsjtx custom libraries
* additional image cleanup and size reduction
* latest debian-slim image (as of 4/18/2019)

### v1.2.0 (Wed Apr 17 16:54:07 CDT 2019)

* updated to latest versions of supported plugins
  * [WSJTX](https://physics.princeton.edu/pulsar/k1jt "WSJTX")
  * [gr-radioteletype](https://github.com/bitglue/gr-radioteletype "gr-radioteletype")
  * [multimon-ng](https://github.com/EliasOenal/multimon-ng "multimon-ng")
  * [rtl_433](https://github.com/merbanan/rtl_433 "rtl_433")
  * [gr-dsd]( "gr-dsd")
* migrated to debian:stable-slim to reduce image size

### v1.1.0 (Fri Apr 12 13:44:22 CDT 2019)

* gr-air-modes updated to latest
  * [gr-air-modes](https://github.com/bistromath/gr-air-modes "gr-air-modes")

### v1.0.0 (Wed Apr  3 15:35:19 CDT 2019)

* initial commit to GitHub
  * [GitHub](https://github.com/jeffersonjhunt/shinysdr-docker "GitHub Repo")
* initial commit of image to Docker Hub
  * [Docker Hub](https://cloud.docker.com/u/jeffersonjhunt/repository/docker/jeffersonjhunt/shinysdr "Docker Image")
* added the following Python modules to fix warnings
  * service_identity
  * pyasn1-modules
* add Docker entrypoint script `shinysdr-entrypoint.sh`

