#!/usr/bin/env bash

# Colors
NOCOLOR='\033[0m'       # Text Reset
BRED='\033[1;31m'
BGREEN='\033[1;32m'

# Variables
NETWORK=mongo-network
MONGO_NAME=mongodb
MONGO_EXPRESS_NAME=mongo-express
MONGO_USER=admin
MONGO_PASS=admin

# MONGO-EXPRESS CONTAINER
if [ ! "$(docker ps -q -f name=$MONGO_EXPRESS_NAME)" ]
then
    if [ "$(dockep ps -aq -f status=exited -f name=$MONGO_EXPRESS_NAME)" ]; then
        echo -e "${BRED}### Removing stopped container $MONGO_EXPRESS_NAME${NOCOLOR}" >&2
        # cleanup
        docker rm $MONGO_EXPRESS_NAME
    fi
    
    echo -e "${BGREEN}### Creating new container $MONGO_EXPRESS_NAME${NOCOLOR}" >&2
    # run your container
    docker run -d \
    -p 8081:8081 \
    -e ME_CONFIG_MONGODB_ADMINUSERNAME=$MONGO_USER \
    -e ME_CONFIG_MONGODB_ADMINPASSWORD=$MONGO_PASS \
    -e ME_CONFIG_MONGODB_SERVER=$MONGO_NAME \
    -e ME_CONFIG_MONGODB_ENABLE_ADMIN=true \
    --net $NETWORK \
    --name $MONGO_EXPRESS_NAME \
    mongo-express
    
    echo -e "${BGREEN}### $MONGO_EXPRESS_NAME container created${NOCOLOR}" >&2
    exit
else
    echo -e "${BGREEN}### Container $MONGO_EXPRESS_NAME up and running${NOCOLOR}" >&2
fi
