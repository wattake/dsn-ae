#!/usr/bin/bash

# address = "http://192.168.200.111/"

if [ $# -ne 1 ];then
    exit 1
fi

for ((i=0; i<20; i++))
do
  siege -c 100 -t 1s $1 | grep availability
done