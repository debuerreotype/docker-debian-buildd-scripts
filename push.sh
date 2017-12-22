#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")/suites"

serial="$(< serial)"

for df in */Dockerfile; do
	dir="$(dirname "$df")"
	suite="$(basename "$dir")"

	docker push "debian/buildd:$suite"
	docker push "debian/buildd:$suite-$serial"
done
