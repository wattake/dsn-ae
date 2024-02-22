#!/bin/bash
cd vp-nginx
make clean
rm -f build/*-nginx_*

cd ../uk-nginx
make clean
rm -f build/*-nginx_*
