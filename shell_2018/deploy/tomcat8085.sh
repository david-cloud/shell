#!/bin/bash
#auth niewei
#date 2018-8-7

TOMCAT_PATH=/data/application/tomcat8085
usage() {
	echo "Uasge $0 [start|stop|status|restart]"
}

status_tomcat() {
	ps aux | grep java | grep tomcat8085 | grep -v 'grep'
}

start_tomcat() {
	/data/application/tomcat8085/bin/startup.sh
}

stop_tomcat() {
	/data/application/tomcat8085/bin/shutdown.sh	
	sleep 3;
	ps aux | grep java | grep tomcat8085 | grep -v 'grep' | awk '{print "kill -9",$2}' | bash
	curl -XDELETE 'http://10.8.0.206:9001/eureka/apps/PECOO-API-OPEN/Pecoo_web_test:pecoo-api-open:8085'
cd $TOMCAT_PATH
rm -rf temp/*
rm -rf work/*
}

main() {
case $1 in
	start)
	    start_tomcat;;
	stop)
	    stop_tomcat;;
	status)
	    status_tomcat;;
	restart)
	    stop_tomcat && start_tomcat;;
	*)
	    usage;
esac
}

main $1
