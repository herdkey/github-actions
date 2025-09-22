#!/usr/bin/env bash
set -euo pipefail

# Expects repository already checked out with actions/checkout@v4 (token wired).
# Required env:
#   SEMVER_TAG   -> e.g. v1.2.3
# Optional env:
#   UPDATE_MINOR -> "true" (default) to also move vX.Y
#   DRY_RUN      -> "false" (default) to actually push

SEMVER="${SEMVER_TAG:?SEMVER_TAG env var required}"
UPDATE_MINOR="${UPDATE_MINOR:-true}"
DRY_RUN="${DRY_RUN:-false}"

cd "${GITHUB_WORKSPACE:-.}"

# Validate semver and derive major/minor tags
if [[ ! "$SEMVER" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)(-.+)?$ ]]; then
    echo "Error: SEMVER_TAG must look like vX.Y.Z (optionally with -dev, -prerelease, etc)."
    echo "Got: $SEMVER"
    exit 1
fi

MAJOR="$(echo "$SEMVER" | cut -d. -f1)"                 # v1
MINOR="$(echo "$SEMVER" | awk -F. '{print $1"."$2}')"   # v1.2

echo "Semver: $SEMVER"
echo "Major:  $MAJOR"
echo "Minor:  $MINOR"

# Ensure tags are up to date and the source tag exists
git fetch --tags --force
if ! git rev-parse -q --verify "refs/tags/$SEMVER" >/dev/null; then
    echo "Error: tag $SEMVER not found in repo."
    exit 1
fi

# Move major (lightweight tag)
echo "Retag $MAJOR -> $SEMVER"
git tag -f "$MAJOR" "$SEMVER"

# Optionally move minor (lightweight tag)
if [[ "${UPDATE_MINOR}" == "true" ]]; then
    echo "Retag $MINOR -> $SEMVER"
    git tag -f "$MINOR" "$SEMVER"
fi

# Dry run?
if [[ "${DRY_RUN}" == "true" ]]; then
    echo "Dry run enabled; not pushing."
    exit 0
fi

# Push updated tags
git push origin -f "$MAJOR"
if [[ "${UPDATE_MINOR}" == "true" ]]; then
    git push origin -f "$MINOR"
fi

echo "Done."
