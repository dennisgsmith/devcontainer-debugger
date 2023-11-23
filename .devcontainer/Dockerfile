ARG DEVCONTAINER_BASE_IMAGE=mcr.microsoft.com/devcontainers/base:ubuntu
FROM --platform=${BUILDPLATFORM} ${DEVCONTAINER_BASE_IMAGE}

ARG BUILDARCH

ARG GO_VERSION=1.21.4
ARG PYTHON_VERSION=3.11
ARG NODE_MAJOR=21

RUN apt-get update && apt-get install -y wget

COPY --chmod=0755 ./install_go.sh ./
RUN ./install_go.sh

COPY --chmod=0755 ./install_python.sh ./
RUN ./install_python.sh

COPY --chmod=0755 ./install_node.sh ./
RUN ./install_node.sh

# install other dependencies as needed...
