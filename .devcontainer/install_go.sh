#!/bin/bash

wget https://go.dev/dl/go${GO_VERSION}.linux-${BUILDARCH}.tar.gz \
	&& tar -C /usr/local -xzvf go${GO_VERSION}.linux-${BUILDARCH}.tar.gz \
	&& rm go${GO_VERSION}.linux-${BUILDARCH}.tar.gz

export PATH=$PATH:/usr/local/go/bin
export CGO_ENABLED=0
export GOBIN=/usr/local/bin/

go install github.com/go-delve/delve/cmd/dlv@latest
go install golang.org/x/tools/gopls@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
