#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

arch='amd64'

suites="$(wget -qO- "https://github.com/debuerreotype/docker-debian-artifacts/raw/dist-$arch/suites")"
suites=( $suites )

rm -rf suites
mkdir suites

for suite in "${suites[@]}"; do
	echo "Generating '$suite' ..."

	target="suites/$suite"
	mkdir -p "$target"

	cat > "$target/Dockerfile" <<-EODF
		FROM debian:$suite
		RUN sed -i -e 'p; s/^deb /deb-src /' /etc/apt/sources.list
		RUN set -eux; apt-get update; apt-get install -y --no-install-recommends build-essential fakeroot; rm -rf /var/lib/apt/lists/*
	EODF
done
