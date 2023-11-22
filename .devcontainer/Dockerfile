FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG BUILDARCH

ARG GO_VERSION=1.21.4

ARG PYTHON_VERSION=3.11
ARG PYTHON_PACKAGES="debugpy pyright black"

ARG NODE_MAJOR=21
ARG NPM_GLOBAL=/usr/local/share/npm-global
ARG NODE_MODULES="eslint tslint-to-eslint-config typescript"

RUN apt-get update && apt-get install -y \
	software-properties-common \
	build-essential \
	ca-certificates \
	curl \
	gnupg \
	foot-terminfo \
	ripgrep \
	python3-pip \
	g++-x86-64-linux-gnu \
	libc6-dev-amd64-cross \
	&& rm -rf /var/lib/apt/lists/*

# install node via nodesource https://github.com/nodesource/distributions/blob/master/README.md
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install nodejs -y
ENV PATH=${NPM_GLOBAL}/bin:${PATH}

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

# install python
RUN add-apt-repository -y ppa:deadsnakes/ppa \
	&& apt-get update \
	&& apt-get install -y python${PYTHON_VERSION}
RUN bash -c "python${PYTHON_VERSION} -m pip install -U pip setuptools && pip install ${PYTHON_PACKAGES}"

# https://github.com/devcontainers/images/blob/main/src/javascript-node/.devcontainer/Dockerfile
ENV USERNAME=root
RUN \
	# Configure global npm install location, use group to adapt to UID/GID changes
	if ! cat /etc/group | grep -e "^npm:" > /dev/null 2>&1; then groupadd -r npm; fi \
	&& usermod -a -G npm ${USERNAME} \
	&& umask 0002 \
	&& mkdir -p ${NPM_GLOBAL} \
	&& touch /usr/local/etc/npmrc \
	&& chown ${USERNAME}:npm ${NPM_GLOBAL} /usr/local/etc/npmrc \
	&& chmod g+s ${NPM_GLOBAL} \
	&& npm config -g set prefix ${NPM_GLOBAL} \
	&& bash -c "npm config -g set prefix ${NPM_GLOBAL}" \
	&& bash -c "umask 0002 && npm install -g ${NODE_MODULES}" \
	&& npm cache clean --force > /dev/null 2>&1

# install other dependencies as needed...
