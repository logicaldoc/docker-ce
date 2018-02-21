# LogicalDOC Community Edition (AKA LogicalDOC CE)
A repository for LogicalDOC DMS - Community Edition - Docker image https://www.logicaldoc.com/download-logicaldoc-community
Note: This image requires to be connected to an external database

## What is LogicalDOC CE?
LogicalDOC Community Edition (AKA LogicalDOC CE) is an open-source document management software platform.
By leveraging on the best-of-breed Java frameworks, it creates a flexible and powerful document management platform, which thanks to the most advanced presentation technology (Google GWT), is able to meet the needs of usability and more demanding management.
LogicalDOC is both document management and collaboration system. The software is loaded with many functions and allows organizing, index, retrieving, controlling and distributing important business documents securely and safely for any organization and individual.

Check out https://www.logicaldoc.com to learn more.

The design of LogicalDOC is based on best-of-breed Java technologies in order to provide a reliable DMS platform. The main interface is Web-based, no need to install anything else; users can access the system through their browser. 
LogicalDOC CE is 100% free software, supports all major DBMS and this particular distribution installation can be used with MySQL, MariaDB and PostreSQL 
  

![LogicalDOC CE](https://www.logicaldoc.com/images/assets/LogicalDocWhiteH02-167.png)

* **SourceForge project**: https://sourceforge.net/projects/logicaldoc/
* **Manuals**: http://docs.logicaldoc.com   
* **Forums**: http://forums.logicaldoc.com

### How to use this image

## Start a LogicalDOC instance linked to a MySQL container
### 1) Run the MySQL container
```Shell
docker run -d --name=mysql-ld --env="MYSQL_ROOT_PASSWORD=mypassword" --env="MYSQL_DATABASE=logicaldoc" --env="MYSQL_USER=ldoc" --env="MYSQL_PASSWORD=changeme" mysql
```

### 2) Run the LogicalDOC container
```Shell
docker run -d -p 8080:8080 --link mysql-ld logicaldoc/logicaldoc-ce
```

This image includes EXPOSE 8080 (the logicaldoc port). The default LogicalDOC configuration is applied.

Then, access it via `http://localhost:8080` or `http://host-ip:8080` in a browser. Default User and Password are **admin** / **admin**.

## Start a LogicalDOC with some settings
```Shell
docker run -d -p 8080:8080 --env LDOC_MEMORY=4000 --link mysql-ld logicaldoc/logicaldoc-ce
```
This will run the same image as above but with 4000 MB memory allocated to LogicalDOC.

Then, access it via `http://localhost:8080` or `http://host-ip:8080` in a browser.

If you'd like to use an external database instead of a linked `mysql-ld` container, specify the hostname with `DB_HOST` and port with `DB_PORT` along with the password in `DB_PASSWORD` and the username in `DB_USER` (if it is something other than `ldoc`):

```console
$ docker run -d -p 8080:8080 -e DB_HOST=10.1.2.3 -e DB_PORT=3306 -e DB_USER=... -e DB_PASSWORD=... logicaldoc/logicaldoc-ce
```

## Environment Variables
The LogicalDOC image uses environment variables that allow to obtain a more specific setup.

* **LDOC_MEMORY**: memory allocated for LogicalDOC expressed in MB (default is 2000)
* **DB_ENGINE**: the database type, possible vaues are: mysql(default), postgres
* **DB_HOST**: the database server host (default is 'mysql-ld')
* **DB_PORT**: the database communication port (default is 3306)
* **DB_NAME**: the database name (default is 'logicaldoc')
* **DB_INSTANCE**: some databases require the instance specification
* **DB_USER**: the username (default is 'ldoc')
* **DB_PASSWORD**: the password (default is 'changeme')

## Docker-Compose
Some docker-compose examples are available in the repository of this container on GitHub https://github.com/logicaldoc/logicaldoc-ce

## ... via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `stack.yml` for `logicaldoc-ce`:

```yaml
version: '3.1'

services:

  logicaldoc:
    depends_on:
      - mysql-ld  
    image: logicaldoc/logicaldoc-ce
    restart: always
    ports:
      - 8080:8080
    environment:
      - LDOC_MEMORY: 2000

  mysql-ld:
    image: mysql:5.7
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD: example
      - MYSQL_DATABASE: logicaldoc
      - MYSQL_USER: ldoc
      - MYSQL_PASSWORD: changeme
      
```

[![Try in PWD](https://github.com/play-with-docker/stacks/raw/cff22438cb4195ace27f9b15784bbb497047afa7/assets/images/button.png)](http://play-with-docker.com?stack=https://raw.githubusercontent.com/logicaldoc/logicaldoc-ce/master/stack.yml)

Run `docker stack deploy -c stack.yml logicaldoc` (or `docker-compose -f stack.yml up`), wait for it to initialize completely, and visit `http://swarm-ip:8080`, `http://localhost:8080`, or `http://host-ip:8080` (as appropriate).




