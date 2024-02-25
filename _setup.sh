#!/bin/bash


# install runner
# mkdir actions-runner 

# ## configure 
# sudo chown -R actions-runner/

# cd actions-runner

# curl -o actions-runner-linux-x64-2.313.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.313.0/actions-runner-linux-x64-2.313.0.tar.gz

# sudo chown -R ubuntu actions-runner/*

# tar xzf ./actions-runner-linux-x64-2.313.0.tar.gz

# sudo chown -R ubuntu actions-runner/*

# ./config.sh --unattended --url https://github.com/theoafactor/SimplePersonal --token ADKQKWJZ7GI4YK6TZ4F6HTTF3NY2I --name worker1 --label worker1 --replace

# sudo ./svc.sh install 

# sudo ./svc.sh start


# install Docker
#Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "Cloning Repository .."

sudo git clone https://github.com/theoafactor/SimplePersonal.git .


## build the image and run as container 
echo "Building and Running Docker Container ..."
BUILD_TAG=$(echo $RANDOM)
sudo docker build -t simpleweb.com:$BUILD_TAG .
sudo docker run -d -p 80:80 simpleweb.com:$BUILD_TAG




