#!/bin/bash -e

ARGS=(
	run
	--rm
        acmesh acme.sh
        "$@"
)

set -x

exec "${DOCKER_COMPOSE:-docker-compose}" "${ARGS[@]}"

