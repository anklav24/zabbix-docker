#!/usr/bin/env bash

echo
echo "------Update packages------"
echo

sudo apt update

echo
echo "------Install programs (Optional)------"
echo

sudo apt install -y mc ncdu

echo
echo "------Install docker------"
echo

sudo apt -y install apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt -y install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER   # Чтобы каждый раз не вводить sudo перед docker (Заработает после перезагрузки)

echo
echo "------Install docker-compose------"
echo

sudo curl -L "https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version  # Test the installation.

echo
echo "------Install ctop------"
echo

echo "deb http://packages.azlux.fr/debian/ buster main" | sudo tee /etc/apt/sources.list.d/azlux.list
wget -qO - https://azlux.fr/repo.gpg.key | sudo apt-key add -
sudo apt update
sudo apt -y install docker-ctop

# Install a stack
sudo mkdir -p ~/zabbix-docker/zbx_env/usr/share/zabbix/modules
cd ~/zabbix-docker

#docker-compose up -d
#docker-compose -f zabbix-server-docker-compose.yaml up -d
#docker-compose -f zabbix-web-docker-compose.yaml up -d

sudo reboot now  # Перезагружаем и смотрим что все стартовало
