#!/bin/bash
#输出所有 zombie 的进程到 zombie.txt 杀死所有 zombie 进程

ALL_PROCESS=$(ls /proc/ | egrep '[0-9]+')
running_count=0
stoped_count=0
sleeping_count=0
zombie_count=0
for pid in ${ALL_PROCESS[*]}
do
test -f /proc/$pid/status && state=$(egrep "State" /proc/$pid/status | awk
'{print $2}')
case "$state" in
R)
running_count=$((running_count+1))
;;
T)
stoped_count=$((stoped_count+1))
;;
S)
sleeping_count=$((sleeping_count+1))
;;
Z)
zombie_count=$((zombie_count+1))
echo "$pid" >>zombie.txt
kill -9 "$pid"
;;
esac
done
echo -e "total:
$((running_count+stoped_count+sleeping_count+zombie_count))\nrunning:
$running_count\nstoped: $stoped_count\nsleeping: $sleeping_count\nzombie:
$zombie_count"