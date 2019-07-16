platforms := linux/amd64 linux/i386 linux/arm32v7 linux/arm64v8

os = $(word 1, $(subst /, ,$@))
arch = $(word 2, $(subst /, ,$@))
version = v1.5.0

# to run under WSL use: make DOCKER=/mnt/c/Progra~1/Docker/Docker/resources/bin/docker.exe <TARGET>
DOCKER = $(shell which docker)

.PHONY: build squash manifest push publish clean quick debug

%/build:
	$(DOCKER) build --build-arg PLATFORM=$(arch) \
	  -t jeffersonjhunt/shinysdr:$(os)-$(arch)-$(version) .

build:
	for p in $(platforms); do \
		$(MAKE) $$p/build; \
	done

%/squash:
	$(DOCKER) build --squash --build-arg PLATFORM=$(arch) \
	  -t jeffersonjhunt/shinysdr:$(os)-$(arch)-$(version) .

squash:
	for p in $(platforms); do \
		$(MAKE) $$p/squash; \
	done

%/manifest: 
	$(DOCKER) manifest create --amend jeffersonjhunt/shinysdr:latest \
	  jeffersonjhunt/shinysdr:$(os)-$(arch)-$(version)
	$(DOCKER) manifest create --amend jeffersonjhunt/shinysdr:$(version) \
	  jeffersonjhunt/shinysdr:$(os)-$(arch)-$(version)

manifest: push
	for p in $(platforms); do \
		$(MAKE) $$p/manifest; \
	done

%/push:
	$(DOCKER) push jeffersonjhunt/shinysdr:$(os)-$(arch)-$(version)

push: squash
	for p in $(platforms); do \
		$(MAKE) $$p/push; \
	done

publish: manifest
	$(DOCKER) manifest push --purge jeffersonjhunt/shinysdr:$(version)
	$(DOCKER) manifest push --purge jeffersonjhunt/shinysdr:latest

%/clean:
	$(DOCKER) rmi jeffersonjhunt/shinysdr:$(os)-$(arch)-$(version)

clean:
	for p in $(platforms); do \
		$(MAKE) $$p/clean; \
	done

%/run:
	$(DOCKER) run --rm -p 8100:8100 -p 8101:8101 -v ~/.shinysdr:/config \
	  jeffersonjhunt/shinysdr:$(os)-$(arch)-$(version) start /config/my-config

quick: linux/amd64/build linux/amd64/run

%/debug: 
	$(DOCKER) run --rm -it --entrypoint /bin/bash jeffersonjhunt/shinysdr:$(os)-$(arch)-$(version)

debug: linux/amd64/debug
