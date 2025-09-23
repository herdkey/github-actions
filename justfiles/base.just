# Use bash and fail immediately on errors
set shell := ["/usr/bin/env", "bash", "-euo", "pipefail", "-c"]

# Root of this file's parent directory
just_common_root := source_dir()

# "true" if we are running in CI
ci_mode := env_var_or_default("CI", "false")
# convenience inversion of ci_mode
# "true" if we are running in dev mode (not CI)
dev_mode := if "{{ci_mode}}" == "true" { "false" } else { "true" }
