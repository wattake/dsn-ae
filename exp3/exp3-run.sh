#!/bin/bash

if [ $# -ne 2 ];then
    exit 1
fi

os=$1
app=$2

# oses=(
#     "uk"
#     "vp"
#     "das"
#     "fsm"
#     "netm"
# )


# apps=(
#     "sqlite"
#     "nginx"
#     "nginx-separate"
#     "redis"
#     "redis-separate"
#     "httpreply"
#     "httpreply-separate"
# )


if [ ${os} = "uk" ]; then
    cd uk-app
else
    cd vp-app
fi

if [ ${app} = "sqlite" ]; then
    make run-${app} OS=${os} APP=${app}
fi
if [ ${app} = "nginx" ]; then
    make addbr
    sleep 10 && ./../nginx_exp.sh http://172.44.0.2 &
    make run-nginx OS=${os} APP=nginx # remote
    make delbr
fi
if [ ${app} = "nginx-separate" ]; then
    make run-nginx OS=${os} APP=${app} BRG=br0 GADDR=192.168.200.1 ADDR=192.168.200.111 # remote
fi
if [ ${app} = "redis" ]; then
    make addbr
    sleep 10 && ./../redis_exp.sh 172.44.0.2 &
    make run-redis OS=${os} APP=redis
    make delbr
fi
if [ ${app} = "redis-separate" ]; then
    make run-redis OS=${os} APP=redis BRG=br0 GADDR=192.168.200.1 ADDR=192.168.200.111 #remote
fi
if [ ${app} = "httpreply" ]; then
    make addbr
    sleep 5 && ./../httpreply_exp.sh http://172.44.0.2:8123 &
    make run-httpreply OS=${os} APP=httpreply
    make delbr
fi
if [ ${app} = "httpreply-separate" ]; then
    make run-httpreply OS=${os} APP=httpreply BRG=br0 GADDR=192.168.200.1 ADDR=192.168.200.111 #remote
fi
