#用于 zabbix 告警

import re
import sys
import time
import subprocess
from datetime import datetime
from io import StringIO
def main(domain):
f = StringIO()
comm = f"curl -Ivs https://{domain} --connect-timeout 10"
result = subprocess.getstatusoutput(comm)
f.write(result[1])
try:
	m = re.search('start date: (.*?)\n.*?expire date: (.*?)\n.*?common name:
	(.*?)\n.*?issuer: CN=(.*?)\n', f.getvalue(), re.S)
	start_date = m.group(1)
	expire_date = m.group(2)
	common_name = m.group(3)
	issuer = m.group(4)
except Exception as e:
	return 999999999
	# time 字符串转时间数组
	start_date = time.strptime(start_date, "%b %d %H:%M:%S %Y GMT")
	start_date_st = time.strftime("%Y-%m-%d %H:%M:%S", start_date)
	# datetime 字符串转时间数组
	expire_date = datetime.strptime(expire_date, "%b %d %H:%M:%S %Y GMT")
	expire_date_st = datetime.strftime(expire_date,"%Y-%m-%d %H:%M:%S")
	# 剩余天数
	remaining = (expire_date-datetime.now()).days
	return remaining
if __name__ == "__main__":
	domain = sys.argv[1]
	remaining_days = main(domain)
	print(remaining_days)