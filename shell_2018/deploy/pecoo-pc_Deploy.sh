#!/bin/bash
#auth:wangyufeng
#time:2018-09-11


mkdirdata(){
Pc_code=/data/src_demo/Pc_code
back_code=/data/backup/Pc_code
master_code=/data/PCweb
}


git_clone(){
	cd $Pc_code
	git clone http://10.8.0.100/pecoo/code/h5/pecoo_pc.git
	if [ $? -ne 0 ];then
		cd $Pc_code/pecoo_pc
			git pull
	else
		echo 请检查git仓库和vpn连通性
		exit 1
	fi
}

git_clone 

mkdirdata

cd $master_code

tar zcvf PCweb`date +%Y-%m-%d-%T`.tar.gz ./*

mv PCweb*.tar.gz $back_code

if [ -f $master_code/dist.zip ];then
		rm -rf $master_code/dist.zip
else
	echo "dist.zip is lost"
	exit 2
fi
	
if [ -f $Pc_code/pecoo_pc/dist.zip ];then
	echo 目录已经生成
	/bin/mv $Pc_code/pecoo_pc/dist.zip $master_code/ 
	cd master_code/
	unzip dist.zip
else
	echo 目录没有生成请检查代码
fi


