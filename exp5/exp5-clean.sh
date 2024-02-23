#!/bin/bash
cd vp-redis
make clean
rm -f build/*-redis_*

cd ../uk-redis
make clean
rm -f build/*-redis_*
