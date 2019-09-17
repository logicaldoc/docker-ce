# LogicalDOC Document Management System ( https://www.logicaldoc.com )
FROM openjdk:11-jdk

MAINTAINER LogicalDOC <packagers@logicaldoc.com>

# set default variables for LogicalDOC install
ENV LDOC_VERSION="8.3.2"
ENV LDOC_MEMORY="2000"
ENV DEBIAN_FRONTEND="noninteractive"
ENV CATALINA_HOME="/opt/logicaldoc/tomcat"
ENV DB_ENGINE="mysql"
ENV DB_HOST="mysql-ld"
ENV DB_PORT="3306"
ENV DB_NAME="logicaldoc"
ENV DB_INSTANCE=""
ENV DB_USER="ldoc"
ENV DB_PASSWORD="changeme"
ENV DB_MANUALURL="false"
ENV DB_URL=""


RUN mkdir /opt/logicaldoc
COPY start-logicaldoc.sh /opt/logicaldoc
COPY auto-install.j2 /opt/logicaldoc
COPY wait-for-it.sh /
COPY wait-for-postgres.sh /

# prepare system for java installation (to be removed)
RUN apt-get update && \
  apt-get -y install software-properties-common

# Packages needed to install LogicalDOC CE
RUN apt-get -y install \
    curl \    
    unzip \    
    imagemagick \
    ghostscript \
    python-jinja2 \
    python-pip \
    mysql-client \
    postgresql-client \
    vim \
    nano

# Download and unzip LogicalDOC CE installer 
RUN curl -L https://sourceforge.net/projects/logicaldoc/files/distribution/LogicalDOC%20CE%208.3/logicaldoc-community-installer-${LDOC_VERSION}.zip/download \
    -o /opt/logicaldoc/logicaldoc-community-installer-${LDOC_VERSION}.zip && \
    unzip /opt/logicaldoc/logicaldoc-community-installer-${LDOC_VERSION}.zip -d /opt/logicaldoc && \
    rm /opt/logicaldoc/logicaldoc-community-installer-${LDOC_VERSION}.zip

#COPY logicaldoc-community-installer-${LDOC_VERSION}.zip /opt/logicaldoc/
#RUN unzip /opt/logicaldoc/logicaldoc-community-installer-${LDOC_VERSION}.zip -d /opt/logicaldoc && \
#	rm /opt/logicaldoc/logicaldoc-community-installer-${LDOC_VERSION}.zip

# Install j2cli for the transformation of the templates (Jinja2)
RUN pip install j2cli

#volumes for persistent storage
VOLUME /opt/logicaldoc/conf
VOLUME /opt/logicaldoc/repository

EXPOSE 8080

CMD ["/opt/logicaldoc/start-logicaldoc.sh", "run"]
