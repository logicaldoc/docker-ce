# LogicalDOC Document Management System ( https://www.logicaldoc.com )
FROM openjdk:15-jdk-alpine

LABEL maintainer="LogicalDOC <packagers@logicaldoc.com>"

# set default variables for LogicalDOC install
ENV LDOC_VERSION="8.3.4"
ENV LDOC_MEMORY="2000"
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

# Packages needed to install LogicalDOC CE
RUN apk add \
    bash \
    curl \    
    unzip \    
    imagemagick \
    ghostscript \
    py3-jinja2 \
    py3-pip \
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
RUN pip3 install j2cli

#volumes for persistent storage
VOLUME /opt/logicaldoc/conf
VOLUME /opt/logicaldoc/repository

EXPOSE 8080

CMD ["/opt/logicaldoc/start-logicaldoc.sh", "run"]
