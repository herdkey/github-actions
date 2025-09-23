
# unit tests only (no integration)
[group('test')]
test coverage="false":
    #!/usr/bin/env -S bash -eu -o pipefail
    coverage_flags=""
    if [ "{{ coverage }}" = "true" ]; then
        coverage_flags="-v -coverprofile=coverage.out"
    fi

    go test $coverage_flags $(go list ./... | grep -v /tests/integration)

    if [ "{{ coverage }}" = "true" ]; then
        go tool cover -html=coverage.out -o coverage.html
    fi

# integration tests only
[group('test')]
integration-test:
	go test "./tests/integration/..."

# lint (w/ fix if dev mode)
[group('lint')]
lint:
    fix_flag="{{ if dev_mode == "true" { "--fix" } else { "" } }}"; \
    golangci-lint run $fix_flag

[group('lint')]
fmt:
	go fmt ./...
