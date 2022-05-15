# Zabbix, PostgreSQL (Timescale DB), Grafana, Traefik (TLS, HTTPS), Backup (Local and Google Drive, Yandex Disk)

## Overview

If you need your own zabbix server with HTTPS and Backups.

## Tested

- 2021-12-24

## Requirements

- Oracle VPS Free Tier (VM.Standard.E2.1.Micro) In my case 2 CPU, 1GB RAM, 2GB SWAP, 50GB HDD
- Ubuntu 20.04

## Version

- Zabbix 5.0.16
- Postgres 12
- Grafana 8.2.0
- Traefik 2.5.3

## Installation

### Clone the repository

```bash
cd ~ &&
git clone https://github.com/anklav24/zabbix-docker &&
cd zabbix-docker
```

### Select a develop branch (Optional)

```bash
git checkout develop
```

### Rename ```deploy_configs_example```, ```.env.example```

- ```deploy_configs_example``` -> ```deploy_configs```
- ```.env.example``` -> ```.env```

### Check ```deploy_configs``` and ```*-docker-compose.yaml```

Replace domains, envs, emails, logins, passwords and tls.certresolver on yours!

### Install Docker, Docker-compose and other stuff.

```bash
chmod +x install.sh && ./install.sh
```

### Run compose files

For a split config, use one of these two commands on the two servers:

```bash
cd ~/zabbix-docker
```

```bash
docker-compose -f zabbix-server-docker-compose.yaml up -d

docker-compose -f zabbix-web-docker-compose.yaml up -d
```

If you have one powerful VPS use:

```bash
docker-compose up -d
```

### Copy postgres config at the end of file
```bash
deploy_configs_example/postgres/postgres.conf -> zbx_env/var/lib/postgresql/data/postgresql.conf
```

### Install gdrive as root user

- https://github.com/prasmussen/gdrive
- Find folder_id

```bash
# Example
gdrive list --absolute --query "mimeType = 'application/vnd.google-apps.folder' and name contains 'backup'" --max 1000
```

- Change in `grafana_backup.sh` and `zabbix_postgres_backup.sh` `gdrive_folder_id` variable to your `Id`

### Setup Yandex Drive Aouth token

- In `.env` add your `YANDEX_TOKEN`
- Go to web yandex disk and create folder /backups/zabbix_backup/ or change the path in the backup scripts (Do the same for grafana_backup)

### Setup Systemd service

Set up backup automation:

```bash
sudo cp systemd_services/* /etc/systemd/system/  # Copy services and timers files.
sudo systemctl start grafana_montly_backup.service  # Check the service works properly (Example)
sudo systemctl enable grafana_montly_backup.timer  # Enable a timer (Example)
```

```bash
sudo systemctl daemon-reload  # Reload systemd after service changing.
clear; sudo systemctl status *4sou*timer  # Check backup timers
sudo systemctl list-timers  # Check all timers
sudo systemctl list-unit-files *backup*.timer  # Check if timers are enabled

journalctl -u grafana_daily_backup.timer  # Check logs
journalctl -u grafana_daily_backup.service  # Check logs
```

```bash
sudo systemctl start grafana_daily_backup.service  # Start the backup manually.
sudo systemctl start grafana_monthly_backup.service  # Start the backup manually.
sudo systemctl start grafana_yearly_backup.service  # Start the backup manually. With Google Drive Sync

sudo systemctl start grafana_daily_backup.timer
sudo systemctl start grafana_monthly_backup.timer
sudo systemctl start grafana_yearly_backup.timer

sudo systemctl enable grafana_daily_backup.timer
sudo systemctl enable grafana_monthly_backup.timer
sudo systemctl enable grafana_yearly_backup.timer
```

```bash
sudo systemctl start zabbix_postgres_daily_backup.service  # Start the backup manually.
sudo systemctl start zabbix_postgres_monthly_backup.service  # Start the backup manually.
sudo systemctl start zabbix_postgres_yearly_backup.service  # Start the backup manually. With Google Drive Sync

sudo systemctl start zabbix_postgres_daily_backup.timer
sudo systemctl start zabbix_postgres_monthly_backup.timer
sudo systemctl start zabbix_postgres_yearly_backup.timer

sudo systemctl enable zabbix_postgres_daily_backup.timer
sudo systemctl enable zabbix_postgres_monthly_backup.timer
sudo systemctl enable zabbix_postgres_yearly_backup.timer
```

## Grafana

- PostgeSQL
    - Configuration
        - Configuration - Data sources - Add data source - PostgreSQL
        - Host: postgres-server or zabbix-server24.duckdns.org:5432
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
    - Click Plus button - Create - Dashboard - Add an empty panel - Add new metrics - Apply
    - Adjust - Refresh Time

## Zabbix

### Android Active Agent

- [Android Zabbix Active Agent](https://play.google.com/store/apps/details?id=fr.damongeot.zabbixagent&hl=ru&gl=US)
- [Template](https://github.com/muutech/zabbix-templates/tree/master/ANDROID)
- Add auto registration actions in Zabbix-Server
- Enable discovery(?)

### Windows Passive/Active agents with TLS

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

### Mikrotik SNMP

- Enable SNMP and add corresponding IP's

## Traefik

- Setup `logrotate` check config in `deploy_configs/logrotate.d/traefik`
- Or turn off logs

## UI Links

- https://traefik.zabbix-web24.duckdns.org  (Restricted by IP using Traefik)
- https://zabbix.zabbix-web24.duckdns.org/basic_status  (Restricted by IP using Traefik)
- https://zabbix.zabbix-web24.duckdns.org
- https://grafana.zabbix-web24.duckdns.org
- https://mikrotik.zabbix-web24.duckdns.org

## References

- https://www.duckdns.org/
- https://ssllabs.com/ssltest
- https://hstspreload.org/
- https://doc.traefik.io/traefik/
- https://grafana.com/tutorials/run-grafana-behind-a-proxy/
- https://github.com/muutech/zabbix-templates/tree/master/ANDROID
- https://doc.traefik.io/traefik/v1.6/configuration/logs/#log-rotation
- https://play.google.com/store/apps/details?id=fr.damongeot.zabbixagent&hl=ru&gl=US
- https://www.zabbix.com/documentation/5.0/ru/manual/encryption/using_pre_shared_keys
- https://www.zabbix.com/documentation/5.0/manual/config/items/itemtypes/zabbix_agent/win_keys
