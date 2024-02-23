#!/bin/bash

os=$1

if [ ${os} = "uk" ]; then
    cd uk-redis
else
    cd vp-redis
fi


make addbr
sleep 5 && python3 ./../exp5-req.py &
if [ ${os} = "uk" ]; then
    for i in 0 1
    do
        make run-redis OS=${os} APP=redis 
        # make run-redis OS=${os} APP=redis BRG=br0 GADDR=192.168.200.1 ADDR=192.168.200.111 #remote
    done
else
    make run-redis OS=${os} APP=redis 
    # make run-redis OS=${os} APP=redis BRG=br0 GADDR=192.168.200.1 ADDR=192.168.200.111 #remote
fi
make delbr
