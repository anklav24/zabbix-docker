# Zabbix, NGINX, PostgreSQL, Grafana, Portainer, PGadmin, HTTPS

Version:
- Ubuntu 20.04
- Zabbix
- Postgres
- Grafana
- Portainer
- PGadmin
- Nginx (Reverse-proxy)

- Скопировать репозиторий
- Создать папки с ошибками bind
- Отредактировать все пароли и конфиги в env_vars
- запустить контейнер
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
