#!/usr/bin/env bash
#
# Build a release archive that can be uploaded through
# OJS > Website Settings > Plugins > Upload A New Plugin.
#
# Usage: bash tools/build-release.sh 1.0.0
#
# The archive contains a single top-level folder named "alqalam" (the
# plugin's installation directory), as required by the OJS plugin installer.

set -euo pipefail

VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
	echo "Usage: $0 <version>   e.g. $0 1.0.0" >&2
	exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST="$ROOT/dist"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

mkdir -p "$DIST" "$STAGE/alqalam"

# Copy everything except development files
tar -c -C "$ROOT" \
	--exclude='./.git' --exclude='./.github' --exclude='./dist' --exclude='./node_modules' \
	--exclude='./.gitignore' --exclude='./.editorconfig' --exclude='*.psd' --exclude='*.ai' \
	. | tar -x -C "$STAGE/alqalam"

# Stamp the version into version.xml (release = x.y.z.0)
IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION"
sed -i -e "s|<release>.*</release>|<release>${MAJOR}.${MINOR}.${PATCH:-0}.0</release>|" \
	-e "s|<date>.*</date>|<date>$(date +%Y-%m-%d)</date>|" "$STAGE/alqalam/version.xml"

OUT="$DIST/alqalam-theme-${VERSION}.tar.gz"
tar -czf "$OUT" -C "$STAGE" alqalam

echo "Built $OUT"
tar -tzf "$OUT" | head -5
