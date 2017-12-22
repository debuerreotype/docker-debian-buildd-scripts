#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

arch='amd64'

suites="$(wget -qO- "https://github.com/debuerreotype/docker-debian-artifacts/raw/dist-$arch/suites")"
suites=( $suites )

jankyBuilds="https://doi-janky.infosiftr.net/job/tianon/job/debuerreotype/job/$arch"
jankyBuildNumber="$(wget -qO- "$jankyBuilds/lastSuccessfulBuild/buildNumber")"
jankyBase="$jankyBuilds/$jankyBuildNumber/artifact"

echo
echo "Downloading from '$jankyBase' ..."
echo

rm -rf suites
mkdir suites

wget -O suites/serial "$jankyBase/serial"

for suite in "${suites[@]}"; do
	echo
	echo "Trying '$suite' ..."

	target="suites/$suite"
	mkdir -p "$target"

	if ! wget -O "$target/rootfs.tar.xz" "$jankyBase/$suite/sbuild/rootfs.tar.xz"; then
		rm -rf "$target"
		continue
	fi

	cat > "$target/Dockerfile" <<-EODF
		FROM scratch
		ADD rootfs.tar.xz /
		CMD ["bash"]
	EODF
done
