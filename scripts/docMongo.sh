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

# MONGO CONTAINER
if [ ! "$(docker ps -q -f name=$MONGO_NAME)" ]
then
    if [ "$(docker ps -aq -f status=exited -f name=$MONGO_NAME)" ]; then
        echo -e "${BRED}### Removing stopped container $MONGO_NAME${NOCOLOR}" >&2
        # cleanup
        docker rm $MONGO_NAME
    fi
    
    echo -e "${BGREEN}### Creating new container $MONGO_NAME ${NOCOLOR}" >&2
    # run your container
    docker run -d \
    -p 27017:27017 \
    -e MONGO_INITDB_ROOT_USERNAME=$MONGO_USER \
    -e MONGO_INITDB_ROOT_PASSWORD=$MONGO_PASS \
    --net $NETWORK \
    --name $MONGO_NAME \
    mongo
    
    echo -e "${BGREEN}### $MONGO_NAME container created${NOCOLOR}" >&2
else
    echo -e "${BGREEN}### Container $MONGO_NAME up and running${NOCOLOR}" >&2
fi
