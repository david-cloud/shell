#!/bin/bash
#date: 2018-6-12
#auth: niewei

name=svn
pass=123456
ping 10.8.0.1 -c 3
if [ $? -eq 0 ];then
	echo "网络正常..."
	exit
else
	echo "网络异常，重新启动中..."
	ps aux | grep openvpn | grep -v 'grep' | awk '{print "kill -9",$2}' | bash
fi

vpn_home=`find / -name 'client.ovpn' -exec dirname {} \;`
cd ${vpn_home}
/usr/bin/expect <<-EOF
spawn  /usr/sbin/openvpn client.ovpn
expect {
	"Username:" { send "$name\r"; exp_continue }
	"Password:" { send "$pass\r" };
}
sleep 5
expect eof
EOF

sleep 5
#邮件通知
ping 10.8.0.1 -c 3
if [ $? -eq 0 ];then
	echo "网络已恢复"
else
#	sh /root/shell/sendmial.sh
	echo "恢复失败。。"
fi

