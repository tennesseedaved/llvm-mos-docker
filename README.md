# LLVM MOS Cross-Compiler Toolchain Environment 

This project provides a Docker-based environment for cross-compilation, allowing developers to easily compile code for different platforms using a unified toolchain. The environment is encapsulated in a Docker container, making it portable and consistent across different development setups.

## Getting Started

These instructions will cover how to build the Docker image, source the script for easy function access, and how to use the provided functions for cross-compilation tasks.

### Prerequisites

- Docker installed on your machine. [Get Docker](https://docs.docker.com/get-docker/)
- Basic familiarity with Docker and command-line interfaces.

### Creating the Docker Image

To create the Docker image, you'll first need a Dockerfile. Ensure your Dockerfile is in the current directory, then run the following command:

```bash
docker build -t llvm_mos_image .
```

### Loading environment

Launch the container and load shell function for llvm exec by performing the following:

```bash
source llvm_env.sh
```

Note: This script assumes all work will be performed relative to the $HOME folder. To support seamless integration this mounts your $HOME folder in the container. All command executed via script function are invoked relative to $HOME. 

### Execute llvm commands

Use llvm_exec to pass through all command line instructions to the container environment.

```bash
llvm_exec clang
```
