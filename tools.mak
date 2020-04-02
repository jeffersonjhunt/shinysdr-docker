# Common build commands

.PHONY: build squash manifest push quick debug tag

build:
	for p in $(platforms); do \
		$(MAKE) $$p/build; \
	done

squash:
	for p in $(platforms); do \
		$(MAKE) $$p/squash; \
	done

manifest: push
	for p in $(platforms); do \
		$(MAKE) $$p/manifest; \
	done

push: squash tag
	for p in $(platforms); do \
		$(MAKE) $$p/push; \
	done

	git push origin $(version)  

tag:
	git tag -a $(version) -m "release $(version)"

quick: linux/amd64/build linux/amd64/run

debug: linux/amd64/debug

