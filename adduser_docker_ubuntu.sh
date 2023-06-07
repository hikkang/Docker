#!/bin/bash

if [ -z ${PUB_KEY} ]
then
	echo "You did not provided public key ${PUB_KEY} paired with the private key created in AWS"
	exit 1
fi

if [ -z ${USER} ]
then
	echo "The USER env var is not provided"
	exit 1
fi

if [ -z ${PASSWD} ]
then
	echo "The PASSWD env var  is not provided"
	exit 1
fi

	
# 키 설정

echo ${PUB_KEY} >> .ssh/authorized_keys 

# user 추가

sudo adduser --disabled-password --gecos "" ${USER}

echo ${USER}:${PASSWD} | sudo chpasswd

sudo usermod -aG sudo ${USER}

# docker 설치

sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
	
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

docker --version

sudo apt-get update
sudo apt-get install docker-compose-plugin

docker compose version

sudo groupadd docker

sudo usermod -aG docker $USER
 
