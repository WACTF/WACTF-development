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

# Install Docker v19.03 latest patch (v5:19.03.11~3-0~ubuntu-bionic at time of writing)
sudo apt update && sudo apt install -y \
    docker-ce=5:19.03* \
    docker-ce-cli \
    containerd.io

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Prep gVisor
curl -fsSL https://gvisor.dev/archive.key | sudo apt-key add -
sudo add-apt-repository "deb https://storage.googleapis.com/gvisor/releases release main" # TODO FIX

# Install gVisor v2020 latest patch (v20200522.0 at time of writing)
sudo apt update && sudo apt install -y runsc=2020*

# Set Docker runtime
sudo runsc install

# Set gVisor as default runtime
# Someone who knows jq could do this better
echo '{"default-runtime": "runsc"}' > jsontmp.json
jq -s add /etc/docker/daemon.json jsontmp.json > new_jsontmp.json
sudo mv new_jsontmp.json /etc/docker/daemon.json
cat /etc/docker/daemon.json
rm jsontmp.json

sudo systemctl restart docker

# Did it work?
sudo docker run --rm hello-world
sudo docker run --rm -it alpine dmesg
echo
echo "^_^ Confirm hello-world and gVisor executed successfully above ^_^"
echo "gVisor has been set to the default runtime - you won't need to manually specify it when running containers"
echo

# install dockersl.im

