#!/bin/bash
if [ $# -ne 1 ];then
    exit 1
fi

siege -c 1 -r $1 172.44.0.2:8123 > /dev/null
