#!/bin/bash -x
#auth niewei
#date 2018-8-23

# 测试后台 pecoo api search  jenkins自动部署
src_code=/data/software/src_code
#umc_code=$src_code/pecoo-service-umc-master
#bid_code=$src_code/pecoo-service-bid-master
#coin_code=$src_code/pecoo-service-coin-master
#pmc_code=$src_code/pecoo-service-pmc-master
#rms_code=$src_code/pecoo-service-rms-master
#wallet_code=$src_code/pecoo-service-wallet-master
common_code=$src_code/pecoo-common
parent_code=$src_code/pecoo-parent
basic_code=/data/software/src_code/basic-master
#api_code=$src_code/pecoo-api
api_search_code=$src_code/pecoo-api-search
compiled_code=$api_search_code/target/pecoo-api-search

pro_code=/data/tomcat8084/ROOT/
#pro_code=/data/software/test
back_code=/data/software/back_code/api_search

compile_code() {
if [ -d $1 ];then
   cd $1
   mvn clean
   git pull
   if [ $? -eq 0 ];then
       echo "代码更新成功。。"
   else
       echo "代码更新失败，请检查vpn网络。。"
       exit 1
   fi
   
   mvn install -Ptest -DskipTest
   if [ $? -eq 0 ];then
       echo -e "\033[31;49;1m $2 编译成功。。 \033[39;49;0m"
   else
       echo -e "\033[31;49;1m $2 编译失败。。 \033[39;49;0m"
       exit 2
   fi
else
   cd $src_code
   git clone http://10.8.0.100/pecoo/code/java/$2.git
   if [ $? -eq 0 ];then
       echo "代码下载成功。。"
   else
       echo "代码下载失败，请检查vpn网络。。"
       exit 1
   fi
   cd $1
   mvn clean
   mvn install -Ptest -DskipTest
   if [ $? -eq 0 ];then
       echo -e "\033[31;49;1m $2 编译成功。。 \033[39;49;0m"
   else
       echo -e "\033[31;49;1m $2 编译失败。。 \033[39;49;0m"
       exit 3
   fi
fi
}
rm -rf /root/.m2/repository/com/basic/
rm -rf /root/.m2/repository/com/pecoo/
compile_code $basic_code basic-master
compile_code $parent_code pecoo-parent
#compile_code $common_code pecoo-common
#compile_code $umc_code pecoo-service-umc-master
#compile_code $rms_code pecoo-service-rms-master
#compile_code $bid_code pecoo-service-bid-master
compile_code $api_search_code pecoo-api-search


if [ -d $compiled_code ];then
    cd $pro_code
    tar zcvf /data/software/back_code/api_search/pecoo-api_search_`date +%Y-%m-%d-%T`.tar.gz ./*
    if [ $? -eq 0 ];then
        echo "代码备份完成。。"
    else
        echo "代码备份失败,请检查文件备份。。"
        exit 4
    fi
    rm -rf $pro_code/*
    cp -rf $compiled_code/* $pro_code
    sleep 2
    /home/sh/tomcat8084.sh restart
    ls -t /data/software/back_code/api_search/*.tar.gz |awk 'NR > 15' |xargs rm -rf
    echo "服务启动中。。"
    sleep 60
    tail -800 /data/application/tomcat8084/logs/catalina.out
else
    echo "编译代码未找到，请检测maven编译的代码。。"
    exit 5
fi

# 检测 服务是否启动成功，若启动失败则进行回滚
/home/sh/pecoo-api-search_recovery.sh
