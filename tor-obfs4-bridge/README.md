# docker-obfs4-bridge

This repository contains the docker files for an obfs4 Tor bridge.

## Deploying an image

Take a look at our
[official setup instructions](https://community.torproject.org/relay/setup/bridge/docker/)
for more details.

## Building and releasing a new image for your architecture

First, build the image:

    make build

Next, release a new version by adding a tag:

    make tag VERSION=X.Y

Finally, release the image:

    make release VERSION=X.Y

Once we released a new image version, we tag the respective git commit:

    git tag -a -s "vVERSION" -m "Docker image version VERSION."
    git push --tags origin main

## Cross-building for a custom arch
> Note: this command does not save the resulting image anywhere and is only for checking whether the build succeeds or not.

First, ensure that `buildx` is already installed, you can follow [this link for the documentations](https://docs.docker.com/buildx/working-with-buildx/).
> The supported archs are amd64, arm64 and 386

If you are using an amd64 machine, you need to install needed emulators if you want to build arm64 images:

    docker run --privileged --rm tonistiigi/binfmt --install arm64

Then, you can cross-build it by running

    make crossbuild ARCH=arch


## Cross-building for all supported archs and releasing a new image
> Note: if you don't have access to `thetorproject/obfs4-bridge` Docker Hub repository, you might need to change the variable `IMAGE` in the `Makefile` to a repository you do have access to.

First, ensure that `buildx` is already installed, you can follow [this link for the documentations](https://docs.docker.com/buildx/working-with-buildx/).

If you are using an amd64 machine, you need to install needed emulators if you want to build arm64 images:

    docker run --privileged --rm tonistiigi/binfmt --install arm64

If this is your first time cross-building multiple archs at the same time using buildx, you need to create a new buildx builder instance:

    docker buildx create --use --name builder

Then, all you need to do is to do crossbuild and directly release the built image to the repository

    make crossbuild-and-release VERSION=X.Y

Once we released a new image version, we tag the respective git commit:

    git tag -a -s "vVERSION" -m "Docker image version VERSION."
    git push --tags origin main
