# LogicalDOC Document Management System ( https://www.logicaldoc.com )
FROM ubuntu:16.04

MAINTAINER "Alessandro Gasparini" <devel@logicaldoc.com>

# set default variables for LogicalDOC install
ENV LDOC_VERSION="7.7.3"
ENV LDOC_MEMORY="2000"
ENV DEBIAN_FRONTEND="noninteractive"
ENV CATALINA_HOME="/opt/logicaldoc/tomcat"
ENV JAVA_HOME="/usr/lib/jvm/java-8-oracle/"
ENV DB_ENGINE="mysql"
ENV DB_DBHOST="mysql-ld"
ENV DB_PORT="3306"
ENV DB_NAME="logicaldoc"
ENV DB_INSTANCE=""
ENV DB_USER="ldoc"
ENV DB_PASSWORD="changeme"
ENV DB_MANUALURL="false"


RUN mkdir /opt/logicaldoc
ADD start-logicaldoc.sh /opt/logicaldoc
ADD auto-install.j2 /opt/logicaldoc
ADD wait-for-it.sh /

RUN chmod +x /opt/logicaldoc/start-logicaldoc.sh

# prepare system for mysql installation
#RUN apt-get update && apt-get upgrade -y
RUN apt-get update
RUN apt-get install -y perl pwgen --no-install-recommends 

# prepare system for java installation
RUN apt-get -y install software-properties-common python-software-properties

# install oracle java
RUN \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer

# some required software for LogicalDOC plugins
RUN apt-get -y install \
    imagemagick \
    ghostscript \
    curl \
    mysql-client \
    unzip

#ADD logicaldoc-community-installer-7.7.3.zip /opt/logicaldoc

# Download and unzip logicaldoc installer 
RUN curl -L https://sourceforge.net/projects/logicaldoc/files/distribution/LogicalDOC%20CE%207.7/logicaldoc-community-installer-${LDOC_VERSION}.zip/download \
    -o /opt/logicaldoc/logicaldoc-community-installer-${LDOC_VERSION}.zip  && \
    unzip /opt/logicaldoc/logicaldoc-community-installer-${LDOC_VERSION}.zip -d /opt/logicaldoc && \
    rm /opt/logicaldoc/logicaldoc-community-installer-${LDOC_VERSION}.zip

RUN apt-get -y install python-jinja2 python-pip
RUN pip install j2cli

#volumes for persistent storage
VOLUME /opt/logicaldoc/conf
VOLUME /opt/logicaldoc/repository

EXPOSE 8080

CMD ["/opt/logicaldoc/start-logicaldoc.sh", "run"]
