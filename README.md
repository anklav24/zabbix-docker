# Zabbix, PostgreSQL, Grafana, Traefik (TSL, HTTPS)

Version:
- Ubuntu 20.04
- Zabbix
- Postgres
- Grafana
- Traefik

## Install

- Install Docker
  ```bash
  # Устанавливаем докер
  sudo apt-get update &&
  sudo apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release &&
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &&

  sudo apt-get update &&
  sudo apt-get -y install docker-ce docker-ce-cli containerd.io &&

  sudo usermod -aG docker $USER &&  # Чтобы каждый раз не вводить sudo перед docker
  sudo reboot now  # У меня дальше без перезагрузки не сработало
  ```
- Test Docker
  ```bash
  docker run --rm hello-world &&  # Testing
  docker ps -a  # Testing
  ```
- Install Docker Compose
  ```bash
  sudo curl -L "https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
  sudo chmod +x /usr/local/bin/docker-compose &&
  docker-compose --version  # Test the installation.
  ```
- Копируем репозиторий
  ```bash
  sudo apt update && sudo apt install git && # Update repo info and Install git if you don't have it.

  # Копируем репозиторий
  cd ~ &&
  git clone https://github.com/anklav24/zabbix-docker &&
  cd zabbix-docker &&
  ll
  ```
- Выбираем ветку (Опционально)
  ```bash
  # Опционально
  cd zabbix-docker
  git branch -va  # Смотрим ветки 
  git checkout develop # и переключаемся в другую если нужна другая версия Zabbix
  git branch -va  # Проверяем куда переключились
  ```
- Скопировать репозиторий
- Создать папки с ошибками bind
- Отредактировать все пароли и конфиги в env_vars
- запустить контейнер
  ```bash
  sudo mkdir -p ~/zabbix-docker/zbx_env/usr/share/zabbix/modules &&
  cd ~/zabbix-docker &&
  docker-compose up -d &&
  docker-compose -f traefik_compose.yaml up -d
  ```

### Grafana
- PostgeSQL
  - Configuration
    - Configuration - Data sources - Add data source - PostgreSQL
    - Host: postgres-server
    - Database: zabbix
    - User: zabbix
    - TLS/SSL Mode: disable
    - Version: 12+
  - Verify that you connect
    - Go to Explore and do some queries


- Zabbix plugin
  - Configuration - Plugins - Zabbix - Config - Enable
  - Configuration - Data sources - Add data source - Zabbix
  - Default - On
  - URL: http://zabbix-web-nginx-pgsql:8080/api_jsonrpc.php
  - Username: Admin  (Capital A)
  - Password: zabbix
  - Direct DB Connection - PostgreSQL (Optional)
  - Configuration - Data sources - Add data source - Zabbix - Dashboards - Add defaults (Optional)
  - Click Plus button - Create - Dashboard - Add an empty panel - Add new metrics - Applye
  - Adjust - Refresh Time

### PGadmin
- Долго подымается

### UI Links
Nginx
- http://testing24.duckdns.org/
- http://testing24.duckdns.org/zabbix/
- http://testing24.duckdns.org/portainer/
- http://testing24.duckdns.org/pgadmin/
- http://testing24.duckdns.org/grafana/
- http://testing24.duckdns.org/mikrotik/

Traefik
- https://traefik.testing24.duckdns.org
- https://zabbix.testing24.duckdns.org
- https://portainer.testing24.duckdns.org
- https://pgadmin.testing24.duckdns.org
- https://grafana.testing24.duckdns.org
- https://mikrotik.testing24.duckdns.org

### References
- https://grafana.com/tutorials/run-grafana-behind-a-proxy/
- https://www.pgadmin.org/docs/pgadmin4/latest/container_deployment.html
