#!/bin/bash
ps aux | grep gbk_utf8.sh | awk '{print "kill -9",$2}' | bash
