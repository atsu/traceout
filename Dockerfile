# Build from atsu/ parent dir:
#   docker buildx build -f traceout/Dockerfile traceout
# Pure Go (CGO_ENABLED=0): cross-compiled on the build platform.

# golang:1.27.1-alpine3.24
FROM --platform=$BUILDPLATFORM golang:1.27.1-alpine3.24@sha256:8a5910f31396cd4d89662f56c68b3ae31d374308270a1c3bd96672ee5ed43414 AS builder
RUN apk add --no-cache git
WORKDIR /src
COPY . /src/
ARG TARGETOS TARGETARCH VERSION
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
    go build -o /out/btrace ./

# alpine:3.24.2
FROM alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6
COPY --from=builder /out/btrace /bin/btrace
ENTRYPOINT ["/bin/btrace"]
