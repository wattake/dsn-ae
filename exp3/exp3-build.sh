#!/bin/bash



apps=(
    "sqlite"
    "nginx"
    "redis"
    "httpreply"
)

cd vp-app

for app in "${apps[@]}"; do
    if [ ${app} = "httpreply" ]; then
        sed -i "1a APP_SRCS-y += \$(APP_BASE)/main.c" Makefile.uk
    fi

    cp vp-${app}-config .config
    make clean
    
    sed -i "s/CONFIG_UK_DEFNAME=".*"/CONFIG_UK_DEFNAME=\"vp-${app}\"/g" .config
    sed -i "s/CONFIG_UK_NAME=".*"/CONFIG_UK_NAME=\"vp-${app}\"/g" .config
    make
    
    cp das-${app}-config .config
    make # for das

    sed -i "s/# CONFIG_LIBVAMPOS_MERGE_FS.*/CONFIG_LIBVAMPOS_MERGE_FS=y/g" .config
    sed -i "s/CONFIG_UK_DEFNAME=".*"/CONFIG_UK_DEFNAME=\"fsm-${app}\"/g" .config
    sed -i "s/CONFIG_UK_NAME=".*"/CONFIG_UK_NAME=\"fsm-${app}\"/g" .config
    make # for fsm
    sed -i "s/CONFIG_LIBVAMPOS_MERGE_FS=y/# CONFIG_LIBVAMPOS_MERGE_FS is not set/g" .config

    sed -i "s/# CONFIG_LIBVAMPOS_MERGE_NET.*/CONFIG_LIBVAMPOS_MERGE_NET=y/g" .config
    sed -i "s/CONFIG_UK_DEFNAME=".*"/CONFIG_UK_DEFNAME=\"netm-${app}\"/g" .config
    sed -i "s/CONFIG_UK_NAME=".*"/CONFIG_UK_NAME=\"netm-${app}\"/g" .config
    make # for netm
    sed -i "s/CONFIG_LIBVAMPOS_MERGE_NET=y/# CONFIG_LIBVAMPOS_MERGE_NET is not set/g" .config

    if [ ${app} = "httpreply" ]; then
        sed -i "2d" Makefile.uk
    fi
done
