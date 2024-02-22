#!/bin/bash

apps=(
    "nginx"
)

cd vp-nginx

for app in "${apps[@]}"; do
    cp das-${app}-config .config
    make # for das
done

cd ../uk-nginx

for app in "${apps[@]}"; do
    cp ${app}-config .config
    make
done
