#!/bin/bash

build_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

# Load .env
set -a; . "${build_dir}/.env"; set +a

# Stop containers
cd "${build_dir}"
docker-compose down -v

# Start sql container and wait for the database
cd "${build_dir}"
docker-compose up --build -d cashmanager-mysql
while [ "$cashmanager" != "cashmanager" ]; do cashmanager=$(mysql -h 127.0.0.1 -P "$DATABASE_PORT" -u"$DATABASE_USER" -p"$DATABASE_PASSWORD" -e "SHOW databases;" | grep cashmanager) || sleep 1 && echo -n "."; done

# Start the cashmanager
cd "${build_dir}"
docker-compose up --build -d cashmanager-api