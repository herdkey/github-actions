# Install & generate
[group('setup')]
setup: install install-tools generate
    @echo "Setup complete."

[group('setup')]
install:
	go mod download

# Install additional required tools
[group('setup')]
install-tools: && _install_additional_tools
    #!/usr/bin/env -S bash -eu -o pipefail
    mkdir -p "$GOBIN"
    @if [ "{{ ci_mode }}" = "true" ]; then
        go install github.com/golangci/golangci-lint/cmd/golangci-lint@v2.4.0
    else
        brew install golangci-lint
    fi

# Override to add additional tools
[group('setup')]
_install_additional_tools:

[group('setup')]
tidy:
	go mod tidy

[group('setup')]
generate:
    go generate ./...
