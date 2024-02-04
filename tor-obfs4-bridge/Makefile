IMAGE=thetorproject/obfs4-bridge

.PHONY: tag
tag:
	@[ "${VERSION}" ] || ( echo "Env var VERSION is not set."; exit 1 )
	docker tag $(IMAGE) $(IMAGE):$(VERSION)
	docker tag $(IMAGE) $(IMAGE):latest

.PHONY: release
release:
	@[ "${VERSION}" ] || ( echo "Env var VERSION is not set."; exit 1 )
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

.PHONY: build
build:
	docker image pull debian:stable-slim
	docker build -t $(IMAGE) . --no-cache

.PHONY: crossbuild
crossbuild:
	@[ "${ARCH}" ] || ( echo "Env var ARCH is not set."; exit 1 )
	docker buildx build -t $(IMAGE) --platform linux/$(ARCH) .

.PHONY: crossbuild-and-release
crossbuild-and-release:
	@[ "${VERSION}" ] || ( echo "Env var VERSION is not set."; exit 1 )
	docker buildx build -t $(IMAGE):$(VERSION) -t $(IMAGE):latest --platform linux/arm64,linux/amd64,linux/386,linux/arm --push .

.PHONY: deploy
deploy:
	docker-compose up -d obfs4-bridge
	@echo "Make sure that port $(OR_PORT) and $(PT_PORT) are forwarded in your firewall."
