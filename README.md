# devcontainer-debugger

This repository details how to set up docker containers with remote debug servers and a devcontainer with debugging clients.

## Preface

You're developing a Docker application (with one container or many) and troubleshooting some code. Nothing obvious stands out as a bug, but there's one hidden in there somewhere. You go to debug your application and find that you don't have permissions to do so. This is a problem I've faced on corperate machines without superuser privileges.

### Everything is remote (the workaround)

We may not have `sudo` access by default on our local machine, but we do in a container! Developing remotely via SSH is nothing new, and Microsoft has even developed an open [devcontainer spec](https://containers.dev/) which can be followed for remote development. Alright, I'll cut to the chase. You probably already know why you need this.

## Setup

### Defining requirements

To debug a program, we need to know about:
1. The programming language, lsp (language server protocol), and its respective debug client.
2. The debugging tool and program installed with the ability to run a debug server.
3. Permissions to launch the debug client and attach to a process after connecting to the debug server.

### Building the devcontainer

I wanted the ability to have a base image where I could control what's installed and not have to re-download and install VSCode extensions every time I recreated the dev container, so I opted to build my own base image for the container. See [.devcontainer/Dockerfile](./.devcontainer/Dockerfile) for an example. Note that for `aarch64` (i.e. Mac M1/M2, arm64) compatibility, there are some utilities for cross compilation installed (`g++-x86-64-linux-gnu`, `libc6-dev-amd64-cross`). You can install whatever dependencies you need here that you would regularly use on your local development machine.

Specifically, you'll need to install whatever debug server for your language in the targeted layer which your debug session will run. For example, in the go_example Dockerfile, I install [Delve](https://github.com/go-delve/delve/tree/master/Documentation/installation), a debugger for Go, in order to later call it when launching the debug task.

VSCode may try to automate many of these actions, but in my experience there is always some tweaking that needs to be done, so I find it easier to configure my own Dockerfile for the devcontainer.

### Install debug tools on the server(s)

In order to override the entrypoint and command supplied to each docker service, we can use a [docker-compose.debug.yml](./docker-compose.debug.yml) override file to specify this configuration. Note that we're:
- Specifying a build step to stop at for the Go service with `target: builder`. In [go_example/Dockerfile](./go_example/Dockerfile) we use [multi-stage builds](https://docs.docker.com/build/building/multi-stage/#stop-at-a-specific-build-stage) to stop at a target layer and specify an entrypoint and command.
- Supplying a build argument to the Python example with `BUILD_ENV=debug`. In [python_example/Dockerfile](./python_example/Dockerfile) we conditionally install a debugger based on a build argument passed to the layer. The concept is similar to Go in the docker-compose.debug.yml override, just calling [debugpy](https://github.com/microsoft/debugpy/wiki/Command-Line-Reference) instead of Delve.
- Mounting each service's directory as a volume so changes in the code are synced with the containers.

### Defining the devcontainer's IDE configuration

We'll need to create a [.devcontainer/devcontainer.json](./.devcontainer/devcontainer.json) that follows the devcontainer spec (this configuration can also be used to generated a devcontainer in some cases). Here we define the paths to all of the debug tools used within our devcontainer and some required user permissions. We can also define multple dockerfiles with the `"dockerComposeFiles"` property, including our `docker-compose.debug.yml`.

### Define launch tasks for debugging

Finally, in [.vscode/launch.json](./.vscode/launch.json), we just need to define the lanch tasks for our IDE to call each service.

After relaunching VS Code (or `CMD+SHIFT+P` and run `Dev Containers: Open Workspace In Container...` from the command pallete), your dev container should start up and you're ready to launch a debugging session!
