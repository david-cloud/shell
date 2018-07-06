#!/bin/bash
# date:2018.6.5
# neiwei

ss -antlp | grep 27017
if [ $? == 0 ];then
	echo 'mongo is starting..'
else
	mongod --dbpath=/data/mongodb/db --logpath=/data/mongodb/logs/mongodb.log  --fork
fi
