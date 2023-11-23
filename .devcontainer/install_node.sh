#!/bin/bash

apt-get update && apt-get install -y \
	build-essential \
	ca-certificates \
	curl \
	gnupg

# install node via nodesource https://github.com/nodesource/distributions/blob/master/README.md
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
apt-get update && apt-get install nodejs -y

# https://github.com/devcontainers/images/blob/main/src/javascript-node/.devcontainer/Dockerfile
# Configure global npm install location, use group to adapt to UID/GID changes
USERNAME=root
NPM_GLOBAL=/usr/local/share/npm-global
NODE_MODULES="eslint tslint-to-eslint-config typescript"

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

export PATH=${NPM_GLOBAL}/bin:${PATH}
