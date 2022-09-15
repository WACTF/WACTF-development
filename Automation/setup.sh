#!/bin/bash
echo "__        ___    ____ _____ _____ ___        ___  ____  "
echo "\ \      / / \  / ___|_   _|  ___/ _ \__  __/ _ \| ___| "
echo " \ \ /\ / / _ \| |     | | | |_ | | | \ \/ / | | |___ \ "
echo "  \ V  V / ___ \ |___  | | |  _|| |_| |>  <| |_| |___) |"
echo "   \_/\_/_/   \_\____| |_| |_|   \___//_/\_\\\___/|____/ "
echo "                                                        "

DOCKER_VERSION="20.10.18"

# Prep environmemnt
sudo apt update && sudo apt -y upgrade

sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    jq

# Prep Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo "#########################"
echo "$(tput setaf 2)    Installing Docker    $(tput sgr0)"
echo "#########################"

# Install Docker v20.10.18
sudo apt update && sudo apt install -y \
    docker-ce=5:$DOCKER_VERSION~* \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin

# Prep gVisor
curl -fsSL https://gvisor.dev/archive.key | sudo gpg --dearmor -o /usr/share/keyrings/gvisor-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/gvisor-archive-keyring.gpg] https://storage.googleapis.com/gvisor/releases release main" | sudo tee /etc/apt/sources.list.d/gvisor.list > /dev/null


echo "#########################"
echo "$(tput setaf 2)    Installing gVisor    $(tput sgr0)"
echo "#########################"

# Install gVisor v2022 latest patch (20220905.0 at time of writing)
sudo apt update && sudo apt install -y runsc=2022*

# Set Docker runtime
sudo runsc install

# Set gVisor as default runtime & add a DNS server
# Someone who knows jq could do this better
echo '{"default-runtime": "runsc","dns": ["8.8.8.8"]}' > jsontmp.json
jq -s add /etc/docker/daemon.json jsontmp.json > new_jsontmp.json
sudo mv new_jsontmp.json /etc/docker/daemon.json
cat /etc/docker/daemon.json
rm jsontmp.json

sudo systemctl restart docker

echo "#############################"
echo "$(tput setaf 2)    Installing Dockerslim    $(tput sgr0)"
echo "#############################"

# Install dockersl.im
curl -sL https://raw.githubusercontent.com/docker-slim/docker-slim/master/scripts/install-dockerslim.sh | sudo -E bash -

echo "####################################"
echo "$(tput setaf 2)    Testing Docker Hello World...    $(tput sgr0)"
echo "####################################"

# Did it work?
sudo docker run --rm hello-world

echo "####################################"
echo "$(tput setaf 2)    Testing gVisor runtime...    $(tput sgr0)"
echo "####################################"

sudo docker run --rm -it alpine dmesg

echo "####################################"
echo "$(tput setaf 2)    Testing docker-slim install...    $(tput sgr0)"
echo "####################################"

sudo docker-slim version

echo
echo "Confirm hello-world, gVisor, and docker-slim executed successfully above ^_^"
echo "gVisor has been set to the default runtime - you won't need to manually specify it when running containers"
echo "Now go Docker ^_^"
echo

