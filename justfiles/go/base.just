set allow-duplicate-recipes

import '../base.just'
import './setup.just'
import './test.just'
import './build.just'

# Put Go tools in a repo-local .bin
# justfile_dir() is the parent dir of the root just file that this justfile was imported from.
export GOBIN := canonicalize(justfile_dir() / 'bin')

# Add GOBIN to PATH so we can use the tools we install.
export PATH := GOBIN + ":" + env_var('PATH')

# Setup & validate
[group('setup')]
default: setup lint test
