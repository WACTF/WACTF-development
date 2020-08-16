echo "__        ___    ____ _____ _____ ___        ___  _  _   "
echo "\ \      / / \  / ___|_   _|  ___/ _ \__  __/ _ \| || |  "
echo " \ \ /\ / / _ \| |     | | | |_ | | | \ \/ / | | | || |_ "
echo "  \ V  V / ___ \ |___  | | |  _|| |_| |>  <| |_| |__   _|"
echo "   \_/\_/_/   \_\____| |_| |_|   \___//_/\_\\___/   |_|  "
echo "                                                         "

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
echo "    Installing Docker    "
echo "#########################"

# Install Docker v19.03 latest patch (v5:19.03.11~3-0~ubuntu-bionic at time of writing)
sudo apt update && sudo apt install -y \
    docker-ce=5:19.03* \
    docker-ce-cli \
    containerd.io

echo "#################################"
echo "    Installing Docker-compose    "
echo "#################################"

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Prep gVisor
curl -fsSL https://gvisor.dev/archive.key | sudo apt-key add -
sudo add-apt-repository "deb https://storage.googleapis.com/gvisor/releases release main" # TODO FIX

echo "#########################"
echo "    Installing gVisor    "
echo "#########################"

# Install gVisor v2020 latest patch (v20200522.0 at time of writing)
sudo apt update && sudo apt install -y runsc=2020*

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
echo "    Installing Dockerslim    "
echo "#############################"

# Install dockersl.im
wget https://downloads.dockerslim.com/releases/1.31.0/dist_linux.tar.gz
tar -xvf dist_linux.tar.gz
sudo mv dist_linux/* /usr/local/bin/

echo "##################"
echo "    Testing...    "
echo "##################"

# Did it work?
sudo docker run --rm hello-world
sudo docker run --rm -it alpine dmesg
sudo docker-slim version

echo
echo "^_^ Confirm hello-world, gVisor, and docker-slim executed successfully above ^_^"
echo "gVisor has been set to the default runtime - you won't need to manually specify it when running containers"
echo "Now go Docker ^_^"
echo

