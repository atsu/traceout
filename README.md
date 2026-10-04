# traceout

Go library for reading the Linux [ftrace](https://www.kernel.org/doc/html/latest/trace/ftrace.html) ring buffer — parses event formats from tracefs and decodes raw per-CPU trace data into typed events.

Fork of [google/traceout](https://github.com/google/traceout), maintained by atsu as the event source for the legacy `gather` I/O collector.

## Changes from upstream

- `ftrace.Event` satisfies `gather`'s `app.Event` interface
- `GetPid` returns the tgid (thread group id) rather than the thread id
- Ring buffer is cleared before resize (faster unload)
- Process names are no longer cached (avoids stale `comm` after exec)
- `SetNonblock` only on `*os.File`
- Go modules

## Usage

```go
import "github.com/atsu/traceout/ftrace"

ft, err := ftrace.New(ftrace.NewLocalFileProvider())
```

`btrace.go` is a small command-line tracer built on the library. Requires root and a mounted tracefs (`/sys/kernel/tracing` or `/sys/kernel/debug/tracing`).

## Build

```sh
go build ./...
go test ./...
```

## Status

Maintenance only. The 2026 revival replaces ftrace-based collection with eBPF tracepoints; this library is kept for the legacy `gather` daemon.

## License

Apache 2.0 — see [LICENSE](LICENSE). Originally © Google Inc.; not an official Google product.
