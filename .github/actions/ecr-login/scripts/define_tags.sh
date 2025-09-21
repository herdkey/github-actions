#!/usr/bin/env bash
set -euo pipefail

# Base URL of the ECR tags
IMAGE_BASE="$REGISTRY/$ENV_NAME/$REPO_SLUG/api"

# take the first 7 chars of the full commit SHA (shorter, still unique enough for dev)
SHORT_SHA=$(echo "$GITHUB_SHA" | cut -c1-7)

# GITHUB_REF_NAME is just the branch name or "<pr_number>/merge" for PRs.
# Replace all '/' with '-' so tags are safe (bash pattern replace: ${var//from/to})
SANITIZED_BRANCH="${GITHUB_REF_NAME//\//-}"

# Lowercase the branch name (bash parameter expansion: ${var,,})
SANITIZED_BRANCH="${SANITIZED_BRANCH,,}"

# Export vars to later GitHub Actions steps by appending to the special file $GITHUB_ENV.
echo "SHORT_SHA=$SHORT_SHA" >> "$GITHUB_ENV"
echo "SANITIZED_BRANCH=$SANITIZED_BRANCH" >> "$GITHUB_ENV"
echo "IMAGE_BASE=$IMAGE_BASE"
echo "BRANCH_TAG=${IMAGE_BASE}:${SANITIZED_BRANCH}"
echo "SHA_TAG=${IMAGE_BASE}:${SHORT_SHA}"
