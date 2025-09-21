#!/usr/bin/env bash
set -euo pipefail

# Show any diffs from code generation
git diff --name-only || true

git diff --exit-code
