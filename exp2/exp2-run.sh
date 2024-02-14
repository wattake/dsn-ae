#!/bin/bash

components=(
    "process"
    "vfs"
    "lwip"
    "9pfs"
    "fsm"
    "netm"
)


cd vp-nginx

sudo make addbr

for component in "${components[@]}"; do
    sleep 5 && ./../wget_req.sh 1000 &
    sudo make run CMP=${component}
done

sudo make delbr
