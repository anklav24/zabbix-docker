#!/usr/bin/env bash
docker-compose -f zabbix-web-docker-compose.yaml down
docker-compose -f zabbix-web-docker-compose.yaml up -d
