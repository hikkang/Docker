#!/bin/bash
export UID=$(id -u)
export GID=$(id -g)
export USER=$(id -u -n)
export USER_GROUP_NAME=$(id -g -n)

echo $UID
echo $GID
echo $USER
echo $USER_GROUP_NAME

docker-compose up --build
docker-compose run dev_env
