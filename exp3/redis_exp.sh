#!/bin/bash

clents=2
pipeline=2
requests=2
# address=http://192.168.200.111/

if [ $# -ne 1 ];then
    exit 1
fi

redis-benchmark -h $1 -c $clents -P $pipeline -r 100000 -t get -n $requests --csv
# redis-cli -h $1 PING > /dev/null
