#!/bin/bash


oses=(
    "vp"
    "das"
    "fsm"
    "netm"
)


apps=(
    "sqlite"
    "nginx"
    "redis"
    "httpreply"
)


cd vp-app

make addbr

for os in "${oses[@]}"; do
    for app in "${apps[@]}"; do
        # if [ ${app} = "nginx" ] || [ ${app} = "redis" ]; then
        if [ ${app} = "sqlite" ]; then
            cp ./sqlite-fs/test_org.db ./sqlite-fs/test.db
            chmod 777 ./sqlite-fs/test.db
            # there is no client-tool for sqlite
        fi
        if [ ${app} = "nginx" ]; then
            # sleep 5 && ./../nginx_exp.sh http://172.44.0.2 &
            make run OS=${os} APP=${app} BRG=br0 GADDR=192.168.200.1 ADDR=192.168.200.111 # remote
        fi
        if [ ${app} = "redis" ]; then
            sleep 10 && ./../redis_exp.sh 172.44.0.1 &
        fi
        if [ ${app} = "httpreply" ]; then
            # sleep 5 && ./../httpreply_exp.sh http://172.44.0.2:8123 &
            make run-${app} OS=${os} APP=${app} BRG=br0 GADDR=192.168.200.1 ADDR=192.168.200.111 #remote
        fi

        make run-${app} OS=${os} APP=${app}
    done
done

cd ../uk-app

os=uk

for app in "${apps[@]}"; do
    # if [ ${app} = "nginx" ] || [ ${app} = "redis" ]; then
    if [ ${app} = "sqlite" ]; then
        # cp ./sqlite-fs/test_org.db ./sqlite-fs/test.db
        # chmod 777 ./sqlite-fs/test.db
        make run-${app} OS=${os} APP=${app}
        # there is no client-tool for sqlite
    fi
    if [ ${app} = "nginx" ]; then
        # sleep 5 && ./../nginx_exp.sh http://172.44.0.2 &
        make run OS=${os} APP=${app} BRG=br0 GADDR=192.168.200.1 ADDR=192.168.200.111 # remote
    fi
    if [ ${app} = "redis" ]; then
        sleep 10 && ./../redis_exp.sh 172.44.0.1 &
    fi
    if [ ${app} = "httpreply" ]; then
        # sleep 5 && ./../httpreply_exp.sh http://172.44.0.2:8123 &
        make run-${app} OS=${os} APP=${app} BRG=br0 GADDR=192.168.200.1 ADDR=192.168.200.111 #remote
    fi
    # make run-${app} OS=${os} APP=${app}
done

make delbr
