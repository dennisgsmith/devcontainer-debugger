#!/bin/bash

apt-get update && apt-get intalll -y software-properties-common

add-apt-repository -y ppa:deadsnakes/ppa \
	&& apt-get update \
	&& apt-get install -y python${PYTHON_VERSION}

bash -c "python${PYTHON_VERSION} -m pip install -U pip setuptools && pip install debugpy pyright black"

# set newly installed version as python symlink
cd "$(dirname $(which python${PYTHON_VERSION}))" && ln -s python${PYTHON_VERSION} python
