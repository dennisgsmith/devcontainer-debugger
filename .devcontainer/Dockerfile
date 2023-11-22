FROM mcr.microsoft.com/devcontainers/base:ubuntu

# these dependencies are needed for cross-building on aarch64
RUN apt-get update && apt-get install -y \
	foot-terminfo ripgrep python3-pip g++-x86-64-linux-gnu libc6-dev-amd64-cross \
	&& rm -rf /var/lib/apt/lists/*

# install go
RUN wget https://go.dev/dl/go1.21.1.linux-amd64.tar.gz \
	&& tar -C /usr/local -xzvf go1.21.1.linux-amd64.tar.gz \
	&& rm go1.21.1.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# install delve (go debugger), gopls language server, staticcheck
ENV CGO_ENABLED=0
ENV GOBIN=/usr/local/bin/
RUN go install \
	github.com/go-delve/delve/cmd/dlv@latest \
	golang.org/x/tools/gopls@latest \
	honnef.co/go/tools/cmd/staticcheck@latest

# python 3.10.12 is already installed
RUN python3 -m pip install -U pip && pip install debugpy pyright black

# install other dependencies as needed...
