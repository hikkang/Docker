!/bin/bash

if [ -z "${PUB_KEY}" ];
then
    echo "You did not provided public key in PUB_KEY paired with the private key created in AWS"
    exit 1
fi

if [ -z "${USER}" ];
then
    echo "The USER env var is not provided"
    exit 1
fi

if [ -z "${PASSWD}" ] ;
then
    echo "The PASSWD env var  is not provided"
    exit 1
fi


# user 추가 

sudo adduser --disabled-password --gecos "" ${USER}

echo ${USER}:${PASSWD} | sudo chpasswd

sudo usermod -aG sudo ${USER}

# docker 설치
echo "기존 docker 삭제"
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get update

sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "새로운 docker 추가"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

docker --version

docker compose version

# 키 설정

sudo mkdir /home/${USER}/.ssh
sudo touch /home/${USER}/.ssh/authorized_keys
sudo chmod 666 -R /home/${USER}/.ssh/authorized_keys
sudo echo ${PUB_KEY} >> /home/${USER}/.ssh/authorized_keys
sudo chmod 400 -R /home/${USER}/.ssh/authorized_keys
sudo chown ${USER}:${USER} -R /home/${USER}/.ssh
