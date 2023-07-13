#!/bin/bash

build_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

# Load .env
set -a; . "${build_dir}/.env"; set +a

cd "${build_dir}"
docker-compose stop cashmanager-api

# Start the cashmanager
cd "${build_dir}"
docker-compose up --build -d cashmanager-api