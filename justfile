# Used to test the setup-just action

import '.justfiles/base.just'

# Fails if import did not resolve
validate:
    @echo "ci_mode is" "{{ ci_mode }}"
