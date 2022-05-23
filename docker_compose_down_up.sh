#!/usr/bin/env bash
mode=$1
if [[ "$mode" == 'server' ]]; then
  docker-compose -f zabbix-server-docker-compose.yaml down
  docker-compose -f zabbix-server-docker-compose.yaml up -d --build
elif [[ "$mode" == 'web' ]]; then
  docker-compose -f zabbix-web-docker-compose.yaml down
  docker-compose -f zabbix-web-docker-compose.yaml up -d
else
  echo "Option: server, web"
fi
