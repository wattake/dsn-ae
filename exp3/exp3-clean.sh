#!/bin/bash
cd vp-app
cp sqlite-config .config
make clean
cp nginx-config .config
make clean
cp redis-config .config
make clean

# rm -f build/*-sqlite_*
# rm -f build/*-redis_*
# rm -f build/*-nginx_*