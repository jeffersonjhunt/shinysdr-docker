platforms := linux/amd64 linux/i386 linux/arm32v7 linux/arm64v8

os = $(word 1, $(subst /, ,$@))
arch = $(word 2, $(subst /, ,$@))
version = v1.4.0

.PHONY: build manifest push publish clean quick

%/build:
	docker build --squash --build-arg PLATFORM=$(arch) -t jeffersonjhunt/shinysdr:$(os)-$(arch)-$(version) .

build:
	for p in $(platforms); do \
		$(MAKE) $$p/build; \
	done

%/manifest: 
	docker manifest create --amend jeffersonjhunt/shinysdr:latest jeffersonjhunt/shinysdr:$(os)-$(arch)-$(version)
	docker manifest create --amend jeffersonjhunt/shinysdr:$(version) jeffersonjhunt/shinysdr:$(os)-$(arch)-$(version)

manifest: push
	for p in $(platforms); do \
		$(MAKE) $$p/manifest; \
	done

%/push:
	docker push jeffersonjhunt/shinysdr:$(os)-$(arch)-$(version)

push: build
	for p in $(platforms); do \
		$(MAKE) $$p/push; \
	done

publish: manifest
	docker manifest push --purge jeffersonjhunt/shinysdr:$(version)
	docker manifest push --purge jeffersonjhunt/shinysdr:latest

%/clean:
	docker rmi jeffersonjhunt/shinysdr:$(os)-$(arch)-$(version)

clean:
	for p in $(platforms); do \
		$(MAKE) $$p/clean; \
	done

%/run:
	docker run --rm -p 8100:8100 -p 8101:8101 -v ~/.shinysdr:/config jeffersonjhunt/shinysdr:$(os)-$(arch)-$(version) start /config/my-config

quick: linux/amd64/build linux/amd64/run