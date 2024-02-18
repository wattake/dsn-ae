#!/bin/bash
cd vp-app
make clean
rm -f build/*-sqlite_*
rm -f build/*-redis_*
rm -f build/*-nginx_*

cd ../uk-app
make clean
rm -f build/*-sqlite_*
rm -f build/*-redis_*
rm -f build/*-nginx_*
