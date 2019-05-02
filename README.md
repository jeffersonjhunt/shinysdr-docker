# Readme

This document covers the current state of the Docker built image. It enumerates the known issues, todo lists, etc...

## Releases

See [RELEASE.md](https://github.com/jeffersonjhunt/shinysdr-docker/blob/v1.4.0/RELEASE.md "RELEASE.md") for more details.

* v1.4.0 - 
    * [Dockerfile](https://github.com/jeffersonjhunt/shinysdr-docker/blob/v1.4.0/Dockerfile "Dockerfile")
    * [Docker Image](https://hub.docker.com/r/jeffersonjhunt/shinysdr "Docker Image")

## Basics

See the [README.Docker.md](https://github.com/jeffersonjhunt/shinysdr-docker/blob/v1.4.0/README.Docker.md "README.Docker.md") for more information on basic operation using Docker.

Single Board Computers (SBC) like the *Raspberry Pi* and *NVIDIA Jetson Nano* are supported via Docker with specific guides located [here](https://github.com/jeffersonjhunt/shinysdr-docker/blob/master/guides "Guides").

### Init

```bash
$ docker run --rm -v ~/.shinysdr:/config jeffersonjhunt/shinysdr init /config/my-config
```

### Run

```bash
$ docker run --rm -p 8100:8100 -p 8101:8101 -v ~/.shinysdr:/config jeffersonjhunt/shinysdr start /config/my-config
```

## Config & Control

### Entrypoint script

The `shinysdr-entrypoint.sh` is used to simplify the interaction of Docker with ShinySDR. Docker passes in any additional arguments to the run command to the entrypoint. This allows the end user to create the default config using the ShinySDR tooling when one does not exist.

#### Examples

init `my-config`:
```bash
$ shinysdr-entrypoint.sh -d -i init /my-config
```

init `my-config` using Docker:
```bash
$ docker run --rm -v ~/.shinysdr:/config jeffersonjhunt/shinysdr init /config/my-config
```

start with `my-config`:
```bash
$ shinysdr-entrypoint.sh -d -i start /my-config
```

start with `my-config` using Docker:
```bash
$ docker run --rm -p 8100:8100 -p 8101:8101 -v ~/.shinysdr:/config --name shinysdr jeffersonjhunt/shinysdr start /config/my-config
```

stop:
```bash
$ shinysdr-entrypoint.sh -d -i stop
```

stop using Docker:
```bash
$ docker exec shinysdr shinysdr-entrypoint.sh stop
```
or
```bash
$ docker stop shinysdr
```

## Build Notes

### Dockerfile 
#### Structure

The `Dockerfile` is broken into several __RUN__ sections to allow for quicker builds while adding and refining modules, plugins, supporting apps and new versions of  ShinySDR.

#### Build

See: `BUILD.md` for complete details on building, debugging and packaging.

### fetch-js-deps.sh

This tool uses wget to retrieve files and needs to be switched out for curl (personal preference) to remove the dependency from the Dockerfile.

TODO: Integrate fetch-js-deps or equivalent effects into setup.py

### Python

There are old and missing Python modules that require the following modules be added before starting ShinySDR:

* pip install --upgrade service_identity
* pip install --upgrade pyasn1-modules 

### Plugins/Modules

The following optional plugins/modules are being added. The table tracks the current status, source, etc...

| Plugin/Module    | Status   |  Version  | Notes                                |
| ---------------- |:--------:|:---------:| ------------------------------------:|
| hamlib           | complete | latest**  | Controlling external hardware radios |
| gr-air-modes     | complete | latest*   | ADS-B, aircraft transponders         |
| gr-radioteletype | complete | latest*   | RTTY and PSK31 w/ARM patches         |
| wsjtx            | complete | 2.1.0-rc5 | WSPR weak-signal radio               |
| multimon-ng      | complete | latest*   | decodes digital transmission modes   |
| rtl_433          | complete | 18.12     | Miscellaneous telemetry              |
| gr-dsd           | complete | latest*   | Digital voice modes supported by DSD |
| SoapySDR         | complete | 0.7.1     | Vendor/platform neutral SDR library  |

&ast; master as of build date
&ast;&ast; patched version from wsjtx

*this list is no doubt incomplete and other modules/plugins will be added as time permits*
