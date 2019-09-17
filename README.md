[![Docker pulls](https://img.shields.io/docker/pulls/logicaldoc/logicaldoc-ce.svg?maxAge=3600)](https://hub.docker.com/r/logicaldoc/logicaldoc-ce/) [![Docker Stars](https://img.shields.io/docker/stars/logicaldoc/logicaldoc-ce.svg?maxAge=3600)](https://hub.docker.com/r/logicaldoc/logicaldoc-ce/) [![Docker layers](https://images.microbadger.com/badges/image/logicaldoc/logicaldoc-ce.svg)](https://microbadger.com/images/logicaldoc/logicaldoc-ce.svg) [![Docker version](https://images.microbadger.com/badges/version/logicaldoc/logicaldoc-ce.svg)](https://microbadger.com/images/logicaldoc/logicaldoc-ce) ![License](https://img.shields.io/badge/License-LGPL%20v3-green.svg?maxAge=3600)

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

**Start a LogicalDOC instance linked to a MySQL container**
1. Run the MySQL container
```Shell
docker run -d --name=mysql-ld --env="MYSQL_ROOT_PASSWORD=mypassword" --env="MYSQL_DATABASE=logicaldoc" --env="MYSQL_USER=ldoc" --env="MYSQL_PASSWORD=changeme" mysql:8.0
```

2. Run the LogicalDOC container
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

## Persistence of configuration and documents
Start as a daemon with attached volumes to persist the configuration and the documents
```console
$ docker run -d --name logicaldoc-ce --restart=always -p 8080:8080 -v logicaldoc-conf:/opt/logicaldoc/conf -v logicaldoc-repo:/opt/logicaldoc/repository --link mysql-ld logicaldoc/logicaldoc-ce
```

All document files will be stored in the volume ``logicaldoc-repo``, the configuration files insead are in volume ``logicaldoc-conf`

In this case the physical location of the ``logicaldoc-conf`` volume is ``/var/lib/docker/volumes/logicaldoc-conf/_data`` while the location of ``logicaldoc-repo`` volume is ``/var/lib/docker/volumes/logicaldoc-repo/_data``


## Environment Variables
The LogicalDOC image uses environment variables that allow to obtain a more specific setup.

* **LDOC_MEMORY**: memory allocated for LogicalDOC expressed in MB (default is 2000)
* **DB_ENGINE**: the database type, possible vaues are: mysql(default), mssql, oracle, postgres
* **DB_HOST**: the database server host (default is 'mysql-ld')
* **DB_PORT**: the database communication port (default is 3306)
* **DB_NAME**: the database name (default is 'logicaldoc')
* **DB_INSTANCE**: some databases require the instance specification
* **DB_USER**: the username (default is 'ldoc')
* **DB_PASSWORD**: the password (default is 'changeme')
* **DB_MANUALURL**: must be true when using DB_URL (default is 'false')
* **DB_URL**: the jdbc url to connect to the database (remember to set DB_MANUALURL to 'true')

## Using Oracle or MS SQL as Database engine
At the following address you can find some examples of this container configured to use Oracle Database or MS SQL (Microsoft SQL server).
Also, in some of these examples the DB_URL and DB_MANUALURL properties are explicitly used for database configuration

https://wiki.logicaldoc.com/wiki/Docker

## Stopping and starting the container
Assuming that you have assigned the "logicaldoc-ce" alias to the container

To stop the container use:

```console
$ docker stop logicaldoc-ce
```

To start the container again:

```console
$ docker start logicaldoc-ce
```

## Configuration
(You must have enabled data persistence with volume assignment)

To edit the settings file, check the physical location of the ``logicaldoc-conf`` volume using:

```console
$ docker volume inspect logicaldoc-conf
```

Which should produce an output similar to this one:

```console
    [
        {
            "Name": "logicaldoc-conf",
            "Driver": "local",
            "Mountpoint": "/var/lib/docker/volumes/logicaldoc-conf/_data",
            "Labels": null,
            "Scope": "local"
        }
    ]
```
In this case the physical location of the ``logicaldoc-conf`` volume is ``/var/lib/docker/volumes/logicaldoc-conf/_data``.

## Performing backups

To backup the existing data, check the physical location of the ``logicaldoc-conf`` and ``logicaldoc-repo`` volumes using:

```console
$ docker volume inspect logicaldoc-conf
```

Which should produce an output similar to this one:

```console
    [
        {
            "Name": "logicaldoc-conf",
            "Driver": "local",
            "Mountpoint": "/var/lib/docker/volumes/logicaldoc-conf/_data",
            "Labels": null,
            "Scope": "local"
        }
    ]
```

```console
$ sudo tar -zcvf backup.tar.gz /var/lib/docker/volumes/logicaldoc-conf/_data /var/lib/docker/volumes/logicaldoc-repo/_data
$ sudo chown `whoami` backup.tar.gz
```

If an external PostgreSQL or MySQL database or database containers, these too need to be backed up using their respective procedures.


## Restoring from a backup

Uncompress the backup archive in the original docker volume using:

```console
$ sudo tar -xvzf backup.tar.gz -C /
```

## Building the image

Clone the repository with:

```console
$ git clone https://github.com/logicaldoc/logicaldoc-ce.git
```

Change to the directory of the cloned repository:

```console
$ cd logicaldoc-ce
```

Execute Docker's build command:

```console
$ docker build -t logicaldoc/logicaldoc-ce .
```

Or using an apt cacher to speed up the build:

```console
$ docker build -t logicaldoc/logicaldoc-ce --build-arg APT_PROXY=172.18.0.1:3142 .
```

Replace the IP address `172.18.0.1` with the IP address of the Docker host used from which these commands are running.

## Testing

Start a Vagrant box from the include Vagrant file. This Vagrant box will builds the Docker image and then start a container:

```console
$ vagrant up
```

Create the same Vagrant box using an apt cacher to speed up the build:

```console
$ APT_PROXY=172.18.0.1:3142 vagrant up
```

Replace the IP address `172.18.0.1` with the IP address of the Docker host used from which these commands are running.

## Using Docker compose

To deploy a complete production stack using the included Docker compose file execute:

```console
$ docker-compose -f docker-compose.yml up -d
```

This Docker compose file will provision 2 containers:

- MySQL as the database
- LogicalDOC CE using the above service container

To stop the stack use:

```console
$ docker-compose -f docker-compose.yml stop
```

The stack will also create three volumes to store the data of each container. These are:

- ldoc_conf - The LogicalDOC configuration container, normally called `logicaldoc-conf` when not using Docker compose.
- ldoc_repository - The LogicalDOC DMS data container for documents and search indexes, normally called `logicaldoc-repo` when not using Docker compose.
- ldoc_db - The database volume, in this case MySQL.

### Stopping and starting with Docker compose 

To stop the services use:

```console
$ docker-compose -f docker-compose.yml stop
```

To start the services again:

```console
$ docker-compose -f docker-compose.yml start
```

To remove the stopped containers:

```console
$ docker-compose -f docker-compose.yml rm -v
```

Destroys the containers and all the created volumes:

```console
$ docker-compose -f docker-compose.yml down -v
```


### Docker compose examples
Some docker-compose examples are available in the repository of this container on GitHub https://github.com/logicaldoc/logicaldoc-ce

## ... via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `stack.yml` for `logicaldoc-ce`:

```yaml
version: "3.1"

services:

  logicaldoc:
    depends_on:
      - mysql-ld
    command: ["./wait-for-it.sh", "mysql-ld:3306", "-t", "30", "--", "/opt/logicaldoc/start-logicaldoc.sh", "run"]
    image: logicaldoc/logicaldoc-ce
    ports:
      - 8080:8080
    environment:
      - LDOC_MEMORY=2000

  mysql-ld: 
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=example
      - MYSQL_DATABASE=logicaldoc
      - MYSQL_USER=ldoc
      - MYSQL_PASSWORD=changeme
      
```

[![Try in PWD](https://github.com/play-with-docker/stacks/raw/cff22438cb4195ace27f9b15784bbb497047afa7/assets/images/button.png)](http://play-with-docker.com?stack=https://raw.githubusercontent.com/logicaldoc/logicaldoc-ce/master/stack.yml)

Run `docker stack deploy -c stack.yml logicaldocce` , wait for it to initialize completely, and visit `http://swarm-ip:8080`, `http://localhost:8080`, or `http://host-ip:8080` (as appropriate).

## Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version `1.3.0` or higher you can access a running containers shell by starting `bash` using `docker exec`.

Assuming that you have assigned the "logicaldoc-ce" alias to the container:

```bash
docker exec -it logicaldoc-ce bash
```





