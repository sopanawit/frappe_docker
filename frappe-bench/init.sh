#!/bin/bash

if [[ $1 = '' ]]; then 
    echo "Please input Bitbucket Url of Time Table Management"
    echo "https://<username>@bitbucket.org/facgure/siph-time-table.git"
    exit
fi

cd ../ && bench init frappe-bench --ignore-exist --skip-redis-config-generation
cd frappe-bench

mv Procfile_docker Procfile && mv sites/common_site_config_docker.json sites/common_site_config.json
bench set-mariadb-host mariadb
bench new-site siph.local
bench get-app $1
bench switch-to-develop
bench update --patch

cd apps/time_table_management && git remote add origin $1
git fetch origin develop && git pull
git checkout origin develop
cd ../../

bench --site siph.local install-app time_table_management

echo "You are ready to develop Time Table Management, try >> bench start"