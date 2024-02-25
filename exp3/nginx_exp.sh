#!/bin/bash
connection=40
thread=25
duration=1m
# address = "http://192.168.200.111/"

if [ $# -ne 1 ];then
    exit 1
fi

wrk -c$connection -t$thread -d$duration $1