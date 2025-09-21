#!/usr/bin/env bash
set -euo pipefail

# Ensure dependencies are tidy
# Use -mod=mod to update go.mod/go.sum as needed, then fail if changes
export GO111MODULE=on

go mod tidy

git diff --exit-code
