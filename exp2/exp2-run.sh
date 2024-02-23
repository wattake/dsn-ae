#!/bin/bash


if [ $# -ne 1 ];then
    exit 1
fi

# components=(
#     "process"
#     "vfs"
#     "lwip"
#     "9pfs"
#     "fsm"
#     "netm"
# )
component=$1


cd vp-nginx

make addbr

sleep 5 && ./../wget_req.sh 1000 &
make run CMP=${component}

make delbr
