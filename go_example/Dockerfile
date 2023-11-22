# this will be the target layer for development
FROM golang:1.21-alpine AS builder

RUN apk update && apk add --no-cache git

WORKDIR /go/src/app

ENV CGO_ENABLED=0
# install go debug server for use in alternate entrypoint via docker-compose.debug.yml
RUN go install github.com/go-delve/delve/cmd/dlv@latest
COPY go.* ./
RUN go mod download

COPY . .
RUN --mount=type=cache,target=/root/.cache/go-build \
	--mount=type=cache,target=/go/pkg \
	GOOS=linux GOARCH=amd64 \
	go build -ldflags="-w -s" -o /go/bin/hello

# copy the compiled binary over to a blank image for production
FROM scratch
COPY --from=builder /go/bin/hello /go/bin/hello
ENTRYPOINT ["/go/bin/hello"]
