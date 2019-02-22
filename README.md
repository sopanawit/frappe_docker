# Frappe Docker Installation on Windows

## Installation
### 1. Clone frappe_docker & Run docker-compose
```
git clone --branch windows https://github.com/sopanawit/frappe_docker.git
cd .\frappe_docker\
docker-compose up -d
```
 
### 2. Set frappe password as 1q2w3e4r 
```
docker exec -it frappe bash
sudo su
passwd frappe
```
 
### 3. initial frappe-bench and install Time Table Management App
```
docker exec -it frappe bash
./init.sh <url_bitbucket_repo>
```

### 4. Start bench
```
bench start
```
 
### 5. Open Visual Studio Code
```
File > Open Workspace > frappe-bench.code-workspace
```

### 6. Enjoy
