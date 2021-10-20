#!/usr/bin/env bash

# Update repo info and install git
sudo apt update
sudo apt -y install git

# Install Docker
sudo apt -y install apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get -y install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER   # Чтобы каждый раз не вводить sudo перед docker (Заработает после перезагрузки)

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version  # Test the installation.

# Clone the repository
cd ~
git clone https://github.com/anklav24/zabbix-docker
cd zabbix-docker

# Select a branch (Optional)
git checkout develop

# Install a stack
sudo mkdir -p ~/zabbix-docker/zbx_env/usr/share/zabbix/modules
cd ~/zabbix-docker
docker-compose up -d

sudo reboot now  # У меня дальше без перезагрузки не сработало
