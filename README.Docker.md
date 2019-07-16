# Supported tags and respective Dockerfile links

* [latest](https://github.com/jeffersonjhunt/shinysdr-docker/blob/master/Dockerfile "Dockerfile")
* [v1.3.0](https://github.com/jeffersonjhunt/shinysdr-docker/blob/v1.3.0/Dockerfile "Dockerfile")
* [v1.4.2](https://github.com/jeffersonjhunt/shinysdr-docker/blob/v1.4.2/Dockerfile "Dockerfile")
* [v1.5.0](https://github.com/jeffersonjhunt/shinysdr-docker/blob/v1.5.0/Dockerfile "Dockerfile")

# Quick reference

* __Where to file issues:__

   https://github.com/jeffersonjhunt/shinysdr-docker/issues

* __Maintained by:__

   [jeffersonjhunt](https://hub.docker.com/u/jeffersonjhunt "Profile of Jefferson J Hunt")

* __Supported architectures: [(more info)](https://github.com/docker-library/official-images#architectures-other-than-amd64 "Docker alt architectures")__

   amd64 (x86_64), i386, arm32v7 (armhf), arm64v8

* __Supported Single Board Computers (SBC): [(more info)](https://github.com/jeffersonjhunt/shinysdr-docker/blob/master/guides "Guides")__

   Raspberry Pi 3 Model B, Raspberry Pi 3 Model B+, NVIDIA Jetson Nano

* __Source of this description:__

   On the GitHub repo at [README.Docker.md](https://github.com/jeffersonjhunt/shinysdr-docker/blob/master/README.Docker.md "README.Docker.md")

* __Supported Docker versions:__

   the latest CE release (down to 18-ce on a best-effort basis)

# What is GNURadio + ShinySDR?

*from the [ShinySDR GitHub Repo](https://github.com/kpreid/shinysdr "GitHub ShinySDR"):* 

>ShinySDR is the software component of a software-defined radio receiver. When combined with suitable hardware devices such as the RTL-SDR, HackRF, or USRP, it can be used to listen to or display data from a variety of radio transmissions.

*from [GNURadio.org/about](https://www.gnuradio.org/ "GNURadio")*:

>GNU Radio is a free & open-source software development toolkit that provides signal processing blocks to implement software radios. It can be used with readily-available low-cost external RF hardware to create software-defined radios, or without hardware in a simulation-like environment. It is widely used in research, industry, academia, government, and hobbyist environments to support both wireless communications research and real-world radio systems.

# How to use this image

### Config ShinySDR
```bash
$ mkdir ~/.shinysdr
$ docker run -it --rm -v ~/.shinysdr:/config jeffersonjhunt/shinysdr init /config/my-config
```
This will create a `.shindysdr` directory in `$HOME` and run the `--create config` command of ShinySDR. In this case the config will be named `my-config` and will be added as sub-directory of `~/.shindysdr`

Edit the `config.pl` in `~/.shinysdr/my-config` to match your requirements following the instructions at [ShinySDR Manual: Configuration and devices](https://shinysdr.switchb.org/manual/configuration "ShinySDR Manual: Configuration and devices")

### Run ShinySDR
```bash
$ docker run --rm -p 8100:8100 -p 8101:8101 -v ~/.shinysdr:/config --name shinysdr jeffersonjhunt/shinysdr start /config/my-config
```
This will run ShinySDR with the config located at `~/.shinysdr/my-config`

# Building the Dockerfile

For more information about the build, versions used and how to modify it see the
[README.md](https://github.com/jeffersonjhunt/shinysdr-docker/blob/master/README.md "README.md")

# License
View license information for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
