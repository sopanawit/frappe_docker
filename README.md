# Frappe Docker Installation on Windows

## Installation
### 1. Clone frappe_docker & Run docker-compose
```
git clone https://github.com/frappe/frappe_docker.git
cd .\frappe_docker\
docker-compose up -d
```
 
### 3. Set root frappe bash
```
docker exec -itu root frappe bash
cd /home/frappe/ && chown -R frappe:frappe ./*
```
 
### 4. Initial Frappe App
```
docker exec -it frappe bash
cd /home/frappe/ && bench init frappe-bench
sudo apt update
sudo pip install -e bench-repo
sudo npm install -g yarn
```
 
### 5. Config permission
```
docker exec -it mariadb bash
apt-get -y update
apt-get -y install vim
cd /etc/mysql/
chmod -R 0444 ./conf.d/*
```

### 6. Restart Docker
```
docker-compose restart
```

### 7. Copy default configuration for Frappe app
```
docker exec -it frappe bash
mv Procfile_docker Procfile && mv sites/common_site_config_docker.json sites/common_site_config.json && bench set-mariadb-host mariadb
cp Procfile ../frappe-bench/
cp sites/common_site_config.json ../frappe-bench/sites/
cd /home/frappe/ && sudo chmod -R 777 frappe-bench
```
 
### 8. Create a new site
```
docker exec -it frappe bash
cd /home/frappe/frappe-bench
bench new-site frappe.local
cd /home/frappe/
sudo chown -R frappe:frappe ~/.config
cd /home/frappe/frappe-bench
bench --site frappe.local set-config developer_mode 1
```

# Update Bench
In case of issue occurred, update might help solve some issues.
```
bench update
bench update --patch
bench start
```

# Downgrade Frappe version
If need!
```
docker exec -it frappe bash
cd /home/frappe/frappe-bench/apps/frappe/
git branch -v
git stash
git reset --hard HEAD
git checkout -f <commit-id>
cd /home/frappe/frappe-bench/
bench build && bench migrate && bench restart
```