#!/bin/bash
set -eo pipefail
if [ ! -d /opt/logicaldoc/tomcat ]; then
 printf "Installing LogicalDOC\n"
 j2 /opt/logicaldoc/auto-install.j2 > /opt/logicaldoc/auto-install.xml
 java -jar /opt/logicaldoc/logicaldoc-installer.jar /opt/logicaldoc/auto-install.xml
 /opt/logicaldoc/bin/logicaldoc.sh stop
 /opt/logicaldoc/tomcat/bin/catalina.sh stop
else
 printf "LogicalDOC already installed\n"
fi

case $1 in
run)     echo "run";
	 /opt/logicaldoc/bin/logicaldoc.sh run
         ;;
start)   echo "start";
	 /opt/logicaldoc/bin/logicaldoc.sh start
         ;;
stop)    echo "STOOP!!!";
         /opt/logicaldoc/bin/logicaldoc.sh stop
         ;;
*) /opt/logicaldoc/bin/logicaldoc.sh $1
   ;;
esac


