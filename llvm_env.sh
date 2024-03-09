#!/bin/bash

# Docker image and container name
DOCKER_IMAGE="llvm_mos_image"
CONTAINER_NAME="pensive_lalande"

# Check if the script is being sourced or not
# This technique checks if the current script's PID (BASHPID) is equal to the shell's PID ($$).
# If not equal, the script is not being sourced.
if [[ "${BASH_SOURCE[0]}" -ef "$0" ]]; then
    echo "This script must be sourced. Use 'source ${BASH_SOURCE[0]}' or '. ${BASH_SOURCE[0]}'"
    return 1 2>/dev/null || exit 1  # exit correctly if not sourced
fi

# Function to start the container if it's not already running
docker_start_container() {
    if [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
        echo "Container already running."
    else
        echo "Starting container..."
        docker run -d --rm -v "$HOME:/home_host" --name $CONTAINER_NAME $DOCKER_IMAGE tail -f /dev/null
        # Check if the container started successfully
        if [ $? -ne 0 ]; then
            echo "Failed to start the container."
            return 1
        fi
    fi
}

# Execute a command in the running container, dynamically setting the working directory
llvm_exec() {
    local host_pwd=$(pwd)
    if [[ "$host_pwd" == $HOME* ]]; then
        local rel_path="${host_pwd#$HOME}"
        if [[ -z "$rel_path" || "$rel_path" == "/" ]]; then
            rel_path=""
        fi
        docker exec -it -w "/home_host${rel_path}" $CONTAINER_NAME "$@"
    else
        echo "Current working directory is not a descendant of \$HOME."
        return 1
    fi
}

# Automatically start the container when the script is sourced
docker_start_container
