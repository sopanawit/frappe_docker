# Frappe Docker Installation on Windows
This branch is for developer who want to develop Frappe framework on Windows environment using Docker.

## Limitation
Volume mapping is not working for Frappe because bench must run on non-root user and volume mapping on Windows can not be assigned to a non-root user. (always root with 0777 permission)

## Prerequsite
Docker Desktop (recommanded) or Docker Toolbox

## Installation
### 1. Clone frappe_docker into your local drive & build container via docker-compose
```
C:\Users\<user>\<path>> git clone --branch windows https://github.com/sopanawit/frappe_docker.git
C:\Users\<user>\<path>> cd .\frappe_docker\
C:\Users\<user>\<path>\frappe_docker> docker-compose up -d
```

### 2. Initial frappe site and setup config using init.sh
init.sh is a bash script that will help you to create site as frappe.local and setup frappe configuration to use docker environment. If you have other application that you want to install for development, provide repository url and application name along with init.sh (optional)
```
C:\Users\<user>\<path>\frappe_docker> docker exec -it frappe bash
frappe:~/frappe-bench$ ./init.sh <repository_url> <app_name>
```

### 3. (Optional) In case of you are want to use previous version of frappe, you can change its version with instruction below. Anyway, you need to prepare a commit Id of frappe version that you need like `ef7cb64fb`.
```
frappe:~/frappe-bench$ cd apps/frappe
frappe:~/frappe-bench/apps/frappe$ git checkout -b <new_branch_name> <commit-id>
```
Then, new frappe version have to compile before bench start, delete *.pyc in apps/ to prevent an eror while migrating database schemas.
```
frappe:~/frappe-bench/apps/frappe$ cd ../../
frappe:~/frappe-bench$ bench build
frappe:~/frappe-bench$ find . -name *.pyc -delete
frappe:~/frappe-bench$ bench migrate
Success: Done in 0.192s
Updating DocTypes for frappe        : [========================================]
Syncing help database...
```

### 4. Everything all set, let start bench
```
bench start
```
Bench will listen requests on port 8000. To access a site via web browser, find your IP address using `docker inspect frappe` and look for IPv4 then press your IP into web browser <ip_address:8000> 

## Develop frappe application/modules in develop branch (remote origin)
After get-app, you will always get a remote upstream which is for production environment. This is the way to change to remote origin.
```
frappe:~/frappe-bench$ cd apps/<app_name>
frappe:~/frappe-bench/apps/<app_name>$ git remote remove upstream
frappe:~/frappe-bench/apps/<app_name>$ git remote add origin <repository_url>
frappe:~/frappe-bench/apps/<app_name>$ git fetch origin <branch_name> && git pull
frappe:~/frappe-bench/apps/<app_name>$ git checkout origin <branch_name>
```
To prevent database migration error, don't forget to remove *.pyc before execute `bench migrate`

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
