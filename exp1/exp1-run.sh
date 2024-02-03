#!/bin/bash

syscalls=(
    "getpid"
    "open"
    "read"
    "write"
    "close"
    "sockread"
    "sockwrite"
)
oses=(
    "vp"
    "nosals"
    "das"
    "netm"
    "fsm"
)



cd uk-syscall

sudo make addbr

for syscall in "${syscalls[@]}"; do
    if [ ${syscall} = "sockread" ] || [ ${syscall} = "sockwrite" ]; then
        sleep 5 && ./../wget_req.sh 100 &
    fi
    sudo make run SYSCALL=${syscall}
done

cd ..
cd vp-syscall

for os in "${oses[@]}"; do
    for syscall in "${syscalls[@]}"; do
        if [ ${syscall} = "sockread" ] || [ ${syscall} = "sockwrite" ]; then
            if [ ${os} != "nosals" ]; then
                sleep 5 && ./../wget_req.sh 101 & # 100 exec for performance + 1 exec for log entries
            else
                sleep 5 && ./../wget_req.sh 1 & # 1 exec for log entries
            fi
        fi
        sudo make run OS=${os} SYSCALL=${syscall}
    done
done

sudo make delbr
