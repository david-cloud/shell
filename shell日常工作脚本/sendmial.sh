#!/bin/bash
#auth=wang
#time=2018-06-12
from=****@****.com
to=****@****.com
passwd=C9E3fcC2DDfiYAFE

host=`hostname -I | awk '{print $2}'`
body="openvpn is connection failed"



/usr/local/bin/sendEmail -f $from -t $to -u "warming" -s smtp.exmail.qq.com -o message-content-type=html -o message-charset=utf8 -xu $to -xp $passwd -m "$host $body"
