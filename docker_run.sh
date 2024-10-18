#!/bin/bash

# Set variables
IMAGE_NAME="hello1"
CONTAINER_NAME="hello1"
HOST_PORT=8000
CONTAINER_PORT=8000

# Check if the container is already running
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Container '$CONTAINER_NAME' is already running."
    exit 1
fi

# Check if the container exists but is stopped
if [ "$(docker ps -aq -f status=exited -f name=$CONTAINER_NAME)" ]; then
    echo "Container '$CONTAINER_NAME' exists but is stopped. Starting it..."
    docker start $CONTAINER_NAME
else
    # Run the Docker container
    echo "Running container '$CONTAINER_NAME' from image '$IMAGE_NAME'..."
    docker run -t -p $HOST_PORT:$CONTAINER_PORT --name $CONTAINER_NAME $IMAGE_NAME
fi
