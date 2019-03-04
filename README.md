# Frappe Docker Installation on Windows
This branch is for developer who want to develop Frappe framework on Windows environment using Docker.

## Limitation
Volume mapping is not working for Frappe because bench must run on non-root user and volume mapping on Windows can not be assigned to a non-root user. (always root with 0777 permission)

## Prerequsite
Docker Desktop (recommended) or Docker Toolbox

## Installation
### 1. Clone frappe_docker into your local drive & build container via docker-compose
```
C:\Users\<user>\<path>> git clone --branch windows https://github.com/sopanawit/frappe_docker.git
C:\Users\<user>\<path>> cd .\frappe_docker\
C:\Users\<user>\<path>\frappe_docker> docker-compose up -d
```
For __Docker Toolbox__ users, there's a little bit more things to do
```
C:\Users\<user>\<path>> docker exec -it mariadb bash
root:/# apt-get -y update && apt-get -y install vim
root:/# cd /etc/mysql
root:/etc/mysql# vim my.cnf
```
Add following configurations into __[mysqld]__ and __[mysql]__ sections
```
[mysqld]
innodb-file-format=barracuda
innodb-file-per-table=1
innodb-large-prefix=1
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4
```
Then, __exit__ and execute `docker-compose restart`

### 2. Initial frappe site and setup system config
Use bench command to initial application and website directory for Frappe framework.
Use option `--frappe-path` and `--frappe-branch` aling with `bench init` to specific repository and branch. (optional)
```
C:\Users\<user>\<path>\frappe_docker> docker exec -it frappe bash
frappe:~/frappe-bench$ cd ../
frappe:~$ bench init frappe-bench --ignore-exist --skip-redis-config-generation --frappe-path=<repository_url> --frappe-branch=<branch_name>
frappe:~$ cd frappe-bench
frappe:~/frappe-bench$ mv Procfile_docker Procfile && mv sites/common_site_config_docker.json sites/common_site_config.json
bench set-mariadb-host mariadb
```

### 3. Everything all set, let start bench
```
bench start
```
Bench will listen requests on port 8000. To access a site via web browser, find your IP address using `docker inspect frappe` and look for IPv4 then press your IP into web browser <ip_address:8000> 

## Develop frappe application/modules in develop branch (remote origin)
After get-app, you will always get a remote upstream which is for production environment. This is the way to change to remote origin.
```
frappe:~/frappe-bench$ cd apps/<app_name>
frappe:~/frappe-bench/apps/<app_name>$ git remote -v
frappe:~/frappe-bench/apps/<app_name>$ git remote remove upstream
frappe:~/frappe-bench/apps/<app_name>$ git remote add origin <repository_url>
frappe:~/frappe-bench/apps/<app_name>$ git remote -v
frappe:~/frappe-bench/apps/<app_name>$ git fetch origin <branch_name> && git pull
frappe:~/frappe-bench/apps/<app_name>$ git checkout <branch_name>
frappe:~/frappe-bench/apps/<app_name>$ git status
```

## Development using Remote Workspace
This branch provide frappe-bench.code-workspace for develop source code using remote protocol with `Visual Studio Code`.

## Prerequsite
1. Visual Studio Code
2. Remote Workspace Extension for VS code

## Setup frappe password for acess into frappe container via SSH protocol.
Password that defined in `frappe-bench.code-workspace` is __1q2w3e4r__ but if you want to use you own password, workspace file must be fixed.
```
C:\Users\<user>\<path>\frappe_docker> docker exec -it frappe bash
frappe:~/frappe-bench$ sudo su
frappe:~/frappe-bench$ passwd frappe
Enter new UNIX password:
Retype new UNIX password:
passwd: password updated successfully
```

## Open workspace file with VS code
```
File > Open Workspace > frappe-bench.code-workspace
```
