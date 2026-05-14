# Build from traceout dir:
#   docker buildx build -f traceout/Dockerfile traceout
# traceout is a Linux ftrace utility (won't run on darwin, but builds anywhere).

FROM --platform=$BUILDPLATFORM golang:1.24-alpine AS builder
RUN apk add --no-cache git
WORKDIR /src
COPY go.mod ./
COPY . .
RUN go mod tidy
ARG TARGETOS TARGETARCH
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
    go build -o /out/btrace ./

FROM alpine:3.20
COPY --from=builder /out/btrace /bin/btrace
ENTRYPOINT ["/bin/btrace"]
