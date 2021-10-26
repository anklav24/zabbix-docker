# Zabbix, PostgreSQL, Grafana, Traefik (TSL, HTTPS)

## Requirements
- Oracle VPS Free Tier (VM.Standard.E2.1.Micro)
- Ubuntu 20.04

## Version
- Zabbix
- Postgres
- Grafana
- Traefik

## Clone the repository
```bash
cd ~ &&
git clone https://github.com/anklav24/zabbix-docker &&
cd zabbix-docker
```

## Select a branch (Optional)
```bash
git checkout develop
```

## Install
Docker, Docker-compose and other stuff.
```bash
chmod +x install.sh && ./install.sh
```

## Run compose files
For a split config use these two commands on two servers:
```bash
cd ~/zabbix-docker
```
```bash
docker-compose -f zabbix-server-docker-compose.yaml up -d

docker-compose -f zabbix-web-docker-compose.yaml up -d
```
If you have one powerfull VPS use:
```bash
docker-compose up -d
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

## Zabbix
### Android Active Agent
- [Android Zabbix Active Agent](https://play.google.com/store/apps/details?id=fr.damongeot.zabbixagent&hl=ru&gl=US)
- [Template](https://github.com/muutech/zabbix-templates/tree/master/ANDROID)
- Add autoregistration actions in Zabbix-Server
- Enable discovery(?)
 
### Windows Passive/Active agents
- Generate and save ```C:\Program Files\Zabbix Agent\zabbix_agentd.psk```
  ```bash
  openssl rand -hex 32
  ```
- Add into ```C:\Program Files\Zabbix Agent\zabbix_agentd.conf```
  ```bash
  TLSConnect=psk
  TLSAccept=psk
  TLSPSKFile=C:\Program Files\Zabbix Agent\zabbix_agentd.psk
  TLSPSKIdentity=NZXT-HOME-PC
  ```
- Restart the agent service from the task manager

### UI Links
Traefik
- https://traefik.zabbix-web24.duckdns.org
- https://zabbix.zabbix-web24.duckdns.org
- https://grafana.zabbix-web24.duckdns.org
- https://mikrotik.zabbix-web24.duckdns.org

### References
- https://www.duckdns.org/
- https://ssllabs.com/ssltest
- https://hstspreload.org/
- https://doc.traefik.io/traefik/
- https://grafana.com/tutorials/run-grafana-behind-a-proxy/
- https://github.com/muutech/zabbix-templates/tree/master/ANDROID
- https://play.google.com/store/apps/details?id=fr.damongeot.zabbixagent&hl=ru&gl=US
- https://www.zabbix.com/documentation/5.0/ru/manual/encryption/using_pre_shared_keys
- https://www.zabbix.com/documentation/5.0/manual/config/items/itemtypes/zabbix_agent/win_keys
