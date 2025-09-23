
# Build cmd for specific platform (use "darwin" for mac)
[group('build')]
_build cmd goos="linux":
	GOOS="{{ goos }}" GOARCH=amd64 CGO_ENABLED=0 \
	go build -a \
	-ldflags '-s -w -extldflags=-static' \
	-o "{{ GOBIN }}/{{ cmd }}" \
	"{{ justfile_dir() }}/cmd/{{ cmd }}"

[group('clean')]
clean:
	rm -rf "{{ GOBIN }}/"
