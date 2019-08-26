#!/bin/bash
function build() {
    local NETWORK="tmpnetwork"
    local POSTGRES_USER="tmpuser"
    local POSTGRES_DB="tmpdb"
    local POSTGRES_PASSWORD="tmppassword"
    local DB_CONTAINER_NAME="tmppg"
    local APP_CONTAINER_NAME="mybackend"

    docker network create --driver=bridge $NETWORK
    docker run --net $NETWORK --name $DB_CONTAINER_NAME --expose 5432 -v $(pwd)/schema.sql:/docker-entrypoint-initdb.d/schema.sql -e POSTGRES_USER=$POSTGRES_USER -e POSTGRES_DB=$POSTGRES_DB -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -d postgres:11.5
    docker build --network $NETWORK -t $APP_CONTAINER_NAME --build-arg DB_HOST=$DB_CONTAINER_NAME --build-arg POSTGRES_USER=$POSTGRES_USER --build-arg POSTGRES_DB=$POSTGRES_DB --build-arg POSTGRES_PASSWORD=$POSTGRES_PASSWORD .
    docker stop $DB_CONTAINER_NAME
    docker rm $DB_CONTAINER_NAME
    docker network rm $NETWORK
}
build
