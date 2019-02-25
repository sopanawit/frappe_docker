#!/bin/bash

set -e

ask_backup() {
    read -p "Delete old backup [y/n]:" decision
}

echo "Backup frappe-bench."
if [[ -d "frappe-bench-backup" ]]; then
    echo "Backup folder is already exists!"

    ask_backup
    while [[ $decision != 'y' ]] && [[ $decision != 'n' ]]; do
        ask_backup
    done
    if [[ $decision = 'y' ]]; then
        rm -rf frappe-bench-backup
        cp -r frappe-bench frappe-bench-backup
    fi
else
    cp -r frappe-bench frappe-bench-backup
fi

echo "Init frappe directory..."
cd ../ && bench init frappe-bench --ignore-exist --skip-redis-config-generation
cd frappe-bench

echo "Seting up configurations to Docker environment..."
mv Procfile_docker Procfile && mv sites/common_site_config_docker.json sites/common_site_config.json
bench set-mariadb-host mariadb

echo "Create new site frappe.local"
bench new-site frappe.local

if [[ $1 != '' ]] && [[ $2 != '' ]]; then
    echo "Installing app $2 from $1"
    bench get-app $1
    bench --site frappe.local install-app $2
fi

echo "You are all set, try >> bench start"