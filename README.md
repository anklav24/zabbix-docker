# Zabbix, PostgreSQL, Grafana, Traefik (TSL, HTTPS)

Version:
- Ubuntu 20.04
- Zabbix
- Postgres
- Grafana
- Traefik

# Update repo info and install git
```bash
sudo apt update &&
sudo apt -y install git
```

# Clone the repository
```bash
cd ~ &&
git clone https://github.com/anklav24/zabbix-docker &&
cd zabbix-docker
```

# Select a branch (Optional)
```bash
git checkout develop
```

## Install
```bash
chmod +x install.sh && ./install.sh
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


### UI Links
Traefik
- https://traefik.testing24.duckdns.org
- https://zabbix.testing24.duckdns.org
- https://grafana.testing24.duckdns.org
- https://mikrotik.testing24.duckdns.org

### References
- https://grafana.com/tutorials/run-grafana-behind-a-proxy/
