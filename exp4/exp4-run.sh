#!/bin/bash

if [ $# -ne 1 ];then
    exit 1
fi

os=$1


if [ ${os} = "uk" ]; then
    cd uk-nginx
else
    cd vp-nginx
fi


make addbr
sleep 5 && ./../nginx_siege.sh http://172.44.0.2 &
if [ ${os} = "uk" ]; then
    for i in 0 1
    do
        make run-nginx OS=${os} APP=nginx # remote
    done
else
    make run-nginx OS=${os} APP=nginx # remote
fi
make delbr
