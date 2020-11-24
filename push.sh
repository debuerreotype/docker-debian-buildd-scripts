#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")/suites"

for df in */Dockerfile; do
	dir="$(dirname "$df")"
	suite="$(basename "$dir")"

	docker push "debian/buildd:$suite"
done
