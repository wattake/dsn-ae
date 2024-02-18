#!/bin/bash


oses=(
    "vp"
    # "das"
    # "fsm"
    # "netm"
)


apps=(
    # "sqlite"
    # "nginx"
    # "redis"
    "httpreply"
)


cd vp-app

sudo make addbr

for os in "${oses[@]}"; do
    for app in "${apps[@]}"; do
        # if [ ${app} = "nginx" ] || [ ${app} = "redis" ]; then
        if [ ${app} = "sqlite" ]; then
            cp ./sqlite-fs/test_org.db ./sqlite-fs/test.db
            chmod 777 ./sqlite-fs/test.db
            # there is no client-tool for sqlite
        fi
        if [ ${app} = "nginx" ]; then
            sleep 5 && ./../nginx_exp.sh http://172.44.0.2 &
        # sudo make run OS=${os} APP=${app} GADDR=192.168.200.1 ADDR=192.168.200.111 # remote
        fi
        if [ ${app} = "redis" ]; then
            sleep 10 && ./../redis_exp.sh 172.44.0.1 &
        fi
        if [ ${app} = "httpreply" ]; then
            sleep 5 && ./../httpreply_exp.sh http://172.44.0.2:8123 &
        # sudo make run OS=${os} APP=${app} GADDR=192.168.200.1 ADDR=192.168.200.111 # remote
        fi

        sudo make run-${app} OS=${os} APP=${app}
    done
done

sudo make delbr
