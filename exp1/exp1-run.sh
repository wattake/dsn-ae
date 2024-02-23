#!/bin/bash

# oses=(
#     "vp"
#     "nosals"
#     "das"
#     "netm"
#     "fsm"
# )

# syscalls=(
#     "getpid"
#     "open"
#     "read"
#     "write"
#     "close"
#     "sockread"
#     "sockwrite"
# )


if [ $# -ne 2 ];then
    exit 1
fi

os=$1
syscall=$2


if [ ${os} = "uk" ]; then
    cd uk-syscall
else
    cd vp-syscall
fi

make addbr

if [ ${syscall} = "sockread" ] || [ ${syscall} = "sockwrite" ]; then
    if [ ${os} != "nosals" ]; then
        sleep 5 && ./../wget_req.sh 101 & # 100 exec for performance + 1 exec for log entries
    else
        sleep 5 && ./../wget_req.sh 1 & # 1 exec for log entries
    fi
fi
make run OS=${os} SYSCALL=${syscall}

make delbr

# cd ..
# cd vp-syscall

# for os in "${oses[@]}"; do
#     for syscall in "${syscalls[@]}"; do
#         if [ ${syscall} = "sockread" ] || [ ${syscall} = "sockwrite" ]; then
#             if [ ${os} != "nosals" ]; then
#                 sleep 5 && ./../wget_req.sh 101 & # 100 exec for performance + 1 exec for log entries
#             else
#                 sleep 5 && ./../wget_req.sh 1 & # 1 exec for log entries
#             fi
#         fi
#         sudo make run OS=${os} SYSCALL=${syscall}
#     done
# done
