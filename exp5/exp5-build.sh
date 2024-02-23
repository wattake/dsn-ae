#!/bin/bash

apps=(
    "redis"
)

cd vp-redis

for app in "${apps[@]}"; do
    cp das-${app}-config .config
    make # for das
done

cd ../uk-redis

for app in "${apps[@]}"; do
    cp ${app}-config .config
    make
done
