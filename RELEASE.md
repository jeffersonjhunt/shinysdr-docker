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

