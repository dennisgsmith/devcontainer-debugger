FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG NODE_MAJOR=21
ARG GO_VERSION=1.21.4
ARG BUILDARCH

# these dependencies are needed for cross-building on aarch64
RUN apt-get update && apt-get install -y \
	build-essential ca-certificates curl gnupg foot-terminfo ripgrep python3-pip g++-x86-64-linux-gnu libc6-dev-amd64-cross \
	&& rm -rf /var/lib/apt/lists/*

# install node via nodesource https://github.com/nodesource/distributions/blob/master/README.md
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install nodejs -y

# install go
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-${BUILDARCH}.tar.gz \
	&& tar -C /usr/local -xzvf go${GO_VERSION}.linux-${BUILDARCH}.tar.gz \
	&& rm go${GO_VERSION}.linux-${BUILDARCH}.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# install delve (go debugger), gopls language server, staticcheck
ENV CGO_ENABLED=0
ENV GOBIN=/usr/local/bin/
RUN go install github.com/go-delve/delve/cmd/dlv@latest
RUN go install golang.org/x/tools/gopls@latest
RUN go install honnef.co/go/tools/cmd/staticcheck@latest

# python 3.10.12 is already installed
RUN python3 -m pip install -U pip && pip install debugpy pyright black

# install other dependencies as needed...
