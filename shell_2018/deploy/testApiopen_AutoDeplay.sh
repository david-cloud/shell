#!/bin/bash -x
#auth niewei
#date 2018-8-7

# 测试后台 testapi jenkins自动部署
#src_code=/data/src_demo/workspace
src_code=/data/software/src_code
common_code=$src_code/pecoo-common        #添加git项目名字
luxury_code=$src_code/pecoo-service-luxury-master/pecoo-service-luxury-facade
parent_code=/data/software/src_code/pecoo-parent/
bid_code=$src_code/pecoo-service-bid-master/pecoo-service-bid-facade
api_code=$src_code/pecoo-api-open
basic_code=/data/software/src_code/basic-master
compiled_code=$api_code/target/pecoo-api-open
war_code=/data/src_demo/workspace/pecoo-api-open/target

pro_code=/data/tomcat8085/ROOT/
#pro_code=/data/software/test
back_code=/data/backup/pecoo-api-open


mkdirdata(){
	mkdir -p $src_code
	mkdir -p $common_code
	mkdir -p $parent_code
	mkdir -p $api_code
	mkdir -p $compiled_code
}

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

mkdirdata
rm -rf /root/.m2/repository/com/basic/
rm -rf /root/.m2/repository/com/pecoo/
compile_code $basic_code basic-master
compile_code $parent_code pecoo-parent
#compile_code $common_code pecoo-common
#compile_code $bid_code pecoo-service-bid-master
#compile_code $luxury_code pecoo-service-luxury-master
compile_code $api_code pecoo-api-open


if [ -d $compiled_code ];then
    cd $pro_code
	tar zcvf /data/backup/pecoo-api-open/pecoo-api-open-$(date +%F%n).tar.gz ./* 
    if [ $? -eq 0 ];then
        echo "代码备份完成。。"
    else
        echo "代码备份失败,请检查文件备份。。"
        exit 4
    fi
    rm -rf $pro_code/*
    cp -rf $compiled_code/* $pro_code

    sleep 2
    /home/sh/tomcat8085.sh restart
    ls -t $back_code/*.tar.gz |awk 'NR > 15' |xargs rm -rf
    echo "服务启动中。。"
    sleep 60
    tail -800 /data/application/tomcat8085/logs/catalina.out
else
    echo "编译代码未找到，请检测maven编译的代码。。"
    exit 5
fi

# 检测 服务是否启动成功，若启动失败则进行回滚
/home/sh/testApiopen_recovery.sh

IP=` hostname -I | cut -b 23-33`
master=pecoo-api-open
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "本环境为$IP 项目为$master"
