#!/usr/bin/bash

connection=30
thread=16
duration=1m
# address = "http://192.168.200.111/"

if [ $# -ne 1 ];then
    exit 1
fi

for ((i=0; i<10; i++))
do
  siege -c 255 -t 1S $1 #| grep availability
done