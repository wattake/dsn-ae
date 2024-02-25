#!/bin/bash

clients=6
pipeline=4
threads=4
requests=1000000
# address=http://192.168.200.111/

if [ $# -ne 1 ];then
    exit 1
fi

redis-benchmark -h $1 -c $clients --threads $threads -P $pipeline -r 100000 -t set -n $requests --csv
# redis-cli -h $1 PING > /dev/null
