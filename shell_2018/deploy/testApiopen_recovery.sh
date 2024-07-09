#!/bin/bash -x
# auth niewei
# date 2018-08-21

pro_code=/data/tomcat8085/ROOT
#pro_code=/data/software/test/
code=`curl -s -w "%{http_code}" -o /dev/null http://10.8.0.200:8085/swagger-ui.html`
if [ $code -eq 200 ];then
    echo "服务启动成功。。"
    break 
else
    echo "服务启动失败，正在进行回滚。。"
    back=`ls -lt /data/backup/pecoo-api-open/*.tar.gz | head -1 | awk '{print $NF}'`
    \cp $back /data/backup/pecoo-api-open/apiopen_recovery/pecoo-apiopen-recovry.tar.gz
    rm -rf  $pro_code/*
    tar xf /data/backup/pecoo-api-open/apiopen_recovery/pecoo-apiopen-recovry.tar.gz -C $pro_code
    /home/sh/tomcat8085.sh restart
    echo "服务启动中。。"
    sleep 60
    tail -800 /data/application/tomcat8085/logs/catalina.out
fi

recov_code=`curl -s -w "%{http_code}" -o /dev/null http://10.8.0.200:8085/swagger-ui.html`        
if [ $recov_code -eq 200 ];then
    echo "服务启动成功。。"
else
    echo "服务回滚失败，请联系运维排查问题。。"
fi
